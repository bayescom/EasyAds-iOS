## 插屏广告

插屏广告分为两个阶段，加载和展示。需要在广告加载成功后调用展示方法展示插屏广告。

```objective-c

#import "DemoInterstitialViewController.h"
#import "DemoUtils.h"

#import <AdvanceSDK/AdvanceInterstitial.h>

@interface DemoInterstitialViewController () <AdvanceInterstitialDelegate>
@property (nonatomic, strong) AdvanceInterstitial *advanceInterstitial;

@end

@implementation DemoInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"mediaId-adspotId", @"adspotId": @"10033-200043"},
    ];
    self.btn1Title = @"加载广告";
    self.btn2Title = @"显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    self.advanceInterstitial = [[AdvanceInterstitial alloc] initWithMediaId:self.mediaId
                                                                   adspotId:self.adspotId
                                                             viewController:self];
    self.advanceInterstitial.delegate=self;
    [self.advanceInterstitial loadAd];
}

- (void)loadAdBtn2Action {
    [self.advanceInterstitial showAd];
}

// MARK: ======================= AdvanceInterstitialDelegate =======================

/// 请求广告数据成功后调用
- (void)advanceUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功 %s", __func__);
}


/// 广告渲染失败
- (void)advanceInterstitialOnAdRenderFailed {
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
    NSLog(@"广告展示失败 %s  error: %@", __func__, error);

}

/// 内部渠道开始加载时调用
- (void)advanceSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);

}

/// 广告关闭了
- (void)advanceDidClose {
    NSLog(@"广告关闭了 %s", __func__);
}

/// 策略请求成功
- (void)advanceOnAdReceived:(NSString *)reqId {
    NSLog(@"%s 策略id为: %@",__func__ , reqId);
}

/// 广告可以show了
- (void)advanceInterstitialOnReadyToShow {
    NSLog(@"广告可以show了 %s",__func__);
}


@end

```