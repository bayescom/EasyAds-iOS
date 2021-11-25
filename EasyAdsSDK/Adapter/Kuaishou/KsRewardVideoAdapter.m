//
//  KsRewardVideoAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/4/23.
//

#import "KsRewardVideoAdapter.h"
#if __has_include(<KSAdSDK/KSAdSDK.h>)
#import <KSAdSDK/KSAdSDK.h>
#else
//#import "KSAdSDK.h"
#endif

#import "EasyAdRewardVideo.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"
@interface KsRewardVideoAdapter ()<KSRewardedVideoAdDelegate>
@property (nonatomic, strong) KSRewardedVideoAd *ks_ad;
@property (nonatomic, weak) EasyAdRewardVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation KsRewardVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        KSRewardedVideoModel *model = [KSRewardedVideoModel new];
        _ks_ad = [[KSRewardedVideoAd alloc] initWithPosId:supplier.adspotId rewardedVideoModel:model];
        _ks_ad.showDirection = KSAdShowDirection_Vertical;
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载快手 supplier: %@", _supplier);
    self.ks_ad.delegate = self;
    [self.ks_ad loadAdData];
}

- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.ks_ad.isValid) {
            [self.ks_ad showAdFromRootViewController:self.adspot.viewController.navigationController];
        }
    });

}

- (void)deallocAdapter {
    self.ks_ad = nil;
}


- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(KSRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }

}
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
}
/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdVideoDidLoad:(KSRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoOnAdVideoCached)]) {
        [self.delegate easyAdRewardVideoOnAdVideoCached];
    }
}
/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardedVideoAdWillVisible:(KSRewardedVideoAd *)rewardedVideoAd {
    
}
/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(KSRewardedVideoAd *)rewardedVideoAd {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}
/**
 This method is called when video ad is about to close.
 */
- (void)rewardedVideoAdWillClose:(KSRewardedVideoAd *)rewardedVideoAd {
    
}
/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(KSRewardedVideoAd *)rewardedVideoAd {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(KSRewardedVideoAd *)rewardedVideoAd  {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    if (!error) {
        if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidPlayFinish)]) {
            [self.delegate easyAdRewardVideoAdDidPlayFinish];
        }
    }
}
/**
 This method is called when the user clicked skip button.
 */
- (void)rewardedVideoAdDidClickSkip:(KSRewardedVideoAd *)rewardedVideoAd {
    
}
/**
 This method is called when the video begin to play.
 */
- (void)rewardedVideoAdStartPlay:(KSRewardedVideoAd *)rewardedVideoAd {
    
}
/**
 This method is called when the user close video ad.
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd hasReward:(BOOL)hasReward {
    if (hasReward) {
        if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidRewardEffective)]) {
            [self.delegate easyAdRewardVideoAdDidRewardEffective];
        }
    }
}



@end
