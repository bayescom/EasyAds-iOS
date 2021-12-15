//
//  AdDataJsonManager.m
//  EasyAdsSDK_Example
//
//  Created by MS on 2021/10/26.
//  Copyright © 2021 Cheng455153666. All rights reserved.
//

#import "AdDataJsonManager.h"

@implementation AdDataJsonManager
static AdDataJsonManager *manager = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AdDataJsonManager alloc] init];
    });
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}

//自定义初始化方法
- (instancetype)init {
    self = [super init];
    if(self) {

    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (id)copy {
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (id)mutableCopy {
    return self;
}

//自定义描述信息，用于log详细打印
- (NSString *)description {
    return @"倍业极简版聚合SDK, 该类用来管理广告请求策略的数据";
}

/* * * * * * * * * * * 方法 * * * * * * * * * * */
- (NSDictionary *)loadAdDataWithType:(JsonDataType)type {
    NSString *jsonName = nil;
    
    switch (type) {
        case JsonDataType_splash:
            jsonName = @"SplashData";
            break;
        case JsonDataType_banner:
            jsonName = @"BannerData";
            break;
        case JsonDataType_fullScreenVideo:
            jsonName = @"FullScreenVideoData";
            break;
        case JsonDataType_interstitial:
            jsonName = @"InterstitialData";
            break;
        case JsonDataType_nativeExpress:
            jsonName = @"NativeExpressData";
            break;
        case JsonDataType_rewardVideo:
            jsonName = @"RewardVideoData";
            break;
        default:
            break;
    }
    
    return [self loadAdDataWithJsonName:jsonName];
}

- (NSDictionary *)loadAdDataWithJsonName:(NSString *)jsonName {
    if (!jsonName) {
        return nil;
    }
    
    @try {
        NSString *path = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    } @catch (NSException *exception) {}
}


@end
