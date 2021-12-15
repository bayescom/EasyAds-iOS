//
//  CustomBannerViewController.m
//  Example
//
//  Created by CherryKing on 2019/11/8.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "CustomBannerViewController.h"
#import "ViewBuilder.h"

#import <GDTUnifiedBannerView.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MercurySDK/MercuryBannerAdView.h>

#import "AdvanceSDK.h"

@interface CustomBannerViewController () <AdvanceBaseAdspotDelegate, GDTUnifiedBannerViewDelegate, BUNativeExpressBannerViewDelegate, MercuryBannerAdViewDelegate>
@property (nonatomic, strong) AdvanceBaseAdspot *adspot;

@property (nonatomic, strong) GDTUnifiedBannerView *gdt_ad;
@property (nonatomic, strong) BUNativeExpressBannerView *csj_ad;
@property (nonatomic, strong) MercuryBannerAdView *mercury_ad;

@end

@implementation CustomBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"Banner", @"adspotId": @"100255-10000558"},
    ];
    self.btn1Title = @"加载并显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    _adspot = [[AdvanceBaseAdspot alloc] initWithAdspotId:self.adspotId];
    [_adspot setDefaultAdvSupplierWithMediaId:@"100255"
                                adspotId:@"10000558"
                                mediaKey:@"757d5119466abe3d771a211cc1278df7"
                                  sdkId:SDK_ID_MERCURY];
    _adspot.supplierDelegate = self;
    [_adspot loadAd];
}
// MARK: ======================= AdvanceBaseAdspotDelegate =======================
/// 加载渠道广告，将会返回渠道所需参数
/// @param sdkId 渠道Id
/// @param params 渠道参数
- (void)advanceBaseAdspotWithSdkId:(NSString *)sdkId params:(NSDictionary *)params {
    self.adShowView.hidden = NO;
    // 根据渠道id自定义初始化
    if ([sdkId isEqualToString:SDK_ID_GDT]) {
        _gdt_ad = [[GDTUnifiedBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/6.4)
                                                  placementId:[params objectForKey:@"adspotid"]
                                               viewController:self];
        _gdt_ad.delegate = self;
        _gdt_ad.animated = YES;
        _gdt_ad.autoSwitchInterval = 60;
        [self.adShowView addSubview:_gdt_ad];
        [_gdt_ad loadAdAndShow];
    } else if ([sdkId isEqualToString:SDK_ID_CSJ]) {
        _csj_ad = [[BUNativeExpressBannerView alloc] initWithSlotID:[params objectForKey:@"adspotid"]
                                                 rootViewController:self
                                                             adSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width/6.4) IsSupportDeepLink:YES];
        _csj_ad.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/6.4);
        _csj_ad.delegate = self;
        [self.adShowView addSubview:_csj_ad];
       [_csj_ad loadAdData];
    } else if ([sdkId isEqualToString:SDK_ID_MERCURY]) {
        _mercury_ad = [[MercuryBannerAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/6.4)
                                                        adspotId:[params objectForKey:@"adspotid"]
                                                        delegate:self];
        _mercury_ad.delegate = self;
        _mercury_ad.controller = self;
        _mercury_ad.animationOn = YES;
        _mercury_ad.showCloseBtn = YES;
        _mercury_ad.interval = 60;
        [self.adShowView addSubview:_mercury_ad];
        [_mercury_ad loadAdAndShow];
    }
}

/// 策略请求失败
/// @param error 失败原因
- (void)advanceBaseAdspotFailedWithError:(NSError *)error {
    NSLog(@"%@", error);
}

// MARK: ======================= BYBannerAdViewDelegate =======================
// 广告数据拉取成功回调
- (void)mercury_bannerViewDidReceived {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告数据拉取成功回调");
}

// 请求广告数据失败后调用
- (void)mercury_bannerViewFailToReceived:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    [_mercury_ad removeFromSuperview];
    _mercury_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"请求广告数据失败后调用 %@", error);
}

// 曝光回调
- (void)mercury_bannerViewWillExposure {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"曝光回调");
}

// 点击回调
- (void)mercury_bannerViewClicked {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"点击回调");
}

// 关闭回调
- (void)mercury_bannerViewWillClose {
    [_mercury_ad removeFromSuperview];
    _mercury_ad = nil;
    NSLog(@"关闭回调");
}

// MARK: ======================= BUNativeExpressBannerViewDelegate =======================
/**
 *  广告数据拉取成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告数据拉取成功回调");
}

/**
 *  请求广告数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    [self.adspot selectAdvSupplierWithError:error];
    [_csj_ad removeFromSuperview];
    _csj_ad = nil;
    NSLog(@"请求广告数据失败后调用");
}

/**
 *  banner2.0曝光回调
 */
- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"曝光回调");
}

/**
 *  banner2.0点击回调
 */
- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"点击回调");
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords {
    [_csj_ad removeFromSuperview];
    _csj_ad = nil;
}

// MARK: ======================= GDTUnifiedBannerViewDelegate =======================
/**
 *  广告数据拉取成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告数据拉取成功回调");
}

/**
 *  请求广告数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    [self.adspot selectAdvSupplierWithError:error];
    [_gdt_ad removeFromSuperview];
    _gdt_ad = nil;
    NSLog(@"请求广告数据失败后调用");
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"曝光回调");
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"点击回调");
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView {
    [_gdt_ad removeFromSuperview];
    _gdt_ad = nil;
}


@end
