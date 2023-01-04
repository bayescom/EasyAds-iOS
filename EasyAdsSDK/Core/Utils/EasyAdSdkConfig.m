//
//  EasyAdSdkConfig.m
//  advancelib
//
//  Created by allen on 2019/9/12.
//  Copyright © 2019 Bayescom. All rights reserved.
//

#import "EasyAdSdkConfig.h"
#import "EasyAdLog.h"
@interface EasyAdSdkConfig ()
@property (nonatomic, strong) NSDictionary *config;

@end

@implementation EasyAdSdkConfig
NSString *const AdvanceSdkVersion = @"2.0.0";


NSString *const SDK_TAG_GDT=@"ylh";
NSString *const SDK_TAG_CSJ=@"csj";
NSString *const SDK_TAG_KS =@"ks";
NSString *const SDK_TAG_BAIDU=@"bd";

// MARK: ======================= 广告位类型名称 =======================
NSString * const EasyAdSdkTypeAdName = @"ADNAME";
NSString * const EasyAdSdkTypeAdNameSplash = @"SPLASH_AD";
NSString * const EasyAdSdkTypeAdNameBanner = @"BANNER_AD";
NSString * const EasyAdSdkTypeAdNameInterstitial = @"INTERSTAITIAL_AD";
NSString * const EasyAdSdkTypeAdNameFullScreenVideo = @"FULLSCREENVIDEO_AD";
NSString * const EasyAdSdkTypeAdNameNativeExpress = @"NATIVEEXPRESS_AD";
NSString * const EasyAdSdkTypeAdNameRewardVideo = @"REWARDVIDEO_AD";

static EasyAdSdkConfig *instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    //dispatch_once （If called simultaneously from multiple threads, this function waits synchronously until the block has completed. 由官方解释，该函数是线程安全的）
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (NSString *)sdkVersion {
    return AdvanceSdkVersion;
}

//保证从-alloc-init和-new方法返回的对象是由shareInstance返回的
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [EasyAdSdkConfig shareInstance];
}

//保证从copy获取的对象是由shareInstance返回的
- (id)copyWithZone:(struct _NSZone *)zone {
    return [EasyAdSdkConfig shareInstance];
}

//保证从mutableCopy获取的对象是由shareInstance返回的
- (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return [EasyAdSdkConfig shareInstance];
}


- (void)setLevel:(EasyAdLogLevel)level {
    _level = level;
}

@end
