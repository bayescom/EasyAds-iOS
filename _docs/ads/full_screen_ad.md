## 全屏视频视频
全屏视频视频分为广告数据加载，视频缓存，以及展示阶段，当视频缓存成功回调后可以调用展示方法展示激励视频，激励视频在展示的过程可以被关闭。

```objective-c
#import "DemoFullScreenVideoController.h"
#import "DemoUtils.h"
#import <AdvanceSDK/AdvanceFullScreenVideo.h>

@interface DemoFullScreenVideoController () <AdvanceFullScreenVideoDelegate>
@property (nonatomic, strong) AdvanceFullScreenVideo *advanceFullScreenVideo;

@end

@implementation DemoFullScreenVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"mediaId-adspotId", @"adspotId": @"10033-200076"},
    ];
    self.btn1Title = @"加载广告";
    self.btn2Title = @"显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    self.advanceFullScreenVideo = [[AdvanceFullScreenVideo alloc] initWithMediaId:self.mediaId
                                                                   adspotId:self.adspotId
                                                             viewController:self];
    self.advanceFullScreenVideo.delegate = self;
    [self.advanceFullScreenVideo loadAd];
}

- (void)loadAdBtn2Action {
    [self.advanceFullScreenVideo showAd];
}

// MARK: ======================= AdvanceFullScreenVideoDelegate =======================


/// 请求广告数据成功后调用
- (void)advanceUnifiedViewDidLoad {
    NSLog(@"请求广告数据成功后调用 %s", __func__);
    _isAdLoaded=true;
    [JDStatusBarNotification showWithStatus:@"广告加载成功" dismissAfter:1.5];
}

/// 广告渲染失败
- (void)advanceFullScreenVideoOnAdRenderFailed {
    NSLog(@"广告渲染失败 %s", __func__);
}

/// 广告曝光
- (void)advanceExposured {
    NSLog(@"广告曝光回调 %s", __func__);
}

/// 广告点击
- (void)advanceClicked {
    NSLog(@"广告点击 %s", __func__);
}

/// 广告加载失败
- (void)advanceFailedWithError:(NSError *)error {
    [JDStatusBarNotification showWithStatus:@"广告加载失败" dismissAfter:1.5];
    NSLog(@"广告展示失败 %s  error: %@", __func__, error);

}

/// 内部渠道开始加载时调用
- (void)advanceSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);

}

/// 广告关闭
- (void)advanceDidClose {
    NSLog(@"广告关闭了 %s", __func__);
}

/// 广告播放完成
- (void)advanceFullScreenVideoOnAdPlayFinish {
    NSLog(@"广告播放完成 %s", __func__);
}

/// 策略加载成功
- (void)advanceOnAdReceived:(NSString *)reqId
{
    NSLog(@"%s 策略id为: %@",__func__ , reqId);
}
@end

```