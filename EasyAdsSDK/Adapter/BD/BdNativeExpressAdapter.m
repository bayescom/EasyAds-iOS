//
//  BdNativeExpressAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/5/31.
//

#import "BdNativeExpressAdapter.h"
#if __has_include(<BaiduMobAdSDK/BaiduMobAdNative.h>)
#import <BaiduMobAdSDK/BaiduMobAdNative.h>
#import <BaiduMobAdSDK/BaiduMobAdSmartFeedView.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeAdObject.h>
#else
#import "BaiduMobAdSDK/BaiduMobAdNative.h"
#import "BaiduMobAdSDK/BaiduMobAdSmartFeedView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdObject.h"
#endif

#import "EasyAdNativeExpress.h"
#import "EasyAdLog.h"
#import "EasyAdNativeExpressView.h"
@interface BdNativeExpressAdapter ()<BaiduMobAdNativeAdDelegate, BaiduMobAdNativeInterationDelegate>
@property (nonatomic, strong) BaiduMobAdNative *bd_ad;
@property (nonatomic, weak) EasyAdNativeExpress *adspot;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) EasyAdSupplier *supplier;
@property (nonatomic, strong) NSMutableArray<__kindof EasyAdNativeExpressView *> *views;

@end

@implementation BdNativeExpressAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _bd_ad = [[BaiduMobAdNative alloc] init];
        _bd_ad.adDelegate = self;
        _bd_ad.publisherId = _supplier.appId;
        _bd_ad.adUnitTag = _supplier.adspotId;
        _bd_ad.presentAdViewController = _adspot.viewController;
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载百度 supplier: %@", _supplier);
    [_bd_ad requestNativeAds];
}


- (void)loadAd {
    [super loadAd];
}

- (void)deallocAdapter {
    
}

- (void)dealloc {
//    EasyAdLog(@"%s", __func__);
}


- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds nativeAd:(BaiduMobAdNative *)nativeAd {
    if (nativeAds == nil || nativeAds.count == 0) {
        [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:[NSError errorWithDomain:@"" code:100000 userInfo:@{@"msg":@"无广告返回"}]];
    } else {
        [_adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
        NSMutableArray *temp = [NSMutableArray array];
        
        
        BaiduMobAdNativeAdObject *object = nativeAds.firstObject;
        object.interationDelegate = self;
//        if ([object isExpired]) {
//            continue;
//        }
        // BDview
        BaiduMobAdSmartFeedView *view = [[BaiduMobAdSmartFeedView alloc]initWithObject:object frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGFLOAT_MIN)];
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
//            [view addGestureRecognizer:tapGesture];

        [view setVideoMute:YES];
        
        [view reSize];
        NSLog(@"=====> %@", view);

        // advanceView
        EasyAdNativeExpressView *TT = [[EasyAdNativeExpressView alloc] initWithViewController:_adspot.viewController];
        TT.expressView = view;

        [temp addObject:TT];

        self.views = temp;
        [_adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];

        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdLoadSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdLoadSuccess:self.views];
        }
    }

}

//广告返回失败
- (void)nativeAdsFailLoad:(BaiduMobFailReason)reason {
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000030 + reason userInfo:@{@"desc":@"百度广告拉取失败"}];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _bd_ad = nil;

}

//广告被点击，打开后续详情页面，如果为视频广告，可选择暂停视频
- (void)nativeAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
//    NSLog(@"信息流被点击:%@ - %@", nativeAdView, object);
    [_adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:nativeAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClicked:)]) {
            [_delegate easyAdNativeExpressOnAdClicked:expressView];
        }
    }
}

// 负反馈点击选项回调
- (void)nativeAdDislikeClick:(UIView *)adView reason:(BaiduMobAdDislikeReasonType)reason {
//    NSLog(@"native: smart feedback click 智选负反馈点击：%@ reason:%ld", adView, (long)reason);
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:adView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClosed:)]) {
            [_delegate easyAdNativeExpressOnAdClosed:expressView];
        }
        [self.views removeObject:expressView];
    }
}


//广告曝光成功
- (void)nativeAdExposure:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
//    NSLog(@"信息流广告曝光成功:%@ - %@", nativeAdView, object);
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:nativeAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdRenderSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdRenderSuccess:expressView];
        }
        
        [_adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdShow:)]) {
            [_delegate easyAdNativeExpressOnAdShow:expressView];
        }

    }
    
}

//广告曝光失败
- (void)nativeAdExposureFail:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object failReason:(int)reason {
//    NSLog(@"信息流广告曝光失败:%@ - %@，reason：%d", nativeAdView, object, reason);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:nil];
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:nativeAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdRenderFail:)]) {
            [_delegate easyAdNativeExpressOnAdRenderFail:expressView];
        }
        [self.views removeObject:expressView];
    }

}

// 广告关闭
- (void)nativeAdDislikeClose:(UIView *)adView {
//    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:adView];
//
//    if (expressView) {
//        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClosed:)]) {
//            [_delegate easyAdNativeExpressOnAdClosed:expressView];
//        }
//        [self.views removeObject:expressView];
//    }

}

// 联盟官网点击跳转
- (void)unionAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object{
//    NSLog(@"信息流广告百香果点击回调");
}

- (void)tapGesture:(UIGestureRecognizer *)sender {
    UIView *view = sender.view ;

    if ([view isKindOfClass:[BaiduMobAdSmartFeedView class]]) {
        BaiduMobAdSmartFeedView *adView = (BaiduMobAdSmartFeedView *)view;
        [adView handleClick];
        return;
    }
}

- (EasyAdNativeExpressView *)returnExpressViewWithAdView:(UIView *)adView {
    for (NSInteger i = 0; i < self.views.count; i++) {
        EasyAdNativeExpressView *temp = self.views[i];
        if (temp.expressView == adView) {
            return temp;
        }
    }
    return nil;
}


@end
