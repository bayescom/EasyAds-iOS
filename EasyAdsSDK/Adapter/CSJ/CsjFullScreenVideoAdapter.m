//
//  CsjFullScreenVideoAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/13.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "CsjFullScreenVideoAdapter.h"
#if __has_include(<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#else
#import "BUAdSDK.h"
#endif
#import "EasyAdFullScreenVideo.h"
#import "EasyAdLog.h"

@interface CsjFullScreenVideoAdapter () <BUNativeExpressFullscreenVideoAdDelegate>
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *csj_ad;
@property (nonatomic, weak) EasyAdFullScreenVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation CsjFullScreenVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        
        _csj_ad = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:_supplier.adspotId];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载穿山甲 supplier: %@", _supplier);
    _csj_ad.delegate = self;
    [self.csj_ad loadAdData];
}

- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    [_csj_ad showAdFromRootViewController:_adspot.viewController];
}

- (void)dealloc {
    EAD_LEVEL_INFO_LOG(@"%s", __func__);
}


// MARK: ======================= BUNativeExpressFullscreenVideoAdDelegate =======================
/// 广告预加载成功回调
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded  supplier:_supplier error:nil];
}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

/// 广告预加载失败回调
- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _csj_ad = nil;
}

/// 渲染失败
- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _csj_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdFullScreenVideoOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdFullScreenVideoOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
}

/// 广告曝光回调
- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

/// 广告点击回调
- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

/// 广告曝光结束回调
- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/// 广告播放结束
- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    if (!error) {
        if ([self.delegate respondsToSelector:@selector(easyAdFullScreenVideoOnAdPlayFinish)]) {
            [self.delegate easyAdFullScreenVideoOnAdPlayFinish];
        }
    }
}


- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {
    
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

@end
