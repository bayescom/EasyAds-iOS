#import "BYExamCellModel.h"

#define λ(decl, expr) (^(decl) { return (expr); })

NS_ASSUME_NONNULL_BEGIN

@interface BYExamCellModelElement (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

BYExamCellModel *_Nullable BYExamCellModelFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : map(json, λ(id x, [BYExamCellModelElement fromJSONDictionary:x]));
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

BYExamCellModel *_Nullable BYExamCellModelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return BYExamCellModelFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable BYExamCellModelToData(BYExamCellModel *examCellModel, NSError **error)
{
    @try {
        id json = map(examCellModel, λ(id x, [x JSONDictionary]));
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable BYExamCellModelToJSON(BYExamCellModel *examCellModel, NSStringEncoding encoding, NSError **error)
{
    NSData *data = BYExamCellModelToData(examCellModel, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation BYExamCellModelElement
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"title": @"title",
        @"subtitle": @"subtitle",
        @"tag": @"tag",
        @"ctime": @"ctime",
        @"cellh": @"cellh",
        @"showtype": @"showtype",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[BYExamCellModelElement alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:BYExamCellModelElement.properties.allValues];
}
@end

NS_ASSUME_NONNULL_END
