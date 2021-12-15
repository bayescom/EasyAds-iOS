//
//  CsjInterstitialAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "CsjInterstitialAdapter.h"

#if __has_include(<BUAdSDK/BUNativeExpressInterstitialAd.h>)
#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
#else
#import "BUNativeExpressInterstitialAd.h"
#endif

#import "EasyAdInterstitial.h"
#import "EasyAdLog.h"

@interface CsjInterstitialAdapter () <BUNativeExpresInterstitialAdDelegate>
@property (nonatomic, strong) BUNativeExpressInterstitialAd *csj_ad;
@property (nonatomic, weak) EasyAdInterstitial *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation CsjInterstitialAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = (EasyAdInterstitial *)adspot;
        _supplier = supplier;
        _csj_ad = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:_supplier.adspotId adSize:CGSizeMake(300, 450)];
    }
    return self;
}


- (void)loadAd {
    [super loadAd];
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载穿山甲 supplier: %@", _supplier);
    _csj_ad.delegate = self;
    [self.csj_ad loadAdData];
}

- (void)deallocAdapter {
    
}


- (void)showAd {
    [_csj_ad showAdFromRootViewController:_adspot.viewController];
}

- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

// MARK: ======================= BUNativeExpresInterstitialAdDelegate =======================
/// 插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
}

/// 插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数
- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    EAD_LEVEL_INFO_LOG(@"%@", error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];

    _csj_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdInterstitialOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdInterstitialOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
}

/// 插屏广告渲染失败
- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _csj_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdInterstitialOnAdRenderFailed)]) {
//        [self.delegate EasyAdInterstitialOnAdRenderFailed];
//    }
}


/// 插屏广告曝光回调
- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

/// 插屏广告点击回调
- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

/// 插屏广告曝光结束回调，插屏广告曝光结束回调该函数
- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/// 广告可以调用Show
- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

@end
