//
//  GdtBannerAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "GdtBannerAdapter.h"

#if __has_include(<GDTUnifiedBannerView.h>)
#import <GDTUnifiedBannerView.h>
#else
#import "GDTUnifiedBannerView.h"
#endif

#import "EasyAdBanner.h"
#import "EasyAdLog.h"

@interface GdtBannerAdapter () <GDTUnifiedBannerViewDelegate>
@property (nonatomic, strong) GDTUnifiedBannerView *gdt_ad;
@property (nonatomic, weak) EasyAdBanner *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation GdtBannerAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
    }
    return self;
}

- (void)loadAd {
    
    CGRect rect = CGRectMake(0, 0, _adspot.adContainer.frame.size.width, _adspot.adContainer.frame.size.height);
    _gdt_ad = [[GDTUnifiedBannerView alloc] initWithFrame:rect placementId:_supplier.adspotId viewController:_adspot.viewController];
    _gdt_ad.animated = YES;
    _gdt_ad.autoSwitchInterval = _adspot.refreshInterval;
    _gdt_ad.delegate = self;
    [_adspot.adContainer addSubview:_gdt_ad];
    [_gdt_ad loadAdAndShow];
}

// MARK: ======================= GDTUnifiedBannerViewDelegate =======================
/**
 *  广告数据拉取成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

/**
 *  请求广告数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
//    if ([self.delegate respondsToSelector:@selector(EasyAdBannerOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdBannerOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
    [_gdt_ad removeFromSuperview];
    _gdt_ad = nil;
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView {
    [_gdt_ad removeFromSuperview];
    _gdt_ad = nil;
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

@end
