//
//  BdFullScreenVideoAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/6/1.
//

#import "BdFullScreenVideoAdapter.h"

#if __has_include(<BaiduMobAdSDK/BaiduMobAdExpressFullScreenVideo.h>)
#import <BaiduMobAdSDK/BaiduMobAdExpressFullScreenVideo.h>
#else
#import "BaiduMobAdSDK/BaiduMobAdExpressFullScreenVideo.h"
#endif

#import "EasyAdFullScreenVideo.h"
#import "EasyAdLog.h"
@interface BdFullScreenVideoAdapter ()<BaiduMobAdExpressFullScreenVideoDelegate>
@property (nonatomic, strong) BaiduMobAdExpressFullScreenVideo *bd_ad;
@property (nonatomic, weak) EasyAdFullScreenVideo *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation BdFullScreenVideoAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _bd_ad = [[BaiduMobAdExpressFullScreenVideo alloc] init];
        _bd_ad.delegate = self;
        _bd_ad.AdUnitTag = _supplier.adspotId;
        _bd_ad.publisherId = _supplier.appId;
        _bd_ad.adType = BaiduMobAdTypeFullScreenVideo;
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载百度 supplier: %@", _supplier);
    [_bd_ad load];
}

- (void)deallocAdapter {
    
}


- (void)loadAd {
    [super loadAd];
}

- (void)showAd {
    [_bd_ad showFromViewController:_adspot.viewController];
    
}

- (void)dealloc {
    EasyAdLog(@"%s", __func__);
}

#pragma mark - expressFullVideoDelegate

- (void)fullScreenVideoAdLoadSuccess:(BaiduMobAdExpressFullScreenVideo *)video {
    //    EasyAdLog(@"百度全屏视频拉取成功");
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
}

- (void)fullScreenVideoAdLoaded:(BaiduMobAdExpressFullScreenVideo *)video {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
}

- (void)fullScreenVideoAdLoadFailed:(BaiduMobAdExpressFullScreenVideo *)video withError:(BaiduMobFailReason)reason {
//    EasyAdLog(@"全屏视频缓存失败，failReason：%d", reason);
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000030 + reason userInfo:@{@"desc":@"百度广告拉取失败"}];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
    _bd_ad = nil;

}

- (void)fullScreenVideoAdShowFailed:(BaiduMobAdExpressFullScreenVideo *)video withError:(BaiduMobFailReason)reason {
//    NSLog(@"全屏视频展现失败，failReason：%d", reason);
    NSError *error = [[NSError alloc]initWithDomain:@"BDAdErrorDomain" code:1000040 + reason userInfo:@{@"desc":@"百度广告渲染失败"}];
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded  supplier:_supplier error:error];
}

- (void)fullScreenVideoAdDidStarted:(BaiduMobAdExpressFullScreenVideo *)video {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
}

- (void)fullScreenVideoAdDidPlayFinish:(BaiduMobAdExpressFullScreenVideo *)video {
    
//    NSLog(@"全屏视频完成播放");
    if ([self.delegate respondsToSelector:@selector(easyAdFullScreenVideoOnAdPlayFinish)]) {
        [self.delegate easyAdFullScreenVideoOnAdPlayFinish];
    }
}

- (void)fullScreenVideoAdDidClick:(BaiduMobAdExpressFullScreenVideo *)video withPlayingProgress:(CGFloat)progress {
//    NSLog(@"全屏视频被点击，progress:%f", progress);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
}

- (void)fullScreenVideoAdDidClose:(BaiduMobAdExpressFullScreenVideo *)video withPlayingProgress:(CGFloat)progress {
//    NSLog(@"全屏视频点击关闭，progress:%f", progress);
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
}

- (void)fullScreenVideoAdDidSkip:(BaiduMobAdExpressFullScreenVideo *)video withPlayingProgress:(CGFloat)progress{
//    NSLog(@"全屏视频点击跳过，progress:%f", progress);

}


@end
