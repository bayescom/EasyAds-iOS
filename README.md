# EasyAds-iOS 快速指引

## 1. 支持的SDK平台及广告位

| SDK平台 | 版本号 | 开屏 | 激励视频 | 横幅 | 插屏(弹窗) | 模板信息流 | 全屏视频 | draw信息流 |
|-------|---|---|---|---|---|---|---|---| 
| 穿山甲   |4.9.0.6| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| 优量汇   |4.14.02| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| 百青藤   |5.101| ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ |
| 快手    |3.3.36| ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |

**注意:** EasyAds不对各SDK的版本号进行限制, 上图中的版本号的意义是该版本的EasyAds是基于上述SDK平台版本进行开发的


## 2. 快速接入

下面介绍EasyAds的快速接入方法，开发中也可以参考[Example](https://github.com/bayescom/EasyAds-iOS/tree/main/Example)下的示例工程，快速了解。

### 2.1 开发环境准备

- 开发工具：推荐使用Xcode 12及以上版本
- 部署目标：iOS 9.0及以上版本
- 开发管理工具：[CocoaPods](https://cocoapods.org/)，[CocoaPods安装方法及问题参考](https://github.com/bayescom/EasyAds-iOS/wiki/5.1-CocoaPods%E5%AE%89%E8%A3%85%E5%8F%8A%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)


### 2.2 引入SDK
根据需要将相关的渠道SKAdNetwork ID添加到info.plist中，保证SKAdNetwork 的正确运行。
示例如下：

```
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>238da6jt44.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>22mmun2rn5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>f7s53z58qe.skadnetwork</string>
    </dict>
     <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>r3y5dwb26t.skadnetwork</string>
    </dict>
  </array>
```




### 2.3 SDK分发策略配置

配置SDK的分发策略，可方便的实现流量的切分操作，实现多SDK的混合执行策略。

在EasyAds中，我们通过JSON文件的方式配置SDK的分发策略，开发者可根据自身流量分发的需求，按照EasyAds中提供的JSON配置格式及方法设置流量分发策略。

以开屏广告对接穿山甲和优量汇两个SDK为例，配置选择80%流量穿山甲->优量汇的顺序请求，20%流量优量汇->穿山甲的顺序请求，配置如下所示。

其中，suppliers字段下配置媒体在穿山甲和优量汇平台申请的广告代码位信息，rules字段下配置流量分发策略及比例；

策略JSON的配置说明详细见：[SDK策略配置JSON说明](https://github.com/bayescom/EasyAds-iOS/wiki/2.-SDK%E5%88%86%E5%8F%91%E7%AD%96%E7%95%A5%E9%85%8D%E7%BD%AEJSON)

不同广告位的JSON策略配置示例见：[不同广告位JSON配置示例](https://github.com/bayescom/EasyAds-iOS/tree/main/Example/EasyAdsSDK/ExampleController/Template/DataJson)

```json
{
  "rules": [
    {
      "tag": "A",
      "sort": [
        1,
        2
      ],
      "percent": 80
    },
    {
      "tag": "B",
      "sort": [
        2,
        1
      ],
      "percent": 20
    }
  ],
  "suppliers": [
    {
      "tag": "csj",
      "adspotId": "穿山甲广告位ID",
      "appId": "穿山甲应用ID",
      "index": 1
    },
    {
      "tag": "ylh",
      "adspotId": "优量汇广告位ID",
      "appId": "优量汇应用ID",
      "index": 2
    }
  ]
}
```

**注：**
为了方便开发者配置流量分发策略，我们也提供了在线可视化的便捷工具[EasyTools](http://easyads.bayescom.cn/#/tools)，方便生成广告位的策略配置JSON。


### 2.3 获取广告

以下步骤，为获取广告的必要步骤，**适用于所有广告位**。 不同广告位置的不同实现，可参考[Example示例](https://github.com/bayescom/EasyAds-iOS/tree/main/Example)；

####  2.3.1 获取执行策略

从SDK策略配置的JSON文件获取分发策略并转换成NSDictionary，可参考Demo中的AdDataJsonManager文件

```objective-c
- (NSDictionary *)loadAdDataWithJsonName:(NSString *)jsonName {
    if (!jsonName) {
        return nil;
    }
    
    @try {
        NSString *path = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    } @catch (NSException *exception) {}
}
```

#### 2.3.2 使用执行策略初始化广告对象

使用获取的执行策略初始化广告对象`EasyAdXXX`，以开屏为例

```objective-c
EasyAdSplash *splashAd = [[EasyAdSplash alloc] initWithJsonDic:self.dic viewController:self];
```

#### 2.3.3 设置代理

```objective-c
splashAd.delegate = self
```

#### 2.3.4 设置其他属性(可选)

App根据自生需要设置以下参数

```objective-c
// 是否必须展示Logo 默认: NO 注意: 强制展示Logo可能会影响收益 !!!
splashAd.showLogoRequire = YES;
// App logo图片
splashAd.logoImage = [UIImage imageNamed:@"app_logo"];
// 开屏广告未加载完成时,所展示的背景图(建议设置为启动页图片)
splashAd.delegate.backgroundImage = [UIImage imageNamed:@"LaunchImage_img"];
// 超时时间
splashAd.delegate.timeout = 5;

```

#### 2.3.5 调用获取广告

方式一：**请求并展示广告**。

```objective-c
[splashAd loadAndShowAd];
```

方式二：先发起请求广告：

```objective-c
[splashAd loadAd];
```

待广告成功拉取后，开发者可根据业务需求在合适的时机，决定调用展示广告方法。(**注意：广告会存在有效期，过久未调用展示，会导致广告失效**)

```objective-c
[splashAd  showAd];
```

#### 2.3.4 各广告位集成实现

* [开屏广告：EasyAdSplash](https://github.com/bayescom/EasyAds-iOS/wiki/3.1-%E5%BC%80%E5%B1%8F%E5%B9%BF%E5%91%8A)

* [插屏广告：EasyAdInterstitial](https://github.com/bayescom/EasyAds-iOS/wiki/3.2-%E6%8F%92%E5%B1%8F%28%E5%BC%B9%E7%AA%97%29%E5%B9%BF%E5%91%8A)

* [横幅广告：EasyAdBanner](https://github.com/bayescom/EasyAds-iOS/wiki/3.3-%E6%A8%AA%E5%B9%85%E5%B9%BF%E5%91%8A)

* [原生模板、信息流广告：EasyAdNativeExpress](https://github.com/bayescom/EasyAds-iOS/wiki/3.4-%E5%8E%9F%E7%94%9F%E6%A8%A1%E6%9D%BF%E3%80%81%E4%BF%A1%E6%81%AF%E6%B5%81%E5%B9%BF%E5%91%8A)

* [激励视频广告：EasyAdRewardVideo](https://github.com/bayescom/EasyAds-iOS/wiki/3.5-%E6%BF%80%E5%8A%B1%E8%A7%86%E9%A2%91%E5%B9%BF%E5%91%8A)

* [全屏视频广告：EasyAdFullScreenVideo](https://github.com/bayescom/EasyAds-iOS/wiki/3.6-%E5%85%A8%E5%B1%8F%E8%A7%86%E9%A2%91%E5%B9%BF%E5%91%8A)


## 3. SDK错误码 & 常见问题

调试遇到问题？欢迎查询SDK错误码及常见问题FAQ，帮助你快速解决对接中遇到的问题。

[SDK错误码](https://github.com/bayescom/EasyAds-iOS/wiki/4.1-SDK%E9%94%99%E8%AF%AF%E7%A0%81)

[常见问题](https://github.com/bayescom/EasyAds-iOS/wiki/4.2-%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)


## 技术支持

QQ群：
<a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=E_IUfzy5PqOteuekOryWlfjZL6AQZuCE&jump_from=webapi"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="EasyAds开源社区群" title="EasyAds开源社区群"></a>

QQ群二维码：

![image](http://www.bayescom.com/uploads/20211220/43af3f34fc5a7bb50d84f94e374b3e98.png)

邮件技术支持：<easyads@bayescom.com>

