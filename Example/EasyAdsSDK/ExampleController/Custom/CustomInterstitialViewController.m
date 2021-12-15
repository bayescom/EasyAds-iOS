//
//  CustomInterstitialViewController.m
//  advancelib
//
//  Created by allen on 2019/12/31.
//  Copyright © 2019 Bayescom. All rights reserved.
//

#import "CustomInterstitialViewController.h"
#import "DemoUtils.h"

#import <GDTUnifiedInterstitialAd.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MercurySDK/MercuryInterstitialAd.h>

#import "AdvanceSDK.h"

@interface CustomInterstitialViewController () <AdvanceBaseAdspotDelegate, GDTUnifiedInterstitialAdDelegate, BUNativeExpresInterstitialAdDelegate, MercuryInterstitialAdDelegate>
@property (nonatomic, strong) AdvanceBaseAdspot *adspot;

@property (nonatomic, strong) GDTUnifiedInterstitialAd *gdt_ad;
@property (nonatomic, strong) BUNativeExpressInterstitialAd *csj_ad;
@property (nonatomic, strong) MercuryInterstitialAd *mercury_ad;
@property (nonatomic) bool isAdLoaded;

@end

@implementation CustomInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"mediaId-adspotId", @"adspotId": @"100255-10000559"},
    ];
    self.btn1Title = @"加载广告";
    self.btn2Title = @"显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    _adspot = [[AdvanceBaseAdspot alloc] initWithAdspotId:self.adspotId];
    [_adspot setDefaultAdvSupplierWithMediaId:@"100255"
                                adspotId:@"10000559"
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
        [_gdt_ad presentAdFromRootViewController:self];
    } else if ([_adspot.currentAdvSupplier.identifier isEqualToString:SDK_ID_CSJ]) {
        [_csj_ad showAdFromRootViewController:self];
    } else if ([_adspot.currentAdvSupplier.identifier isEqualToString:SDK_ID_MERCURY]) {
        [_mercury_ad presentAdFromViewController:self];
    }
}

// MARK: ======================= AdvanceBaseAdspotDelegate =======================
/// 加载渠道广告，将会返回渠道所需参数
/// @param sdkId 渠道Id
/// @param params 渠道参数
- (void)advanceBaseAdspotWithSdkId:(NSString *)sdkId params:(NSDictionary *)params {
    // 根据渠道id自定义初始化
    if ([sdkId isEqualToString:SDK_ID_GDT]) {
        _gdt_ad = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:[params objectForKey:@"adspotid"]];
        
        _gdt_ad.delegate = self;
        [_gdt_ad loadAd];
    } else if ([sdkId isEqualToString:SDK_ID_CSJ]) {
        _csj_ad = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:@"900546270" adSize:CGSizeMake(300, 450)];
        _csj_ad.delegate = self;
        [_csj_ad loadAdData];
    } else if ([sdkId isEqualToString:SDK_ID_MERCURY]) {
        _mercury_ad = [[MercuryInterstitialAd alloc] initAdWithAdspotId:[params objectForKey:@"adspotid"] delegate:self];
        [_mercury_ad loadAd];
    }
}


// MARK: ======================= MercuryInterstitialAdDelegate =======================
/// 插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数
- (void)mercury_interstitialSuccess {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数");
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];


}

/// 插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数
- (void)mercury_interstitialFailError:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _mercury_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数");
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];

}

/// 插屏广告视图曝光失败回调，插屏广告曝光失败回调该函数
- (void)mercury_interstitialFailToPresent {
    NSLog(@"插屏广告视图曝光失败回调，插屏广告曝光失败回调该函数");
}

/// 插屏广告曝光回调
- (void)mercury_interstitialWillExposure {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"插屏广告曝光回调");
}

/// 插屏广告点击回调
- (void)mercury_interstitialClicked {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"插屏广告点击回调");
}

/// 插屏广告曝光结束回调，插屏广告曝光结束回调该函数
- (void)mercury_interstitialDidDismissScreen {
    NSLog(@" 插屏广告曝光结束回调，插屏广告曝光结束回调该函数");
}

// MARK: ======================= BUNativeExpresInterstitialAdDelegate =======================
/// 插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数");
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];


}

/// 插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数
- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _csj_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数");
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];

}

/// 插屏广告渲染失败
- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _csj_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"插屏广告渲染失败");
}


/// 插屏广告曝光回调
- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"插屏广告曝光回调");
}

/// 插屏广告点击回调
- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"插屏广告点击回调");
}

/// 插屏广告曝光结束回调，插屏广告曝光结束回调该函数
- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"插屏广告曝光结束回调，插屏广告曝光结束回调该函数");
}

// MARK: ======================= GdtInterstitialAdDelegate =======================
/// 插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数");
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];


}

/// 插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    _gdt_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数");
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];

}

/// 插屏广告曝光回调
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"插屏广告曝光回调");
}

/// 插屏广告点击回调
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"插屏广告点击回调");
}

/// 插屏广告曝光结束回调，插屏广告曝光结束回调该函数
- (void)unifiedInterstitialDidDismissScreen:(id)unifiedInterstitial {
    NSLog(@"插屏广告曝光结束回调，插屏广告曝光结束回调该函数");
}

@end
