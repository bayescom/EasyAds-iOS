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

@property (nonatomic, strong) BUSplashAd *csj_ad;
@property (nonatomic, weak) EasyAdSplash *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, assign) BOOL isClose;

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
        _csj_ad = [[BUSplashAd alloc] initWithSlotID:_supplier.adspotId adSize:adFrame.size];

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
        [self.csj_ad removeSplashView];
        self.csj_ad = nil;
        [self.imgV removeFromSuperview];
        self.imgV = nil;
    }
}

- (void)showAd {
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[_adspot performSelector:@selector(bgImgV)]];
        
    [_csj_ad showSplashViewInRootViewController:[UIApplication sharedApplication].easyAd_getCurrentWindow.rootViewController];


}



- (void)splashAdLoadSuccess:(nonnull BUSplashAd *)splashAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

- (void)splashAdRenderSuccess:(nonnull BUSplashAd *)splashAd {
//    NSLog(@"2222222222");
    if (_adspot.showLogoRequire) {
        // 添加Logo
        NSAssert(_adspot.logoImage != nil, @"showLogoRequire = YES时, 必须设置logoImage");
        CGFloat real_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat real_h = _adspot.logoImage.size.height*(real_w/_adspot.logoImage.size.width);
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-real_h, real_w, real_h)];
        _imgV.userInteractionEnabled = YES;
        _imgV.image = _adspot.logoImage;
        if (_imgV) {
            [_csj_ad.splashRootViewController.view addSubview:_imgV];
        }
    }
    
}


- (void)splashAdLoadFail:(nonnull BUSplashAd *)splashAd error:(BUAdError * _Nullable)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    [self deallocAdapter];
}


- (void)splashAdRenderFail:(nonnull BUSplashAd *)splashAd error:(BUAdError * _Nullable)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    [self deallocAdapter];
}

- (void)splashAdWillShow:(nonnull BUSplashAd *)splashAd {

}

- (void)splashAdDidShow:(nonnull BUSplashAd *)splashAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)] && self.csj_ad) {
        [self.delegate easyAdExposured];
    }
}

- (void)splashAdDidClick:(nonnull BUSplashAd *)splashAd {
    [self deallocAdapter];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

- (void)splashAdDidClose:(nonnull BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType {
        
    [self closeDelegate];
}

- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd {
    [self closeDelegate];
}

- (void)splashDidCloseOtherController:(nonnull BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType {
    [self closeDelegate];
}

- (void)splashVideoAdDidPlayFinish:(nonnull BUSplashAd *)splashAd didFailWithError:(nonnull NSError *)error {
    
}

- (void)closeDelegate {
    if (_isClose) {
        return;
    }
    _isClose = YES;
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
    [self deallocAdapter];

}





@end
