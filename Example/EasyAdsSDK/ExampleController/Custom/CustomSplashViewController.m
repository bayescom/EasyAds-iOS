//
//  CustomSplashViewController.m
//  AAA
//
//  Created by CherryKing on 2019/11/1.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "CustomSplashViewController.h"
#import "DemoUtils.h"

#import "AdvanceSDK.h"

#import <GDTSplashAd.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MercurySDK/MercurySDK.h>


@interface CustomSplashViewController () <AdvanceBaseAdspotDelegate, GDTSplashAdDelegate, BUNativeExpressSplashViewDelegate, MercurySplashAdDelegate>
@property (nonatomic, strong) AdvanceBaseAdspot *adspot;

@property (nonatomic, strong) GDTSplashAd *gdt_ad;
@property (nonatomic, strong) BUNativeExpressSplashView *csj_ad;
@property (nonatomic, strong) MercurySplashAd *mercury_ad;

@end

@implementation CustomSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"mediaId-adspotId", @"adspotId": @"100255-10002619"},
    ];
    self.btn1Title = @"加载并显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    _adspot = [[AdvanceBaseAdspot alloc] initWithAdspotId:self.adspotId];
    [_adspot setDefaultAdvSupplierWithMediaId:@"100255"
                                adspotId:@"10002619"
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
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 根据渠道id自定义初始化
    if ([sdkId isEqualToString:SDK_ID_GDT]) {
        _gdt_ad = [[GDTSplashAd alloc] initWithPlacementId:[params objectForKey:@"adspotid"]];
        _gdt_ad.delegate = self;
        _gdt_ad.fetchDelay = 5;
        [_gdt_ad loadAdAndShowInWindow:window];
    } else if ([sdkId isEqualToString:SDK_ID_CSJ]) {
        _csj_ad = [[BUNativeExpressSplashView alloc] initWithSlotID:[params objectForKey:@"adspotid"]
                                                             adSize:[UIScreen mainScreen].bounds.size
                                                 rootViewController:self];
        _csj_ad.delegate = self;
        _csj_ad.tolerateTimeout = 3;
        [_csj_ad loadAdData];
        [window addSubview:_csj_ad];
    } else if ([sdkId isEqualToString:SDK_ID_MERCURY]) {
        _mercury_ad = [[MercurySplashAd alloc] initAdWithAdspotId:[params objectForKey:@"adspotid"]
                                                         delegate:self];
        _mercury_ad.controller = self;
        [_mercury_ad loadAdAndShow];
    }
}
/// @param error 失败原因
- (void)advanceBaseAdspotFailedWithError:(NSError *)error {
    NSLog(@"%@", error);
}

// MARK: ======================= MercurySplashAdDelegate =======================
- (void)mercury_splashAdDidLoad:(MercurySplashAd *)splashAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告加载成功");
}

- (void)mercury_splashAdSuccessPresentScreen:(MercurySplashAd *)splashAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"广告曝光");
}

- (void)mercury_splashAdFailError:(nullable NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"广告加载失败");
}

- (void)mercury_splashAdClicked:(MercurySplashAd *)splashAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"广告点击");
}

// MARK: ======================= GDTSplashAdDelegate =======================
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告加载成功");
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"广告曝光");
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"广告加载失败");
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"广告点击");
}

// MARK: ======================= BUNativeExpressSplashViewDelegate =======================
- (void)nativeExpressSplashViewDidLoad:(BUNativeExpressSplashView *)splashAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
    NSLog(@"广告加载成功");
}

- (void)nativeExpressSplashView:(BUNativeExpressSplashView *)splashAdView didFailWithError:(NSError * _Nullable)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    NSLog(@"广告加载失败");
    [_csj_ad removeFromSuperview];
    _csj_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
}

- (void)nativeExpressSplashViewWillVisible:(BUNativeExpressSplashView *)splashAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"广告曝光");
}

- (void)nativeExpressSplashViewDidClick:(BUNativeExpressSplashView *)splashAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"广告点击");
}

- (void)nativeExpressSplashViewDidClose:(nonnull UIView *)splashAdView {
    [_csj_ad removeFromSuperview];
    _csj_ad = nil;
}

- (void)nativeExpressSplashViewRenderFail:(nonnull BUNativeExpressSplashView *)splashAdView error:(NSError * _Nullable)error {
    NSLog(@"广告渲染失败");
    [_csj_ad removeFromSuperview];
    _csj_ad = nil;
    [self.adspot selectAdvSupplierWithError:error];
}

@end
