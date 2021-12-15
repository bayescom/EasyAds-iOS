//
//  KsInterstitialAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/4/25.
//

#import "KsInterstitialAdapter.h"
#if __has_include(<KSAdSDK/KSAdSDK.h>)
#import <KSAdSDK/KSAdSDK.h>
#else
//#import "KSAdSDK.h"
#endif

#import "EasyAdInterstitial.h"
#import "EasyAdLog.h"

@interface KsInterstitialAdapter ()<KSInterstitialAdDelegate>
@property (nonatomic, strong) KSInterstitialAd *ks_ad;
@property (nonatomic, weak) EasyAdInterstitial *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;
@property (nonatomic, assign) BOOL isDidLoad;

@end

@implementation KsInterstitialAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _isDidLoad = NO;
        _ks_ad = [[KSInterstitialAd alloc] initWithPosId:_supplier.adspotId containerSize:_adspot.viewController.navigationController.view.bounds.size];
    }
    return self;
}


- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载快手 supplier: %@", _supplier);
    _ks_ad.delegate = self;
    [_ks_ad loadAdData];
}


- (void)deallocAdapter {
    _ks_ad = nil;
}

- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    if (!_ks_ad) {
        return;
    }
    [_ks_ad showFromViewController:_adspot.viewController];
}

- (void)dealloc {

}

/**
 * interstitial ad data loaded
 */
- (void)ksad_interstitialAdDidLoad:(KSInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
}
/**
 * interstitial ad render success
 */
- (void)ksad_interstitialAdRenderSuccess:(KSInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    _isDidLoad = YES;

    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}
/**
 * interstitial ad load or render failed
 */
- (void)ksad_interstitialAdRenderFail:(KSInterstitialAd *)interstitialAd error:(NSError * _Nullable)error {
    if (_isDidLoad) {// 如果已经load 报错 为renderFail
        [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];

    } else {// 如果没有load 报错 则为 loadfail
        [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    }
}
/**
 * interstitial ad will visible
 */
- (void)ksad_interstitialAdWillVisible:(KSInterstitialAd *)interstitialAd {
    
}
/**
 * interstitial ad did visible
 */
- (void)ksad_interstitialAdDidVisible:(KSInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}
/**
 * interstitial ad did skip (for video only)
 * @param playDuration played duration
 */
- (void)ksad_interstitialAd:(KSInterstitialAd *)interstitialAd didSkip:(NSTimeInterval)playDuration {
    
}
/**
 * interstitial ad did click
 */
- (void)ksad_interstitialAdDidClick:(KSInterstitialAd *)interstitialAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}
/**
 * interstitial ad will close
 */
- (void)ksad_interstitialAdWillClose:(KSInterstitialAd *)interstitialAd {
    
}
/**
 * interstitial ad did close
 */
- (void)ksad_interstitialAdDidClose:(KSInterstitialAd *)interstitialAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}
/**
 * interstitial ad did close other controller
 */
- (void)ksad_interstitialAdDidCloseOtherController:(KSInterstitialAd *)interstitialAd interactionType:(KSAdInteractionType)interactionType {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

@end
