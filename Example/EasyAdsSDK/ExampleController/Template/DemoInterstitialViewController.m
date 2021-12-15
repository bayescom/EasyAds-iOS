//
//  DemoInterstitialViewController.m
//  advancelib
//
//  Created by allen on 2019/12/31.
//  Copyright © 2019 Bayescom. All rights reserved.
//

#import "DemoInterstitialViewController.h"
#import <EasyAdsSDK/EasyAdInterstitial.h>
#import "AdDataJsonManager.h"
@interface DemoInterstitialViewController () <EasyAdInterstitialDelegate>
@property (nonatomic, strong) EasyAdInterstitial *EasyAdInterstitial;
@property (nonatomic) bool isAdLoaded;
@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation DemoInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_interstitial];
    self.title = @"插屏广告";

}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    
    
    self.EasyAdInterstitial = [[EasyAdInterstitial alloc] initWithJsonDic:self.dic viewController:self];
    self.EasyAdInterstitial.delegate = self;
    _isAdLoaded=false;
    [self.EasyAdInterstitial loadAd];

    
    [self loadAdWithState:AdState_Loading];
    
}

- (void)showAd {
    if (!self.EasyAdInterstitial || !self.isLoaded) {
        [JDStatusBarNotification showWithStatus:@"请先加载广告" dismissAfter:1.5];
        return;
    }
    [self.EasyAdInterstitial showAd];
    
}

- (void)loadAndShowAd {
    [super loadAndShowAd];
    [self loadAdWithState:AdState_Normal];

    self.EasyAdInterstitial = [[EasyAdInterstitial alloc] initWithJsonDic:self.dic viewController:self];
    self.EasyAdInterstitial.delegate = self;
    _isAdLoaded=false;
    [self.EasyAdInterstitial loadAndShowAd];
    
    
    [self loadAdWithState:AdState_Loading];

}

- (void)deallocAd {
    self.EasyAdInterstitial = nil;
    self.EasyAdInterstitial.delegate = nil;
    self.isLoaded = NO;
    [self loadAdWithState:AdState_Normal];
}

// MARK: ======================= EasyAdInterstitialDelegate =======================

/// 请求广告数据成功后调用
- (void)easyAdUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功 %s", __func__);
    self.isLoaded = YES;
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告数据拉取成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
//    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];
//    [self loadAdBtn2Action];
}

/// 广告曝光
- (void)easyAdExposured {
    NSLog(@"广告曝光回调 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光成功", __func__]];
}

/// 广告点击
- (void)easyAdClicked {
    NSLog(@"广告点击 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击成功", __func__]];

}

/// 广告加载失败
- (void)easyAdFailedWithError:(NSError *)error description:(NSDictionary *)description {
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error, description);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self showErrorWithDescription:description];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];

}



/// 内部渠道开始加载时调用
- (void)easyAdSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载", __func__]];

}

/// 广告关闭了
- (void)easyAdDidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭了", __func__]];
    [self deallocAd];
}

- (void)easyAdSuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}


@end
