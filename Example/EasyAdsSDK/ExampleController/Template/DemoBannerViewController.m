//
//  DemoBannerViewController.m
//  Example
//
//  Created by CherryKing on 2019/11/8.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "DemoBannerViewController.h"
#import <EasyAdsSDK/EasyAdBanner.h>
#import "AdDataJsonManager.h"
@interface DemoBannerViewController () <EasyAdBannerDelegate>
@property (nonatomic, strong) EasyAdBanner *EasyAdBanner;
@property (nonatomic, strong) UIView *contentV;

@end

@implementation DemoBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Banner";
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_banner];

    self.isOnlyLoad = NO;
}

- (void)loadAndShowAd{
    [super loadAndShowAd];
    if (!_contentV) {
        _contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width *5/32)];
        [self.view addSubview:self.contentV];
    }
    

    [self loadAdWithState:AdState_Normal];

    self.EasyAdBanner = [[EasyAdBanner alloc] initWithJsonDic:self.dic adContainer:_contentV viewController:self];
    self.EasyAdBanner.delegate = self;
    [self.EasyAdBanner loadAndShowAd];
    
    [self loadAdWithState:AdState_Loading];
}

- (void)deallocAd {
    self.contentV = nil;
    self.EasyAdBanner = nil;
    self.EasyAdBanner.delegate = nil;
}

// MARK: ======================= EasyAdBannerDelegate =======================
/// 广告数据拉取成功回调
- (void)easyAdUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告拉取成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
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
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载时调用", __func__]];

}

/// 广告曝光
- (void)easyAdExposured {
    NSLog(@"广告曝光回调 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光成功", __func__]];
}

/// 广告点击
- (void)easyAdClicked {
    NSLog(@"广告点击 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
}

/// 广告关闭回调
- (void)easyAdDidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭了", __func__]];

}

- (void)easyAdSuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}


@end
