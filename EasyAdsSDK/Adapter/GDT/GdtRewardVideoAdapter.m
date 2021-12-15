//
//  GdtRewardVideoAdapter.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "GdtRewardVideoAdapter.h"
#if __has_include(<GDTRewardVideoAd.h>)
#import <GDTRewardVideoAd.h>
#else
#import "GDTRewardVideoAd.h"
#endif
#import "EasyAdRewardVideo.h"
#import "EasyAdLog.h"

@interface GdtRewardVideoAdapter () <GDTRewardedVideoAdDelegate>
@property (nonatomic, strong) GDTRewardVideoAd *gdt_ad;
@property (nonatomic, weak) EasyAdRewardVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation GdtRewardVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _gdt_ad = [[GDTRewardVideoAd alloc] initWithPlacementId:_supplier.adspotId];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载广点通 supplier: %@", _supplier);
    _gdt_ad.delegate = self;
    [_gdt_ad loadAd];
}

- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    [_gdt_ad showAdFromRootViewController:_adspot.viewController];
}

- (void)deallocAdapter {
    _gdt_ad = nil;
}


- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

// MARK: ======================= GdtRewardVideoAdDelegate =======================
/// 广告数据加载成功回调
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    
//    NSLog(@"广点通激励视频拉取成功 %@",self.gdt_ad);

    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

/// 广告加载失败回调
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];

//    if ([self.delegate respondsToSelector:@selector(EasyAdRewardVideoOnAdFailedWithSdkId:error:)]) {
//        [self.delegate EasyAdRewardVideoOnAdFailedWithSdkId:_supplier.identifier error:error];
//    }
}

//视频缓存成功回调
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoOnAdVideoCached)]) {
        [self.delegate easyAdRewardVideoOnAdVideoCached];
    }
}

/// 视频广告曝光回调
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

/// 视频播放页关闭回调
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/// 视频广告信息点击回调
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

/// 视频广告播放达到激励条件回调
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidRewardEffective)]) {
        [self.delegate easyAdRewardVideoAdDidRewardEffective];
    }
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info {
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidRewardEffective)]) {
        [self.delegate easyAdRewardVideoAdDidRewardEffective];
    }

}

/// 视频广告视频播放完成
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidPlayFinish)]) {
        [self.delegate easyAdRewardVideoAdDidPlayFinish];
    }
}

@end
