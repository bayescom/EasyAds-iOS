//
//  KsNativeExpressAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/4/23.
//

#import "KsNativeExpressAdapter.h"
#if __has_include(<KSAdSDK/KSAdSDK.h>)
#import <KSAdSDK/KSAdSDK.h>
#else
//#import "KSAdSDK.h"
#endif


#import "EasyAdNativeExpress.h"
#import "EasyAdLog.h"
#import "EasyAdNativeExpressView.h"
@interface KsNativeExpressAdapter ()<KSFeedAdsManagerDelegate, KSFeedAdDelegate>
@property (nonatomic, strong) KSFeedAdsManager *ks_ad;
@property (nonatomic, weak) EasyAdNativeExpress *adspot;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) EasyAdSupplier *supplier;
@property (nonatomic, strong) NSArray<EasyAdNativeExpressView *> * views;

@end

@implementation KsNativeExpressAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        
        _ks_ad = [[KSFeedAdsManager alloc] initWithPosId:_supplier.adspotId size:_adspot.adSize];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载快手 supplier: %@", _supplier);
    _ks_ad.delegate = self;
    [_ks_ad loadAdDataWithCount:1];
}

- (void)loadAd {
    [super loadAd];
    
}

- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

- (void)feedAdsManagerSuccessToLoad:(KSFeedAdsManager *)adsManager nativeAds:(NSArray<KSFeedAd *> *_Nullable)feedAdDataArray {
//    self.title = @"数据加载成功";
    if (feedAdDataArray == nil || feedAdDataArray.count == 0) {
        [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:[NSError errorWithDomain:@"" code:100000 userInfo:@{@"msg":@"无广告返回"}]];
    } else {
        [_adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
        NSMutableArray *temp = [NSMutableArray array];
        for (KSFeedAd *ad in feedAdDataArray) {
            ad.delegate = self;
            [ad setVideoSoundEnable:NO];
            
            EasyAdNativeExpressView *TT = [[EasyAdNativeExpressView alloc] initWithViewController:_adspot.viewController];
            TT.expressView = ad.feedView;
            [temp addObject:TT];

        }
        self.views = temp;

        [_adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];

        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdLoadSuccess:)]) {
            [_delegate easyAdNativeExpressOnAdLoadSuccess:self.views];
        }
    }

//    [self refreshWithData:adsManager];
}

- (void)feedAdsManager:(KSFeedAdsManager *)adsManager didFailWithError:(NSError *)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
}

- (void)feedAdViewWillShow:(KSFeedAd *)feedAd {
    [_adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)feedAd.feedView];
    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdShow:)]) {
            [_delegate easyAdNativeExpressOnAdShow:expressView];
        }
    }


}

- (void)feedAdDidClick:(KSFeedAd *)feedAd {
    [_adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)feedAd.feedView];

    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClicked:)]) {
            [_delegate easyAdNativeExpressOnAdClicked:expressView];
        }
    }
}

- (void)feedAdDislike:(KSFeedAd *)feedAd {
    EasyAdNativeExpressView *expressView = [self returnExpressViewWithAdView:(UIView *)feedAd.feedView];
    if (expressView) {
        if ([_delegate respondsToSelector:@selector(easyAdNativeExpressOnAdClosed:)]) {
            [_delegate easyAdNativeExpressOnAdClosed:expressView];
        }
    }
}

- (void)feedAdDidShowOtherController:(KSFeedAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    
}

- (void)feedAdDidCloseOtherController:(KSFeedAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    
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
