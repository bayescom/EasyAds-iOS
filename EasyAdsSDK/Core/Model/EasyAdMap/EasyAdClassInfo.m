
#import "EasyAdClassInfo.h"
#import <objc/runtime.h>

EasyAdEncodingType EasyAdEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return EasyAdEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return EasyAdEncodingTypeUnknown;
    
    EasyAdEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= EasyAdEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= EasyAdEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= EasyAdEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= EasyAdEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= EasyAdEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= EasyAdEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= EasyAdEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }

    len = strlen(type);
    if (len == 0) return EasyAdEncodingTypeUnknown | qualifier;

    switch (*type) {
        case 'v': return EasyAdEncodingTypeVoid | qualifier;
        case 'B': return EasyAdEncodingTypeBool | qualifier;
        case 'c': return EasyAdEncodingTypeInt8 | qualifier;
        case 'C': return EasyAdEncodingTypeUInt8 | qualifier;
        case 's': return EasyAdEncodingTypeInt16 | qualifier;
        case 'S': return EasyAdEncodingTypeUInt16 | qualifier;
        case 'i': return EasyAdEncodingTypeInt32 | qualifier;
        case 'I': return EasyAdEncodingTypeUInt32 | qualifier;
        case 'l': return EasyAdEncodingTypeInt32 | qualifier;
        case 'L': return EasyAdEncodingTypeUInt32 | qualifier;
        case 'q': return EasyAdEncodingTypeInt64 | qualifier;
        case 'Q': return EasyAdEncodingTypeUInt64 | qualifier;
        case 'f': return EasyAdEncodingTypeFloat | qualifier;
        case 'd': return EasyAdEncodingTypeDouble | qualifier;
        case 'D': return EasyAdEncodingTypeLongDouble | qualifier;
        case '#': return EasyAdEncodingTypeClass | qualifier;
        case ':': return EasyAdEncodingTypeSEL | qualifier;
        case '*': return EasyAdEncodingTypeCString | qualifier;
        case '^': return EasyAdEncodingTypePointer | qualifier;
        case '[': return EasyAdEncodingTypeCArray | qualifier;
        case '(': return EasyAdEncodingTypeUnion | qualifier;
        case '{': return EasyAdEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return EasyAdEncodingTypeBlock | qualifier;
            else
                return EasyAdEncodingTypeObject | qualifier;
        }
        default: return EasyAdEncodingTypeUnknown | qualifier;
    }
}

@implementation EasyAdClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    const char *name = ivar_getName(ivar);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    _offset = ivar_getOffset(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        _type = EasyAdEncodingGetType(typeEncoding);
    }
    return self;
}

@end

@implementation EasyAdClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end

@implementation EasyAdClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [super init];
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    EasyAdEncodingType type = 0;
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T': { // Type encoding
                if (attrs[i].value) {
                    _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                    type = EasyAdEncodingGetType(attrs[i].value);
                    
                    if ((type & EasyAdEncodingTypeMask) == EasyAdEncodingTypeObject && _typeEncoding.length) {
                        NSScanner *scanner = [NSScanner scannerWithString:_typeEncoding];
                        if (![scanner scanString:@"@\"" intoString:NULL]) continue;
                        
                        NSString *clsName = nil;
                        if ([scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]) {
                            if (clsName.length) _cls = objc_getClass(clsName.UTF8String);
                        }
                        
                        NSMutableArray *protocols = nil;
                        while ([scanner scanString:@"<" intoString:NULL]) {
                            NSString* protocol = nil;
                            if ([scanner scanUpToString:@">" intoString: &protocol]) {
                                if (protocol.length) {
                                    if (!protocols) protocols = [NSMutableArray new];
                                    [protocols addObject:protocol];
                                }
                            }
                            [scanner scanString:@">" intoString:NULL];
                        }
                        _protocols = protocols;
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrs[i].value) {
                    _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'R': {
                type |= EasyAdEncodingTypePropertyReadonly;
            } break;
            case 'C': {
                type |= EasyAdEncodingTypePropertyCopy;
            } break;
            case '&': {
                type |= EasyAdEncodingTypePropertyRetain;
            } break;
            case 'N': {
                type |= EasyAdEncodingTypePropertyNonatomic;
            } break;
            case 'D': {
                type |= EasyAdEncodingTypePropertyDynamic;
            } break;
            case 'W': {
                type |= EasyAdEncodingTypePropertyWeak;
            } break;
            case 'G': {
                type |= EasyAdEncodingTypePropertyCustomGetter;
                if (attrs[i].value) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            case 'S': {
                type |= EasyAdEncodingTypePropertyCustomSetter;
                if (attrs[i].value) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } // break; commented for code coverage in next line
            default: break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    if (_name.length) {
        if (!_getter) {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}

@end

@implementation EasyAdClassInfo {
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _superCls = class_getSuperclass(cls);
    _isMeta = class_isMetaClass(cls);
    if (!_isMeta) {
        _metaCls = objc_getMetaClass(class_getName(cls));
    }
    _name = NSStringFromClass(cls);
    [self _update];

    _superClassInfo = [self.class classInfoWithClass:_superCls];
    return self;
}

- (void)_update {
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    Class cls = self.cls;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        _methodInfos = methodInfos;
        for (unsigned int i = 0; i < methodCount; i++) {
            EasyAdClassMethodInfo *info = [[EasyAdClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name) methodInfos[info.name] = info;
        }
        free(methods);
    }
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            EasyAdClassPropertyInfo *info = [[EasyAdClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) propertyInfos[info.name] = info;
        }
        free(properties);
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        _ivarInfos = ivarInfos;
        for (unsigned int i = 0; i < ivarCount; i++) {
            EasyAdClassIvarInfo *info = [[EasyAdClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name) ivarInfos[info.name] = info;
        }
        free(ivars);
    }
    
    if (!_ivarInfos) _ivarInfos = @{};
    if (!_methodInfos) _methodInfos = @{};
    if (!_propertyInfos) _propertyInfos = @{};
    
    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

- (BOOL)needUpdate {
    return _needUpdate;
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    EasyAdClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info && info->_needUpdate) {
        [info _update];
    }
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[EasyAdClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

@end
