//
//  DemoFullScreenVideoController.m
//  EasyAdsSDKDev
//
//  Created by CherryKing on 2020/4/13.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "DemoFullScreenVideoController.h"
#import <EasyAdsSDK/EasyAdFullScreenVideo.h>
#import "AdDataJsonManager.h"
@interface DemoFullScreenVideoController () <EasyAdFullScreenVideoDelegate>
@property (nonatomic, strong) EasyAdFullScreenVideo *EasyAdFullScreenVideo;
@property (nonatomic) bool isAdLoaded;

@end

@implementation DemoFullScreenVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全屏视频";
    self.dic = [[AdDataJsonManager shared] loadAdDataWithType:JsonDataType_fullScreenVideo];

}

- (void)loadAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    
    

    self.EasyAdFullScreenVideo = [[EasyAdFullScreenVideo alloc] initWithJsonDic:self.dic viewController:self];
    self.EasyAdFullScreenVideo.delegate=self;
    [self.EasyAdFullScreenVideo loadAd];

    
    [self loadAdWithState:AdState_Loading];

}

- (void)showAd {
    if (!self.EasyAdFullScreenVideo || !self.isLoaded) {
        [JDStatusBarNotification showWithStatus:@"请先加载广告" dismissAfter:1.5];
        return;
    }
    [self.EasyAdFullScreenVideo showAd];

}

- (void)loadAndShowAd {
    [super loadAd];
    [self deallocAd];
    [self loadAdWithState:AdState_Normal];
    
    

    self.EasyAdFullScreenVideo = [[EasyAdFullScreenVideo alloc] initWithJsonDic:self.dic viewController:self];
    self.EasyAdFullScreenVideo.delegate=self;
    [self.EasyAdFullScreenVideo loadAndShowAd];

    
    [self loadAdWithState:AdState_Loading];

}

- (void)deallocAd {
    self.EasyAdFullScreenVideo = nil;
    self.EasyAdFullScreenVideo.delegate = nil;
    self.isLoaded = NO;
    [self loadAdWithState:AdState_Normal];

}


// MARK: ======================= EasyAdFullScreenVideoDelegate =======================

/// 请求广告数据成功后调用
- (void)easyAdUnifiedViewDidLoad {
    NSLog(@"请求广告数据成功后调用 %s", __func__);
    self.isLoaded = YES;
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 视频缓存成功", __func__]];
    [self loadAdWithState:AdState_LoadSucceed];
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

- (void)easyAdFailedWithError:(NSError *)error description:(NSDictionary *)description{
    NSLog(@"广告展示失败 %s  error: %@ 详情:%@", __func__, error, description);
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

/// 广告播放完成
- (void)easyAdFullScreenVideoOnAdPlayFinish {
    NSLog(@"广告播放完成 %s", __func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 广告播放完成", __func__]];
}

- (void)easyAdSuccessSortTag:(NSString *)sortTag {
    NSLog(@"选中了 rule '%@' %s", sortTag,__func__);
    [self showProcessWithText:[NSString stringWithFormat:@"%s\r\n 选中了 rule '%@' ", __func__, sortTag]];
}

@end
