//
//  AdDataJsonManager.h
//  EasyAdsSDK_Example
//
//  Created by MS on 2021/10/26.
//  Copyright © 2021 Cheng455153666. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    JsonDataType_splash,
    JsonDataType_banner,
    JsonDataType_fullScreenVideo,
    JsonDataType_interstitial,
    JsonDataType_nativeExpress,
    JsonDataType_rewardVideo,
} JsonDataType;

@interface AdDataJsonManager : NSObject
+ (instancetype)shared;

- (NSDictionary *)loadAdDataWithType:(JsonDataType)type;

@end

NS_ASSUME_NONNULL_END
