//
//  CsjSplashAdapter.m
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/8.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "CsjSplashAdapter.h"

#if __has_include(<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#else
#import "BUAdSDK.h"
#endif

#import "EasyAdSplash.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"
@interface CsjSplashAdapter ()  <BUSplashAdDelegate>

@property (nonatomic, strong) BUSplashAdView *csj_ad;
@property (nonatomic, weak) EasyAdSplash *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation CsjSplashAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        CGRect adFrame = [UIApplication sharedApplication].keyWindow.bounds;
        // 设置logo
        if (_adspot.logoImage && _adspot.showLogoRequire) {
            CGFloat real_w = [UIScreen mainScreen].bounds.size.width;
            CGFloat real_h = _adspot.logoImage.size.height*(real_w/_adspot.logoImage.size.width);
            adFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-real_h);
        }
        _csj_ad = [[BUSplashAdView alloc] initWithSlotID:_supplier.adspotid frame:adFrame];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载穿山甲 supplier: %@", _supplier);
    if (self.adspot.timeout) {
        if (self.adspot.timeout > 500) {
            _csj_ad.tolerateTimeout = _adspot.timeout / 1000.0;
        }
    }

    _csj_ad.delegate = self;
    [self.csj_ad loadAdData];

}

- (void)loadAd {
    [super loadAd];
}

- (void)deallocAdapter {
    if (self.csj_ad) {
//        NSLog(@"穿山甲 释放了");
        [self.csj_ad removeFromSuperview];
        self.csj_ad = nil;
    }
}

- (void)showAd {
    [[UIApplication sharedApplication].keyWindow addSubview:_csj_ad];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[_adspot performSelector:@selector(bgImgV)]];
    
    _csj_ad.backgroundColor = [UIColor clearColor];
    _csj_ad.rootViewController = _adspot.viewController;
    
    if (_adspot.showLogoRequire) {
        // 添加Logo
        CGFloat real_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat real_h = _adspot.logoImage.size.height*(real_w/_adspot.logoImage.size.width);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-real_h, real_w, real_h)];
        imgV.userInteractionEnabled = YES;
        imgV.image = _adspot.logoImage;
        if (imgV) {
            [_csj_ad addSubview:imgV];
        }
    }

}
// MARK: ======================= BUSplashAdDelegate =======================
/**
 This method is called when splash ad material loaded successfully.
 */
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
    
//    [self showAd];
}

/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 */
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError * _Nullable)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    [self deallocAdapter];
}

/**
 This method is called when splash ad slot will be showing.
 */
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)] && self.csj_ad) {
        [self.delegate easyAdExposured];
    }
}

/**
 This method is called when splash ad is clicked.
 */
- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    [self deallocAdapter];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [_csj_ad removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
//    _csj_ad = nil;
}

/**
 This method is called when spalashAd skip button  is clicked.
 */
- (void)splashAdDidClickSkip:(BUSplashAdView *)splashAd {
    [self deallocAdapter];
    if ([self.delegate respondsToSelector:@selector(easyAdSplashOnAdSkipClicked)]) {
        [self.delegate easyAdSplashOnAdSkipClicked];
    }
}

/**
 This method is called when spalashAd countdown equals to zero
 */
- (void)splashAdCountdownToZero:(BUSplashAdView *)splashAd {
    [self deallocAdapter];
    if ([self.delegate respondsToSelector:@selector(easyAdSplashOnAdCountdownToZero)]) {
        [self.delegate easyAdSplashOnAdCountdownToZero];
    }
}

- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType {
    [self deallocAdapter];
}



@end
