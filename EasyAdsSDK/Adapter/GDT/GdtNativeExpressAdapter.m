//
//  GdtNativeExpressAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "GdtNativeExpressAdapter.h"

#if __has_include(<GDTNativeExpressAd.h>)
#import <GDTNativeExpressAd.h>
#else
#import "GDTNativeExpressAd.h"
#endif
#if __has_include(<GDTNativeExpressAdView.h>)
#import <GDTNativeExpressAdView.h>
#else
#import "GDTNativeExpressAdView.h"
#endif

#import "EasyAdNativeExpress.h"
#import "EasyAdLog.h"
#import "EasyAdNativeExpressView.h"

@interface GdtNativeExpressAdapter () <GDTNativeExpressAdDelegete>
@property (nonatomic, strong) GDTNativeExpressAd *gdt_ad;
@property (nonatomic, weak) EasyAdNativeExpress *adspot;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) EasyAdSupplier *supplier;
@property (nonatomic, strong) NSArray<__kindof EasyAdNativeExpressView *> *views;
@end

@implementation GdtNativeExpressAdapter


- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _gdt_ad = [[GDTNativeExpressAd alloc] initWithPlacementId:_supplier.adspotId
                                                           adSize:_adspot.adSize];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载广点通 supplier: %@", _supplier);
    _gdt_ad.delegate = self;
    [_gdt_ad loadAd:1];
}

- (void)loadAd {
    [super loadAd];
}

- (void)deallocAdapter {
    
}

- (void)dealloc {

}

// MARK: ======================= GDTNativeExpressAdDelegete =======================
/**
 * 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views {
    if (views == nil || views.count == 0) {
        [_adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:nil];

//        if ([_delegate respondsToSelector:@selector(EasyAdNativeExpressOnAdFailedWithSdkId:error:)]) {
//            [_delegate EasyAdNativeExpressOnAdFailedWithSdkId:_supplier.identifier error:[NSError errorWithDomain:@"" code:100000 userInfo:@{@"msg":@"无广告返回"}]];
//        }
    } else {
        [_adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (GDTNativeExpressAdView *view in views) {
//            view.controller = _adspot.viewController;
            
            EasyAdNativeExpressView *TT = [[EasyAdNativeExpressView alloc] initWithViewController:_adspot.viewController];
            TT.expressView = view;
//            TT.identifier = _supplier.identifier;
            [temp addObject:TT];

        }
        
        self.views = temp;
        [_adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdLoadSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdLoadSuccess:temp];
        }
        
    }
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error {
    EAD_LEVEL_INFO_LOG(@"%@", error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];

    _gdt_ad = nil;
}

/**
 * 渲染原生模板广告失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:nil];
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];
    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdRenderFail:)]) {
            [_delegate easyAdNativeExpressOnAdRenderFail:expressView];
        }
    }
//    if ([_delegate respondsToSelector:@selector(EasyAdNativeExpressOnAdFailedWithSdkId:error:)]) {
//        [_delegate EasyAdNativeExpressOnAdFailedWithSdkId:_supplier.identifier error:[NSError errorWithDomain:@"" code:10000 userInfo:@{@"msg": @"渲染原生模板广告失败"}]];
//    }
    _gdt_ad = nil;
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView {
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdRenderSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdRenderSuccess:expressView];
        }
    }
    
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView {
    [_adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];
    
    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClicked:)]) {
            [_delegate easyAdNativeExpressOnAdClicked:expressView];
        }
    }
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView {
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];
    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClosed:)]) {
            [_delegate easyAdNativeExpressOnAdClosed:expressView];
        }
    }
}

- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView {
    [_adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdShow:)]) {
            [_delegate easyAdNativeExpressOnAdShow:expressView];
        }
    }
}


- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView {

}

- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView {

}

- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView {
    
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
