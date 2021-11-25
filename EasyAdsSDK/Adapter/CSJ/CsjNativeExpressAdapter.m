//
//  CsjNativeExpressAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "CsjNativeExpressAdapter.h"
#if __has_include(<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#else
#import "BUAdSDK.h"
#endif
#import "EasyAdNativeExpress.h"
#import "EasyAdLog.h"
#import "EasyAdNativeExpressView.h"
@interface CsjNativeExpressAdapter () <BUNativeExpressAdViewDelegate>
@property (nonatomic, strong) BUNativeExpressAdManager *csj_ad;
@property (nonatomic, weak) EasyAdNativeExpress *adspot;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) EasyAdSupplier *supplier;
@property (nonatomic, strong) NSArray <__kindof EasyAdNativeExpressView *> * views;

@end

@implementation CsjNativeExpressAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        
        BUAdSlot *slot = [[BUAdSlot alloc] init];
        slot.ID = _supplier.adspotId;
        slot.AdType = BUAdSlotAdTypeFeed;
        slot.position = BUAdSlotPositionFeed;
        slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
        _csj_ad = [[BUNativeExpressAdManager alloc] initWithSlot:slot adSize:_adspot.adSize];

    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载穿山甲 supplier: %@", _supplier);
    _csj_ad.delegate = self;
    [_csj_ad loadAdDataWithCount:1];
}

- (void)loadAd {
    [super loadAd];
}

- (void)deallocAdapter {
    
}

- (void)dealloc {
    EAD_LEVEL_INFO_LOG(@"%s", __func__);
}

// MARK: ======================= BUNativeExpressAdViewDelegate =======================
- (void)nativeExpressAdSuccessToLoad:(id)nativeExpressAd views:(nonnull NSArray<__kindof BUNativeExpressAdView *> *)views {
    if (views == nil || views.count == 0) {
        [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:[NSError errorWithDomain:@"" code:100000 userInfo:@{@"msg":@"无广告返回"}]];
    } else {
        [_adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
        
        NSMutableArray *temp = [NSMutableArray array];

        for (BUNativeExpressAdView *view in views) {
//            view.rootViewController = _adspot.viewController;
            
            EasyAdNativeExpressView *TT = [[EasyAdNativeExpressView alloc] initWithViewController:_adspot.viewController];
            TT.expressView = view;
//            TT.identifier = _supplier.identifier;
            [temp addObject:TT];

        }
        
        self.views = temp;
        
        [_adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];

        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdLoadSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdLoadSuccess:self.views];
        }
    }
}

- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _csj_ad = nil;
}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdRenderSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdRenderSuccess:expressView];
        }
    }
}

- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
//    [_adspot reportWithType:EasyAdSdkSupplierRepoFaileded error:error];
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdRenderFail:)]) {
            [_delegate easyAdNativeExpressOnAdRenderFail:expressView];
        }
    }
//    _csj_ad = nil;
}

- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView {
    [_adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdShow:)]) {
            [_delegate easyAdNativeExpressOnAdShow:expressView];
        }
    }
}

- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    [_adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClicked:)]) {
            [_delegate easyAdNativeExpressOnAdClicked:expressView];
        }
    }
}

- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
//    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
//    if ([_delegate respondsToSelector:@selector(EasyAdNativeExpressOnAdFailedWithSdkId:error:)]) {
//        [_delegate EasyAdNativeExpressOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
//    _csj_ad = nil;
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)nativeExpressAdView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClosed:)]) {
            [_delegate easyAdNativeExpressOnAdClosed:expressView];
        }
    }
}
- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView {
    
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
