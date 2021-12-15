//
//  BdSplashAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/5/24.
//
#if __has_include(<BaiduMobAdSDK/BaiduMobAdSplash.h>)
#import <BaiduMobAdSDK/BaiduMobAdSplash.h>
#else
#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#endif

#import "EasyAdSplash.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"


#import "BdSplashAdapter.h"
@interface BdSplashAdapter ()<BaiduMobAdSplashDelegate>
@property (nonatomic, strong) BaiduMobAdSplash *bd_ad;
@property (nonatomic, weak) EasyAdSplash *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

// 剩余时间，用来判断用户是点击跳过，还是正常倒计时结束
@property (nonatomic, assign) NSUInteger leftTime;
// 是否点击了
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) UIView *customSplashView;
@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation BdSplashAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _leftTime = 5;  // 默认5s
        _bd_ad = [[BaiduMobAdSplash alloc] init];
        _bd_ad.AdUnitTag = supplier.adspotId;
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载百度 supplier: %@", _supplier);
    if (!_bd_ad) {
        [self deallocAdapter];
        return;
    }
    _bd_ad.delegate = self;
    if (self.adspot.timeout) {
        if (self.adspot.timeout > 500) {
            _bd_ad.timeout = _adspot.timeout / 1000.0;
        }
    }
        
    UIWindow *window = [UIApplication sharedApplication].easyAd_getCurrentWindow;
    if (_adspot.logoImage) {
        CGFloat real_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat real_h = _adspot.logoImage.size.height*(real_w/_adspot.logoImage.size.width);
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, window.frame.size.height - real_h, real_w, real_h)];
        self.imgV.userInteractionEnabled = YES;
        self.imgV.image = _adspot.logoImage;
        self.imgV.hidden = YES;

        
        _bd_ad.adSize = CGSizeMake(window.frame.size.width, window.frame.size.height - self.imgV.frame.size.height);

    } else {
        _bd_ad.adSize = CGSizeMake(window.frame.size.width, window.frame.size.height);
    }
    
    [_bd_ad load];

}

- (void)loadAd {
    [super loadAd];
}

- (void)deallocAdapter {
//    _gdt_ad = nil;
    [self.customSplashView removeFromSuperview];
    [self.imgV removeFromSuperview];
}

- (void)showAd {
    // 设置logo
    UIWindow *window = [UIApplication sharedApplication].easyAd_getCurrentWindow;
    if (self.imgV) {
        [window addSubview:self.imgV];
    }
    
    if (self.bd_ad) {
        [window addSubview:self.customSplashView];
        self.customSplashView.frame = CGRectMake(window.frame.origin.x, window.frame.origin.y, window.frame.size.width, window.frame.size.height - self.imgV.frame.size.height);
        self.customSplashView.backgroundColor = [UIColor whiteColor];
        [self.bd_ad showInContainerView:self.customSplashView];
    
//        NSLog(@"百度开屏展示%@",self.bd_ad);
    }
}

- (UIView *)customSplashView {
    if (!_customSplashView) {
        _customSplashView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].easyAd_getCurrentWindow.frame];
        _customSplashView.hidden = YES;
    }
    return _customSplashView;
}


- (NSString *)publisherId {
    return _supplier.appId;
}

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
//    NSLog(@"开屏广告落地页被关闭");
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
//    NSLog(@"开屏广告被移除");
    [self deallocAdapter];
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

- (void)splashDidExposure:(BaiduMobAdSplash *)splash {
//    NSLog(@"开屏广告曝光成功");
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)] && self.bd_ad) {
        [self.delegate easyAdExposured];
    }
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
//    NSLog(@"开屏广告展示成功");
    self.customSplashView.hidden = NO;
    self.imgV.hidden = NO;
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason {
    EAD_LEVEL_INFO_LOG(@"%d",reason);
    [self deallocAdapter];
}

- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
//    NSLog(@"开屏广告被点击");
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

- (void)splashAdLoadSuccess:(BaiduMobAdSplash *)splash {
//    NSLog(@"百度开屏拉取成功 %@",self.bd_ad);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }

//    [self showAd];
}

- (void)splashAdLoadFail:(BaiduMobAdSplash *)splash {
//    NSLog(@"开屏广告请求失败");
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000000 userInfo:@{@"desc":@"百度广告请求错误"}];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    [self deallocAdapter];
}
@end
