//
//  BdRewardVideoAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/5/27.
//

#import "BdRewardVideoAdapter.h"
#if __has_include(<BaiduMobAdSDK/BaiduMobAdRewardVideo.h>)
#import <BaiduMobAdSDK/BaiduMobAdRewardVideo.h>
#else
#import "BaiduMobAdSDK/BaiduMobAdRewardVideo.h"
#endif
#import "EasyAdRewardVideo.h"
#import "EasyAdLog.h"
@interface BdRewardVideoAdapter ()<BaiduMobAdRewardVideoDelegate>
@property (nonatomic, strong) BaiduMobAdRewardVideo *bd_ad;
@property (nonatomic, weak) EasyAdRewardVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation BdRewardVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _bd_ad = [[BaiduMobAdRewardVideo alloc] init];
        _bd_ad.delegate = self;
        _bd_ad.AdUnitTag = _supplier.adspotId;
        _bd_ad.publisherId = _supplier.appId;
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载百度 supplier: %@", _supplier);
    [_bd_ad load];
}

- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    [_bd_ad showFromViewController:_adspot.viewController];
}

- (void)deallocAdapter {
    _bd_ad = nil;
}


- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

- (void)rewardedAdLoadSuccess:(BaiduMobAdRewardVideo *)video {
    //    NSLog(@"激励视频请求成功");
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }

}

- (void)rewardedAdLoadFail:(BaiduMobAdRewardVideo *)video {
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000000 userInfo:@{@"desc":@"百度广告请求错误"}];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
}

- (void)rewardedVideoAdLoaded:(BaiduMobAdRewardVideo *)video {
//    NSLog(@"激励视频缓存成功");
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoOnAdVideoCached)]) {
        [self.delegate easyAdRewardVideoOnAdVideoCached];
    }
    
}

- (void)rewardedVideoAdLoadFailed:(BaiduMobAdRewardVideo *)video withError:(BaiduMobFailReason)reason {
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000010 + reason userInfo:@{@"desc":@"百度广告缓存错误"}];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
//    NSLog(@"激励视频缓存失败，failReason：%d", reason);
}

- (void)rewardedVideoAdShowFailed:(BaiduMobAdRewardVideo *)video withError:(BaiduMobFailReason)reason {
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000020 + reason userInfo:@{@"desc":@"百度广告展现错误"}];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
//    NSLog(@"激励视频展现失败，failReason：%d", reason);
    //异常情况处理
}

- (void)rewardedVideoAdDidStarted:(BaiduMobAdRewardVideo *)video {
//    NSLog(@"激励视频开始播放");
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }

}

- (void)rewardedVideoAdDidPlayFinish:(BaiduMobAdRewardVideo *)video {
    
//    NSLog(@"激励视频完成播放");
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidPlayFinish)]) {
        [self.delegate easyAdRewardVideoAdDidPlayFinish];
    }

}

- (void)rewardedVideoAdDidClick:(BaiduMobAdRewardVideo *)video withPlayingProgress:(CGFloat)progress {
//    NSLog(@"激励视频被点击，progress:%f", progress);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

- (void)rewardedVideoAdDidClose:(BaiduMobAdRewardVideo *)video withPlayingProgress:(CGFloat)progress {
//    NSLog(@"激励视频点击关闭，progress:%f", progress);
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

- (void)rewardedVideoAdDidSkip:(BaiduMobAdRewardVideo *)video withPlayingProgress:(CGFloat)progress {
//    NSLog(@"激励视频点击跳过, progress:%f", progress);
}

- (void)rewardedVideoAdRewardDidSuccess:(BaiduMobAdRewardVideo *)video verify:(BOOL)verify {
    //    NSLog(@"激励成功回调, progress:%f", progress);
    if ([self.delegate respondsToSelector:@selector(easyAdRewardVideoAdDidRewardEffective)]) {
        [self.delegate easyAdRewardVideoAdDidRewardEffective];
    }
}


@end
