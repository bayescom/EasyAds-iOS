## 横幅广告

横幅广告需要设置广告容器，当前的ViewController作为参数。开发者可以设置广告轮播时间控制广告轮播时间，默认轮播时间为30秒。

```objective-c

#import "DemoBannerViewController.h"
#import "ViewBuilder.h"

#import <AdvanceSDK/AdvanceBanner.h>

@interface DemoBannerViewController () <AdvanceBannerDelegate>
@property (nonatomic, strong) AdvanceBanner *advanceBanner;
@property (nonatomic, strong) UIView *contentV;

@end

@implementation DemoBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"Banner", @"adspotId": @"10033-200031"},
    ];
    self.btn1Title = @"加载并显示广告";
}

- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    if (!_contentV) {
        _contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/6.4)];
    }
    [self.adShowView addSubview:self.contentV];
    self.adShowView.hidden = NO;
    
    self.advanceBanner = [[AdvanceBanner alloc] initWithMediaId:self.mediaId adspotId:self.adspotId adContainer:self.contentV viewController:self];
    self.advanceBanner.delegate = self;
    [self.advanceBanner loadAd];
}

// MARK: ======================= AdvanceBannerDelegate =======================
/// 广告数据拉取成功回调
- (void)advanceUnifiedViewDidLoad {
    NSLog(@"广告数据拉取成功 %s", __func__);
}

/// 广告加载失败
- (void)advanceFailedWithError:(NSError *)error {
    NSLog(@"广告展示失败 %s  error: %@", __func__, error);

}

/// 内部渠道开始加载时调用
- (void)advanceSupplierWillLoad:(NSString *)supplierId {
    NSLog(@"内部渠道开始加载 %s  supplierId: %@", __func__, supplierId);

}

/// 广告曝光
- (void)advanceExposured {
    NSLog(@"广告曝光回调 %s", __func__);
}

/// 广告点击
- (void)advanceClicked {
    NSLog(@"广告点击 %s", __func__);
}

/// 广告关闭回调
- (void)advanceDidClose {
    NSLog(@"广告关闭了 %s", __func__);
}

/// 策略请求成功
- (void)advanceOnAdReceived:(NSString *)reqId {
    NSLog(@"%s 策略id为: %@",__func__ , reqId);
}
@end

```