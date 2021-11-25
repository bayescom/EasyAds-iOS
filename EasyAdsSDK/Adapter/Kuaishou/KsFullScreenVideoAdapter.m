//
//  KsFullScreenVideoAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/4/23.
//

#import "KsFullScreenVideoAdapter.h"
#if __has_include(<KSAdSDK/KSAdSDK.h>)
#import <KSAdSDK/KSAdSDK.h>
#else
//#import "KSAdSDK.h"
#endif

#import "EasyAdFullScreenVideo.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"
@interface KsFullScreenVideoAdapter ()<KSFullscreenVideoAdDelegate>
@property (nonatomic, strong) KSFullscreenVideoAd *ks_ad;
@property (nonatomic, weak) EasyAdFullScreenVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation KsFullScreenVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _ks_ad = [[KSFullscreenVideoAd alloc] initWithPosId:_supplier.adspotId];
        _ks_ad.showDirection = KSAdShowDirection_Vertical;
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载快手 supplier: %@", _supplier);
    _ks_ad.delegate = self;
    [_ks_ad loadAdData];
}


- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.ks_ad.isValid) {
            [self.ks_ad showAdFromRootViewController:self.adspot.viewController.navigationController];
        }
    });

//    [_gdt_ad presentFullScreenAdFromRootViewController:_adspot.viewController];
}

- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

/**
 This method is called when video ad material loaded successfully.
 */
- (void)fullscreenVideoAdDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
}
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)fullscreenVideoAd:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
}
/**
 This method is called when cached successfully.
 */
- (void)fullscreenVideoAdVideoDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}
/**
 This method is called when video ad slot will be showing.
 */
- (void)fullscreenVideoAdWillVisible:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}
/**
 This method is called when video ad slot has been shown.
 */
- (void)fullscreenVideoAdDidVisible:(KSFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}
/**
 This method is called when video ad is about to close.
 */
- (void)fullscreenVideoAdWillClose:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}
/**
 This method is called when video ad is closed.
 */
- (void)fullscreenVideoAdDidClose:(KSFullscreenVideoAd *)fullscreenVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/**
 This method is called when video ad is clicked.
 */
- (void)fullscreenVideoAdDidClick:(KSFullscreenVideoAd *)fullscreenVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)fullscreenVideoAdDidPlayFinish:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    if (!error) {
        if ([self.delegate respondsToSelector:@selector(easyAdFullScreenVideoOnAdPlayFinish)]) {
            [self.delegate easyAdFullScreenVideoOnAdPlayFinish];
        }
    }
}
/**
 This method is called when the video begin to play.
 */
- (void)fullscreenVideoAdStartPlay:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}
/**
 This method is called when the user clicked skip button.
 */
- (void)fullscreenVideoAdDidClickSkip:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}



@end
