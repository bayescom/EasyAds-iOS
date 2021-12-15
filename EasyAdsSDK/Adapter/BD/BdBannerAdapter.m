//
//  BdBannerAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/5/28.
//

#import "BdBannerAdapter.h"
#if __has_include(<BaiduMobAdSDK/BaiduMobAdView.h>)
#import <BaiduMobAdSDK/BaiduMobAdView.h>
#else
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#endif
#import "EasyAdBanner.h"
#import "EasyAdLog.h"
@interface BdBannerAdapter ()<BaiduMobAdViewDelegate>
@property (nonatomic, strong) BaiduMobAdView *bd_ad;
@property (nonatomic, weak) EasyAdBanner *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end
@implementation BdBannerAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
    }
    return self;
}

- (void)loadAd {
    
    CGRect rect = CGRectMake(0, 0, _adspot.adContainer.frame.size.width, _adspot.adContainer.frame.size.height);
    _bd_ad = [[BaiduMobAdView alloc] init];
    _bd_ad.AdType = BaiduMobAdViewTypeBanner;
    _bd_ad.delegate = self;
    _bd_ad.AdUnitTag = _supplier.adspotId;
    _bd_ad.frame = rect;
    [_adspot.adContainer addSubview:_bd_ad];
    [_bd_ad start];

}

- (NSString *)publisherId {
    return  _supplier.appId; //@"your_own_app_id";
}

- (void)willDisplayAd:(BaiduMobAdView *)adview {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason {
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000020 + reason userInfo:@{@"desc":@"百度广告展现错误"}];
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
//    if ([self.delegate respondsToSelector:@selector(EasyAdBannerOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdBannerOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
    [_bd_ad removeFromSuperview];
    _bd_ad = nil;
}

- (void)didAdImpressed {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

- (void)didAdClicked {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

//点击关闭的时候移除广告
- (void)didAdClose {
//    [sharedAdView removeFromSuperview];
    [_bd_ad removeFromSuperview];
    _bd_ad = nil;
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

- (void)didDismissLandingPage {
    
}
@end
