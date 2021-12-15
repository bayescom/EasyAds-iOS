//
//  GdtSplashAdapter.m
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/8.
//  Copyright © 2020 Gdt. All rights reserved.
//

#import "GdtSplashAdapter.h"

#if __has_include(<GDTSplashAd.h>)
#import <GDTSplashAd.h>
#else
#import "GDTSplashAd.h"
#endif

#import "EasyAdSplash.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"
@interface GdtSplashAdapter () <GDTSplashAdDelegate>
@property (nonatomic, strong) GDTSplashAd *gdt_ad;
@property (nonatomic, weak) EasyAdSplash *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

// 剩余时间，用来判断用户是点击跳过，还是正常倒计时结束
@property (nonatomic, assign) NSUInteger leftTime;
// 是否点击了
@property (nonatomic, assign) BOOL isClick;

@end

@implementation GdtSplashAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _leftTime = 5;  // 默认5s
        _gdt_ad = [[GDTSplashAd alloc] initWithPlacementId:_supplier.adspotId];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载广点通 supplier: %@", _supplier);
    if (!_gdt_ad) {
        return;
    }
    _adspot.viewController.modalPresentationStyle = 0;
    // 设置 backgroundImage
    _gdt_ad.backgroundImage = _adspot.backgroundImage;
    _gdt_ad.delegate = self;
    if (self.adspot.timeout) {
        if (self.adspot.timeout > 500) {
            _gdt_ad.fetchDelay = _adspot.timeout / 1000.0;
        }
    }
    [_gdt_ad loadAd];

}

- (void)loadAd {
    [super loadAd];
}

// MARK: ======================= GDTSplashAdDelegate =======================
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
}

- (void)deallocAdapter {
    _gdt_ad = nil;
}

- (void)showAd {
    // 设置logo
    UIImageView *imgV;
    if (_adspot.logoImage) {
        CGFloat real_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat real_h = _adspot.logoImage.size.height*(real_w/_adspot.logoImage.size.width);
        imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, real_w, real_h)];
        imgV.userInteractionEnabled = YES;
        imgV.image = _adspot.logoImage;
    }
    if (self.gdt_ad) {

        if ([self.gdt_ad isAdValid]) {
            [_gdt_ad showAdInWindow:[UIApplication sharedApplication].easyAd_getCurrentWindow withBottomView:_adspot.showLogoRequire?imgV:nil skipView:nil];
        } else {

        }
    }
}

- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
//    NSLog(@"广点通开屏拉取成功 %@ %d",self.gdt_ad ,[self.gdt_ad isAdValid]);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];

    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }

//    [self showAd];
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)] && self.gdt_ad) {
        [self.delegate easyAdExposured];
    }
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];

//    if ([self.delegate respondsToSelector:@selector(EasyAdSplashOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdSplashOnAdFailedWithSdkId:_adspot.adspotId error:error];
//    }
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
    _isClick = YES;
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    // 如果时间大于0 且不是因为点击触发的，则认为是点击了跳过
    if (_leftTime > 0 && !_isClick) {
        if ([self.delegate respondsToSelector:@selector(easyAdSplashOnAdSkipClicked)]) {
            [self.delegate easyAdSplashOnAdSkipClicked];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
            [self.delegate easyAdDidClose];
        }
    }
}

- (void)splashAdLifeTime:(NSUInteger)time {
    _leftTime = time;
    if (time <= 0 && [self.delegate respondsToSelector:@selector(easyAdSplashOnAdCountdownToZero)]) {
        [self.delegate easyAdSplashOnAdCountdownToZero];
    }
}

@end
