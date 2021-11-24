## 自定义广告位接入开发

如果默认广告位实现不符合要求，或者您需要支持其他SDK的广告，可以采用自定义开发的方式接入策略管理。

导入头文件，实现`AdvanceBaseAdspotDelegate`代理

```Objective-C
#import <AdvanceSDK/AdvanceSDK.h>

@interface CustomSplashViewController () <AdvanceBaseAdspotDelegate>
@property (nonatomic, strong) AdvanceBaseAdspot *adspot;
@end

```

初始化广告管理对象并实现代理方法`_adspot.supplierDelegate`，开发者需要在`advanceBaseAdspotWithSdkId: params:`中根据返回的渠道Id，自行处理渠道的初始化。

```Objective-C
- (void)loadAdBtn1Action {
    if (![self checkAdspotId]) { return; }
    _adspot = [[AdvanceBaseAdspot alloc] initWithMediaId:self.mediaId adspotId:self.adspotId];
    [_adspot setDefaultSdkSupplierWithMediaId:@"100255"
                                adspotId:@"10002436"
                                mediaKey:@"757d5119466abe3d771a211cc1278df7"
                                  sdkId:SDK_ID_MERCURY];
    _adspot.supplierDelegate = self;
    [_adspot loadAd];
}

// MARK: ======================= AdvanceBaseAdspotDelegate =======================
/// 加载渠道广告，将会返回渠道所需参数
/// @param sdkId 渠道Id
/// @param params 渠道参数
- (void)advanceBaseAdspotWithSdkId:(NSString *)sdkId params:(NSDictionary *)params {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 根据渠道id自定义初始化
    if ([sdkId isEqualToString:SDK_ID_GDT]) {
        _gdt_ad = [[GDTSplashAd alloc] initWithAppId:[params objectForKey:@"mediaid"]
                                         placementId:[params objectForKey:@"adspotid"]];
        _gdt_ad.delegate = self;
        _gdt_ad.fetchDelay = 5;
        [_gdt_ad loadAdAndShowInWindow:window];
    } else if ([sdkId isEqualToString:SDK_ID_CSJ]) {
        _csj_ad = [[BUNativeExpressSplashView alloc] initWithSlotID:[params objectForKey:@"adspotid"]
                                                             adSize:[UIScreen mainScreen].bounds.size
                                                 rootViewController:self];
        _csj_ad.delegate = self;
        _csj_ad.tolerateTimeout = 3;
        [_csj_ad loadAdData];
        [window addSubview:_csj_ad];
    } else if ([sdkId isEqualToString:SDK_ID_MERCURY]) {
        _mercury_ad = [[MercurySplashAd alloc] initAdWithAdspotId:[params objectForKey:@"adspotid"]
                                                         delegate:self];
        _mercury_ad.controller = self;
        [_mercury_ad loadAdAndShow];
    }
}

/// @param sdkId 渠道Id
/// @param error 失败原因
- (void)advanceBaseAdspotWithSdkId:(NSString *)sdkId error:(NSError *)error {
    NSLog(@"%@", error);
}

```

**事件上报**
> 事件上报必须在对应事件回调方法中执行

使用`[_adspot reportWithType:事件上报类型];`进行事件上报，需手动调用的上报有4种:

1. AdvanceSdkSupplierRepoSucceeded（广告拉取成功）
2. AdvanceSdkSupplierRepoImped（广告曝光）
3. AdvanceSdkSupplierRepoFaileded（广告拉取失败）
4. AdvanceSdkSupplierRepoClicked（广告被点击）

**注意**：在失败上报的方法中同时需要手动执行策略切换方法，此方法会在某渠道广告拉取失败后快速选择下一个渠道广告

```
[_adspot selectSdkSupplierWithError:error];
```

具体实现可参照Example工程。