//
//  DemoSplashViewController.m
//  AAA
//
//  Created by CherryKing on 2019/11/1.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "DemoSplashViewController.h"
#import <EasyAdsSDK/EasyAdSplash.h>
#import "AdDataJsonManager.h"
@interface DemoSplashViewController () <EasyAdSplashDelegate>
@property(strong,nonatomic) EasyAdSplash *EasyAdSplash;
@end

@implementation DemoSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开屏广告";
    self.isOnlyLoad = NO;
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_splash];
    NSLog(@"%@", self.dic);

}

- (void)loadAndShowAd {
    [super loadAndShowAd];
    [self loadAndShowSplashAd];
}



- (void)deallocAd {
    self.EasyAdSplash = nil;
    self.EasyAdSplash.delegate = nil;
}

- (void)loadAndShowSplashAd{
    // 广告实例不要用初始化加载, 要确保每次都用最新的实例, 且一次广告流程中 delegate 不能发生变化
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];

    self.EasyAdSplash = [self returnAdInstance];
    [self.EasyAdSplash loadAndShowAd];
    
    [self loadAdWithState:AdState_Loading];

}

- (EasyAdSplash *)returnAdInstance {
    EasyAdSplash *splash = [[EasyAdSplash alloc] initWithJsonDic:self.dic viewController:self];
    splash.delegate = self;
    splash.showLogoRequire = YES;
    splash.logoImage = [UIImage imageNamed:@"app_logo"];
    splash.backgroundImage = [UIImage imageNamed:@"LaunchImage_img"];
    splash.timeout = 5;
    return splash;
}

// MARK: ======================= EasyAdSplashDelegate =======================
/// 广告数据拉取成功
- (void)easyAdUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告拉取成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
}

/// 广告曝光成功
- (void)easyAdExposured {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光成功", __func__]];
    NSLog(@"广告曝光成功 %s", __func__);
}

/// 广告加载失败
- (void)easyAdFailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error, description);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self showErrorWithDescription:description];
    
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];

}

/// 内部渠道开始加载时调用
- (void)easyAdSupplierWillLoad:(NSString *)supplierId {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载时调用", __func__]];
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);

}
/// 广告点击
- (void)easyAdClicked {
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
    NSLog(@"广告点击 %s", __func__);
}

/// 广告关闭
- (void)easyAdDidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭", __func__]];
    [self loadAdWithState:AdState_Normal];
    [self deallocAd];
}

/// 广告倒计时结束
- (void)easyAdSplashOnAdCountdownToZero {
    NSLog(@"广告倒计时结束 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告倒计时结束", __func__]];
}

/// 点击了跳过
- (void)easyAdSplashOnAdSkipClicked {
    NSLog(@"点击了跳过 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 点击了跳过", __func__]];
    [self loadAdWithState:AdState_Normal];
    [self deallocAd];
}

- (void)easyAdSuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}



@end
