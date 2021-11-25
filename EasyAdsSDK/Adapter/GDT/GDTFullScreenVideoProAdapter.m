//
//  GDTFullScreenVideoProAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/4/29.
//

#import "GDTFullScreenVideoProAdapter.h"

#if __has_include(<GDTExpressInterstitialAd.h>)
#import <GDTExpressInterstitialAd.h>
#else
#import "GDTExpressInterstitialAd.h"
#endif

#import "EasyAdFullScreenVideo.h"
#import "EasyAdLog.h"

@interface GDTFullScreenVideoProAdapter ()<GDTExpressInterstitialAdDelegate>
@property (nonatomic, strong) GDTExpressInterstitialAd *gdt_ad;
@property (nonatomic, weak) EasyAdFullScreenVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation GDTFullScreenVideoProAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _gdt_ad = [[GDTExpressInterstitialAd alloc] initWithPlacementId:_supplier.adspotId];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载广点通 supplier: %@", _supplier);
    _gdt_ad.delegate = self;
    [_gdt_ad loadFullScreenAd];
}

- (void)deallocAdapter {
    
}


- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    [_gdt_ad presentFullScreenAdFromRootViewController:_adspot.viewController];
}

- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}


/**
 *  模板插屏广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)expressInterstitialSuccessToLoadAd:(GDTExpressInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];

    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
    
}

/**
 *  模板插屏广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)expressInterstitialFailToLoadAd:(GDTExpressInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
    _gdt_ad = nil;
}

/**
 *  模板插屏广告将要展示回调
 *  模板插屏广告即将展示回调该函数
 */
- (void)expressInterstitialWillPresentScreen:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 *  模板插屏广告视图展示成功回调
 *  模板插屏广告展示成功回调该函数
 */
- (void)expressInterstitialDidPresentScreen:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 *  模板插屏广告视图展示失败回调
 *  模板插屏广告展示失败回调该函数
 */
- (void)expressInterstitialFailToPresent:(GDTExpressInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    
}

/**
 *  模板插屏广告展示结束回调
 *  模板插屏广告展示结束回调该函数
 */
- (void)expressInterstitialDidDismissScreen:(GDTExpressInterstitialAd *)unifiedInterstitial {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)expressInterstitialWillLeaveApplication:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 *  模板插屏广告曝光回调
 */
- (void)expressInterstitialWillExposure:(GDTExpressInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

/**
 *  模板插屏广告点击回调
 */
- (void)expressInterstitialClicked:(GDTExpressInterstitialAd *)unifiedInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

- (void)expressInterstitialDidDownloadVideo:(GDTExpressInterstitialAd *)expressInterstitial {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
}

/**
 *  点击模板插屏广告以后即将弹出全屏广告页
 */
- (void)expressInterstitialAdWillPresentFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial {
}

/**
 *  点击模板插屏广告以后弹出全屏广告页
 */
- (void)expressInterstitialAdDidPresentFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 *  模板全屏广告页将要关闭
 */
- (void)expressInterstitialAdWillDismissFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 *  模板全屏广告页被关闭
 */
- (void)expressInterstitialAdDidDismissFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial {

}

/**
 * 模板插屏视频广告 player 播放状态更新回调
 */
- (void)expressInterstitialAd:(GDTExpressInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status {
    if (status == GDTMediaPlayerStatusStoped) {
        if ([self.delegate respondsToSelector:@selector(easyAdFullScreenVideoOnAdPlayFinish)]) {
            [self.delegate easyAdFullScreenVideoOnAdPlayFinish];
        }
    }
}

/**
 * 模板插屏视频广告详情页 WillPresent 回调
 */
- (void)expressInterstitialAdViewWillPresentVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 * 模板插屏视频广告详情页 DidPresent 回调
 */
- (void)expressInterstitialAdViewDidPresentVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 * 模板插屏视频广告详情页 WillDismiss 回调
 */
- (void)expressInterstitialAdViewWillDismissVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}

/**
 * 模板插屏视频广告详情页 DidDismiss 回调
 */
- (void)expressInterstitialAdViewDidDismissVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial {
    
}



@end
