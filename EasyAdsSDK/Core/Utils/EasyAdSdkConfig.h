//
//  EasyAdSdkConfig.h
//  advancelib
//
//  Created by allen on 2019/9/12.
//  Copyright © 2019 Bayescom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,EasyAdLogLevel) {
    EasyAdLogLevel_None  = 0, // 不打印
    EasyAdLogLevel_Fatal,
    EasyAdLogLevel_Error,
    EasyAdLogLevel_Warning,
    EasyAdLogLevel_Info,
    EasyAdLogLevel_Debug,
};


// MARK: ======================= SDK =======================
extern NSString *const AdvanceSdkVersion;

extern NSString *const SDK_TAG_GDT;
extern NSString *const SDK_TAG_CSJ;
extern NSString *const SDK_TAG_KS;
extern NSString *const SDK_TAG_BAIDU;

extern NSString *const EasyAdSdkTypeAdName;
extern NSString *const EasyAdSdkTypeAdNameSplash;
extern NSString *const EasyAdSdkTypeAdNameBanner;
extern NSString *const EasyAdSdkTypeAdNameInterstitial;
extern NSString *const EasyAdSdkTypeAdNameFullScreenVideo;
extern NSString *const EasyAdSdkTypeAdNameNativeExpress;
extern NSString *const EasyAdSdkTypeAdNameRewardVideo;

@interface EasyAdSdkConfig : NSObject
/// SDK版本
+ (NSString *)sdkVersion;

+ (instancetype)shareInstance;

/// 控制台log级别
/// 0 不打印
/// 1 打印fatal
/// 2 fatal + error
/// 3 fatal + error + warning
/// 4 fatal + error + warning + info
/// 5 全部打印
@property (nonatomic, assign) EasyAdLogLevel level;

@end

NS_ASSUME_NONNULL_END
