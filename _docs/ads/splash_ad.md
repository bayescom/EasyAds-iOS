## 开屏广告

开屏广告需要传入当前ViewController作为参数，开屏广告展示时间统一为5秒钟，开发者可以设置统一的广告请求超时时间，超时时间默认为5秒。

```objective-c

#import "DemoSplashViewController.h"
#import "DemoUtils.h"
#import <AdvanceSDK/AdvanceSplash.h>

@interface DemoSplashViewController () <AdvanceSplashDelegate>
@property(strong,nonatomic) AdvanceSplash *advanceSplash;
@end

@implementation DemoSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"mediaId-adspotId", @"adspotId": @"10033-200034"},
    ];
    self.btn1Title = @"加载并显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    self.advanceSplash = [[AdvanceSplash alloc] initWithMediaId:self.mediaId
                                                       adspotId:self.adspotId
                                                 viewController:self];
    self.advanceSplash.delegate=self;
    self.advanceSplash.logoImage= [UIImage imageNamed:@"640-100"];
    self.advanceSplash.backgroundImage= [UIImage imageNamed:@"LaunchImage_img"];
    [self.advanceSplash loadAd];
}

// MARK: ======================= AdvanceSplashDelegate =======================
/// 广告数据拉取成功
- (void)advanceUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功 %s", __func__);
}

/// 广告曝光成功
- (void)advanceExposured {
    NSLog(@"广告曝光成功 %s", __func__);
}

/// 广告加载失败
- (void)advanceFailedWithError:(NSError *)error {
    NSLog(@"广告展示失败 %s  error: %@", __func__, error);

}

/// 内部渠道开始加载时调用
- (void)advanceSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);

}
/// 广告点击
- (void)advanceClicked {
    NSLog(@"广告点击 %s", __func__);
}

/// 广告关闭
- (void)advanceDidClose {
    NSLog(@"广告关闭了 %s", __func__);
}

/// 广告倒计时结束
- (void)advanceSplashOnAdCountdownToZero {
    NSLog(@"广告倒计时结束 %s", __func__);
}

/// 点击了跳过
- (void)advanceSplashOnAdSkipClicked {
    NSLog(@"点击了跳过 %s", __func__);
}

// 策略请求成功
- (void)advanceOnAdReceived:(NSString *)reqId {
    NSLog(@"%s 策略id为: %@",__func__ , reqId);
}

@end

```