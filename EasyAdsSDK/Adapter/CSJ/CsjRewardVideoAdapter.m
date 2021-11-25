//
//  CsjRewardVideoAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "CsjRewardVideoAdapter.h"

#if __has_include(<BUAdSDK/BUNativeExpressRewardedVideoAd.h>)
#import <BUAdSDK/BUNativeExpressRewardedVideoAd.h>
#else
#import "BUNativeExpressRewardedVideoAd.h"
#endif
#if __has_include(<BUAdSDK/BURewardedVideoModel.h>)
#import <BUAdSDK/BURewardedVideoModel.h>
#else
#import "BURewardedVideoModel.h"
#endif

#import "EasyAdRewardVideo.h"
#import "EasyAdLog.h"

@interface CsjRewardVideoAdapter () <BUNativeExpressRewardedVideoAdDelegate>
@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *csj_ad;
@property (nonatomic, weak) EasyAdRewardVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation CsjRewardVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        [model setUserId:@"playable"];
        _csj_ad = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:_supplier.adspotId rewardedVideoModel:model];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载穿山甲 supplier: %@", _supplier);
    _csj_ad.delegate = self;
    [self.csj_ad loadAdData];
}


- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    if (_csj_ad.isAdValid) {
        [_csj_ad showAdFromRootViewController:_adspot.viewController];
    }
}

- (void)deallocAdapter {
    _csj_ad = nil;
}


- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

// MARK: ======================= BUNativeExpressRewardedVideoAdDelegate =======================
/// 广告数据加载成功回调
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];

    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

/// 广告加载失败回调
- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    EAD_LEVEL_INFO_LOG(@"%@", error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _csj_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdRewardVideoOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdRewardVideoOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
}

//视频缓存成功回调
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoOnAdVideoCached)]) {
        [self.delegate easyAdRewardVideoOnAdVideoCached];
    }
}

/// 视频广告曝光回调
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

/// 视频播放页关闭回调
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/// 视频广告信息点击回调
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    /// 视频广告播放达到激励条件回调
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidRewardEffective)]) {
        [self.delegate easyAdRewardVideoAdDidRewardEffective];
    }
    /// 视频广告视频播放完成
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidPlayFinish)]) {
        [self.delegate easyAdRewardVideoAdDidPlayFinish];
    }
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *)error
{
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    _csj_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdRewardVideoOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdRewardVideoOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }

}

// 加载错误
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];

    _csj_ad = nil;
//    if ([self.delegate respondsToSelector:@selector(EasyAdRewardVideoOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdRewardVideoOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }

}

- (void)nativeExpressRewardedVideoAdCallback:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd withType:(BUNativeExpressRewardedVideoAdType)nativeExpressVideoType {
    // 据说能解决神奇的bug
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    // 跳过回调 穿山甲有 广点通没有
}
@end
