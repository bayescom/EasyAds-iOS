//
//  GdtInterstitialAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "GdtInterstitialAdapter.h"

#if __has_include(<GDTUnifiedInterstitialAd.h>)
#import <GDTUnifiedInterstitialAd.h>
#else
#import "GDTUnifiedInterstitialAd.h"
#endif

#import "EasyAdInterstitial.h"
#import "EasyAdLog.h"

@interface GdtInterstitialAdapter () <GDTUnifiedInterstitialAdDelegate>
@property (nonatomic, strong) GDTUnifiedInterstitialAd *gdt_ad;
@property (nonatomic, weak) EasyAdInterstitial *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation GdtInterstitialAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = (EasyAdInterstitial *)adspot;
        _supplier = supplier;
        _gdt_ad = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:_supplier.adspotId];
    }
    return self;
}


- (void)loadAd {
    EAD_LEVEL_INFO_LOG(@"加载广点通 supplier: %@", _supplier);
    [super loadAd];
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"广点通 load ad");
    _gdt_ad.delegate = self;
    [_gdt_ad loadAd];

}

- (void)showAd {
    [_gdt_ad presentAdFromRootViewController:_adspot.viewController];
}

- (void)deallocAdapter {
    
}



- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}


// MARK: ======================= GdtInterstitialAdDelegate =======================
/// 插屏广告预加载成功回调，当接收服务器返回的广告数据成功且预加载后调用该函数
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
//    NSLog(@"广点通插屏拉取成功 %@",self.gdt_ad);

    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

/// 插屏广告预加载失败回调，当接收服务器返回的广告数据失败后调用该函数
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
    _gdt_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdInterstitialOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdInterstitialOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
}

/// 插屏广告曝光回调
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

- (void)unifiedInterstitialDidDownloadVideo:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
}

/// 插屏广告点击回调
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

/// 插屏广告曝光结束回调，插屏广告曝光结束回调该函数
- (void)unifiedInterstitialDidDismissScreen:(id)unifiedInterstitial {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

@end
