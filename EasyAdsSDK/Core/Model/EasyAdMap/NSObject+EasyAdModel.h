
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (EasyAdModel)

+ (nullable instancetype)easyAd_modelWithJSON:(id)json;

+ (nullable instancetype)easyAd_modelWithDictionary:(NSDictionary *)dictionary;

- (BOOL)easyAd_modelSetWithJSON:(id)json;

- (BOOL)easyAd_modelSetWithDictionary:(NSDictionary *)dic;

- (nullable id)easyAd_modelToJSONObject;

- (nullable NSData *)easyAd_modelToJSONData;

- (nullable NSString *)easyAd_modelToJSONString;

- (nullable id)easyAd_modelCopy;

- (void)easyAd_modelEncodeWithCoder:(NSCoder *)aCoder;

- (id)easyAd_modelInitWithCoder:(NSCoder *)aDecoder;

- (NSUInteger)easyAd_modelHash;

- (BOOL)easyAd_modelIsEqual:(id)model;

- (NSString *)easyAd_modelDescription;

@end

@interface NSArray (EasyAdModel)

+ (nullable NSArray *)easyAd_modelArrayWithClass:(Class)cls json:(id)json;

@end

@interface NSDictionary (EasyAdModel)

+ (nullable NSDictionary *)easyAd_modelDictionaryWithClass:(Class)cls json:(id)json;
@end

@protocol EasyAdModel <NSObject>
@optional

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;

+ (nullable Class)modelCustomClassForDictionary:(NSDictionary *)dictionary;

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;

+ (nullable NSArray<NSString *> *)modelPropertyWhitelist;

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
