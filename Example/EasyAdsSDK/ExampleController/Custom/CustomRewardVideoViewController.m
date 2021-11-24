//
//  CustomRewardVideoViewController.m
//  AdvanceSDKCustom
//
//  Created by CherryKing on 2020/1/3.
//  Copyright © 2020 BAYESCOM. All rights reserved.
//

#import "CustomRewardVideoViewController.h"
#import "DemoUtils.h"

#import <GDTRewardVideoAd.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MercurySDK/MercuryRewardVideoAd.h>

#import "AdvanceSDK.h"

@interface CustomRewardVideoViewController () <AdvanceBaseAdspotDelegate, GDTRewardedVideoAdDelegate, BUNativeExpressRewardedVideoAdDelegate, MercuryRewardVideoAdDelegate>
@property (nonatomic, strong) AdvanceBaseAdspot *adspot;

@property (nonatomic, strong) GDTRewardVideoAd *gdt_ad;
@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *csj_ad;
@property (nonatomic, strong) MercuryRewardVideoAd *mercury_ad;
@property (nonatomic) bool isAdLoaded;

@end

@implementation CustomRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"激励视频", @"adspotId": @"100255-10002595"},
    ];
    self.btn1Title = @"加载广告";
    self.btn2Title = @"显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    
    _adspot = [[AdvanceBaseAdspot alloc] initWithAdspotId:self.adspotId];
    [_adspot setDefaultAdvSupplierWithMediaId:@"100255"
                                adspotId:@"10002595"
                                mediaKey:@"757d5119466abe3d771a211cc1278df7"
                                  sdkId:SDK_ID_MERCURY];
    _adspot.supplierDelegate = self;
    _isAdLoaded=false;
    [_adspot loadAd];
}

- (void)loadAdBtn2Action {
    if (!_isAdLoaded) {
        [JDStatusBarNotification showWithStatus:@"请先加载广告" dismissAfter:1.5];
    }
    if ([_adspot.currentAdvSupplier.identifier isEqualToString:SDK_ID_GDT]) {
        [_gdt_ad showAdFromRootViewController:self];
    } else if ([_adspot.currentAdvSupplier.identifier isEqualToString:SDK_ID_CSJ]) {
        [_csj_ad showAdFromRootViewController:self];
    } else if ([_adspot.currentAdvSupplier.identifier isEqualToString:SDK_ID_MERCURY]) {
        [_mercury_ad showAdFromVC:self];
    }
}

// MARK: ======================= AdvanceBaseAdspotDelegate =======================
/// 加载渠道广告，将会返回渠道所需参数
/// @param sdkId 渠道Id
/// @param params 渠道参数
- (void)advanceBaseAdspotWithSdkId:(NSString *)sdkId params:(NSDictionary *)params {
    // 根据渠道id自定义初始化
    if ([sdkId isEqualToString:SDK_ID_GDT]) {
        _gdt_ad = [[GDTRewardVideoAd alloc] initWithPlacementId:[params objectForKey:@"adspotid"]];
        _gdt_ad.delegate = self;
        [_gdt_ad loadAd];
    } else if ([sdkId isEqualToString:SDK_ID_CSJ]) {
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = @"123";
        _csj_ad = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:[params objectForKey:@"adspotid"] rewardedVideoModel:model];
        _csj_ad.delegate = self;
        [_csj_ad loadAdData];
    } else if ([sdkId isEqualToString:SDK_ID_MERCURY]) {
        _mercury_ad = [[MercuryRewardVideoAd alloc] initAdWithAdspotId:[params objectForKey:@"adspotid"] delegate:self];
        [_mercury_ad loadRewardVideoAd];
    }
}

// MARK: ======================= MercuryRewardVideoAdDelegate =======================
/// 广告数据加载成功回调
- (void)mercury_rewardVideoAdDidLoad {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告数据加载成功回调");
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];

}

/// 广告加载失败回调
- (void)mercury_rewardAdFailError:(nullable NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _mercury_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"广告加载失败回调");
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];

}

// 视频缓存成功回调
- (void)mercury_rewardVideoAdVideoDidLoad {
    NSLog(@"视频缓存成功回调");
}

/// 视频广告曝光回调
- (void)mercury_rewardVideoAdDidExposed {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"视频广告曝光回调");
}

/// 视频播放页关闭回调
- (void)mercury_rewardVideoAdDidClose {
    NSLog(@"视频播放页关闭回调");
}

/// 视频广告信息点击回调
- (void)mercury_rewardVideoAdDidClicked {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"视频广告信息点击回调");
}

/// 视频广告播放达到激励条件回调
- (void)mercury_rewardVideoAdDidRewardEffective {
    NSLog(@"视频广告播放达到激励条件回调");
}

/// 视频广告视频播放完成
- (void)mercury_rewardVideoAdDidPlayFinish {
    NSLog(@"视频广告视频播放完成");
}

// MARK: ======================= BUNativeExpressRewardedVideoAdDelegate =======================
/// 广告数据加载成功回调
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告数据加载成功回调");
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];
}

///
- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _csj_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"广告加载失败回调");
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];

}

// 视频缓存成功回调
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"视频缓存成功回调");
}

/// 视频广告曝光回调
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"视频广告曝光回调");
}

/// 视频播放页关闭回调
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"视频播放页关闭回调");
}

/// 视频广告信息点击回调
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"视频广告信息点击回调");
}

/// 播放完成
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"播放完成");
}

// MARK: ======================= GdtRewardVideoAdDelegate =======================
/// 广告数据加载成功回调
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告数据加载成功回调");
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];
}

/// 广告加载失败回调
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _gdt_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"广告加载失败回调");
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];
}

/// 视频广告曝光回调
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"视频广告曝光回调");
}

/// 视频广告信息点击回调
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"视频广告信息点击回调");
}

@end
