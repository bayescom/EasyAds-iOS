//
//  DemoRewardVideoViewController.m
//  EasyAdsSDKDemo
//
//  Created by CherryKing on 2020/1/3.
//  Copyright © 2020 BAYESCOM. All rights reserved.
//

#import "DemoRewardVideoViewController.h"

#import <EasyAdsSDK/EasyAdRewardVideo.h>
#import "AdDataJsonManager.h"
@interface DemoRewardVideoViewController () <EasyAdRewardVideoDelegate>
@property (nonatomic, strong) EasyAdRewardVideo *EasyAdRewardVideo;
@property (nonatomic) bool isAdLoaded; // 激励视频播放器 采用的是边下边播的方式, 理论上拉取数据成功 即可展示, 但如果网速慢导致缓冲速度慢, 则激励视频会出现卡顿
                                       // 广点通推荐在 easyAdRewardVideoOnAdVideoCached 视频缓冲完成后 在掉用showad
@end

@implementation DemoRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"激励视频";
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_rewardVideo];

}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    
    

    self.EasyAdRewardVideo = [[EasyAdRewardVideo alloc] initWithJsonDic:self.dic viewController:self];
    self.EasyAdRewardVideo.delegate=self;
    [self.EasyAdRewardVideo loadAd];

    
    [self loadAdWithState:AdState_Loading];

}

- (void)showAd {
    if (!self.EasyAdRewardVideo || !self.isLoaded) {
        [JDStatusBarNotification showWithStatus:@"请先加载广告" dismissAfter:1.5];
        return;
    }
    [self.EasyAdRewardVideo showAd];

}

- (void)loadAndShowAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    
    

    self.EasyAdRewardVideo = [[EasyAdRewardVideo alloc] initWithJsonDic:self.dic viewController:self];
    self.EasyAdRewardVideo.delegate=self;
    [self.EasyAdRewardVideo loadAndShowAd];

    
    [self loadAdWithState:AdState_Loading];

}

- (void)deallocAd {
    self.EasyAdRewardVideo = nil;
    self.EasyAdRewardVideo.delegate = nil;
    self.isLoaded = NO;
    [self loadAdWithState:AdState_Normal];

}

// MARK: ======================= EasyAdRewardVideoDelegate =======================
/// 广告数据加载成功
- (void)easyAdUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功, 正在缓存... %s", __func__);
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告数据拉取成功", __func__]];
}

/// 视频缓存成功
- (void)easyAdRewardVideoOnAdVideoCached
{
    NSLog(@"视频缓存成功 %s", __func__);
    [JDStatusBarNotification showWithStatus:@"视频缓存成功" dismissAfter:1.5];
    self.isLoaded = YES;
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 视频缓存成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];

}

/// 到达激励时间
- (void)easyAdRewardVideoAdDidRewardEffective {
    NSLog(@"到达激励时间 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 到达激励时间", __func__]];
}

/// 广告曝光
- (void)easyAdExposured {
    NSLog(@"广告曝光回调 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告曝光回调", __func__]];
}

/// 广告点击
- (void)easyAdClicked {
    NSLog(@"广告点击 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告点击", __func__]];
}

/// 广告加载失败
- (void)easyAdFailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error,description);
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告加载失败", __func__]];
    [self showErrorWithDescription:description];
    [self loadAdWithState:AdState_LoadFailed];
    [self deallocAd];


}

/// 内部渠道开始加载时调用
- (void)easyAdSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 内部渠道开始加载", __func__]];
}

/// 广告关闭
- (void)easyAdDidClose {
    NSLog(@"广告关闭了 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告关闭了", __func__]];
    [self deallocAd];
}

/// 播放完成
- (void)easyAdRewardVideoAdDidPlayFinish {
    NSLog(@"播放完成 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 播放完成", __func__]];
}

- (void)easyAdSuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}


@end
