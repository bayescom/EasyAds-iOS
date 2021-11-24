
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, EasyAdEncodingType) {
    EasyAdEncodingTypeMask       = 0xFF, ///< mask of type value
    EasyAdEncodingTypeUnknown    = 0, ///< unknown
    EasyAdEncodingTypeVoid       = 1, ///< void
    EasyAdEncodingTypeBool       = 2, ///< bool
    EasyAdEncodingTypeInt8       = 3, ///< char / BOOL
    EasyAdEncodingTypeUInt8      = 4, ///< unsigned char
    EasyAdEncodingTypeInt16      = 5, ///< short
    EasyAdEncodingTypeUInt16     = 6, ///< unsigned short
    EasyAdEncodingTypeInt32      = 7, ///< int
    EasyAdEncodingTypeUInt32     = 8, ///< unsigned int
    EasyAdEncodingTypeInt64      = 9, ///< long long
    EasyAdEncodingTypeUInt64     = 10, ///< unsigned long long
    EasyAdEncodingTypeFloat      = 11, ///< float
    EasyAdEncodingTypeDouble     = 12, ///< double
    EasyAdEncodingTypeLongDouble = 13, ///< long double
    EasyAdEncodingTypeObject     = 14, ///< id
    EasyAdEncodingTypeClass      = 15, ///< Class
    EasyAdEncodingTypeSEL        = 16, ///< SEL
    EasyAdEncodingTypeBlock      = 17, ///< block
    EasyAdEncodingTypePointer    = 18, ///< void*
    EasyAdEncodingTypeStruct     = 19, ///< struct
    EasyAdEncodingTypeUnion      = 20, ///< union
    EasyAdEncodingTypeCString    = 21, ///< char*
    EasyAdEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    EasyAdEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    EasyAdEncodingTypeQualifierConst  = 1 << 8,  ///< const
    EasyAdEncodingTypeQualifierIn     = 1 << 9,  ///< in
    EasyAdEncodingTypeQualifierInout  = 1 << 10, ///< inout
    EasyAdEncodingTypeQualifierOut    = 1 << 11, ///< out
    EasyAdEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    EasyAdEncodingTypeQualifierByref  = 1 << 13, ///< byref
    EasyAdEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    EasyAdEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    EasyAdEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    EasyAdEncodingTypePropertyCopy         = 1 << 17, ///< copy
    EasyAdEncodingTypePropertyRetain       = 1 << 18, ///< retain
    EasyAdEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    EasyAdEncodingTypePropertyWeak         = 1 << 20, ///< weak
    EasyAdEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    EasyAdEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    EasyAdEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

EasyAdEncodingType EasyAdEncodingGetType(const char *typeEncoding);

@interface EasyAdClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) EasyAdEncodingType type;    ///< Ivar's type

- (instancetype)initWithIvar:(Ivar)ivar;
@end


/**
 Method information.
 */
@interface EasyAdClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 ///< method name
@property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector
@property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type
- (instancetype)initWithMethod:(Method)method;
@end


/**
 Property information.
 */
@interface EasyAdClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) EasyAdEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

- (instancetype)initWithProperty:(objc_property_t)property;
@end


/**
 Class information for a class.
 */
@interface EasyAdClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) EasyAdClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, EasyAdClassIvarInfo *> *ivarInfos; ///< ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, EasyAdClassMethodInfo *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, EasyAdClassPropertyInfo *> *propertyInfos; ///< properties
- (void)setNeedUpdate;

- (BOOL)needUpdate;

+ (nullable instancetype)classInfoWithClass:(Class)cls;

+ (nullable instancetype)classInfoWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
