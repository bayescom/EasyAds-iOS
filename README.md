# EasyAdsSDK

[![Version](https://img.shields.io/cocoapods/v/EasyAdsSDK.svg?style=flat)](https://cocoapods.org/pods/EasyAdsSDK)
[![License](https://img.shields.io/cocoapods/l/EasyAdsSDK.svg?style=flat)](https://cocoapods.org/pods/EasyAdsSDK)
[![Platform](https://img.shields.io/cocoapods/p/EasyAdsSDK.svg?style=flat)](https://cocoapods.org/pods/EasyAdsSDK)

# EasyAdsSDK对接文档-IOS

## 基础概念

**聚合SDK概念解释(下称EasyAdsSDK)**: EasyAdsSDK是对广点通,穿山甲, 百度(百青藤), 快手(快手联盟) 等广告平台SDK调度逻辑的封装, EasyAdsSDK本身并不投放广告

**渠道**: 泛指[广点通](https://developers.adnet.qq.com/doc/ios/guide), [穿山甲](https://www.csjplatform.com/union/media/union/download/detail?id=16&osType=ios),  [百度](https://union.baidu.com/miniappblog/2020/08/11/iOSSDK/), [快手](https://u.kuaishou.com/) 等广告平台及其SDK

**媒体**: 指集成了EasyAdsSDK的App及开发者

## 为何选择EasyAdsSDK

### 1. 广告资源丰富, 填充率高

与单独集成某一个渠道相比, EasyAdsSDK 能充分发挥各个平台的优势, 当某一渠道没返回广告时,  EasyAdsSDK会自行加载其他渠道的广告, 尽可能的提高开发者的收益!

### 2. 集成简单, 开发成本低

EasyAdsSDK采用cocoapods集成的方式, 并且可以通过podfile对各个渠道选择性安装, 开发者无须进行二次开发, 直接调用EasyAdsSDK封装的上层接口即可!

### 3. 支持流量分组

与单独集成某一个渠道相比, EasyAdsSDK 支持流量分层, 可以把App的流量按比例分布到各个渠道当中, 帮助开发者寻求流量变现的最优解!

### 4. 完全开源, 可拓展性强

EasyAdsSDK完全开源,  且拓展性强, 如果EasyAdsSDK不能满足开发者需求的话, 可自行更改内部逻辑,满足自己的需求

### 5. 免费, 安全

EasyAdsSDK内部没有任何的接口上报, 不获取开发者及用户的任何信息, 如果开发者愿意, 完全可以私有化部署到自己的平台


## EasyAdsSDK各渠道广告位支持情况

| 平台\广告位| 	开屏 |  激励视频 | 横幅| 插屏 | 信息流 | 全屏视频 |
|:------------- |:---------------|  :---------------|  :---------------|  :---------------|  :---------------| :---------------|
| 广点通  |✅ |✅ |✅ |✅ |✅ |✅|
| 穿山甲|✅ |✅ |✅  |✅|✅|✅  |
| 百度 |✅  |✅  |✅ | ❌ | ✅ | ✅ |
| 快手 |✅  |✅  |❌ | ✅  | ✅ | ✅ |


## 开始集成

### 开发环境

确保您的开发及部署环境符合以下标准：

- 开发工具：推荐Xcode 12及以上版本
- 部署目标：iOS 9.0及以上版本

### 准备工作

- 将各个渠道的 SKAdNetwork ID 添加到 info.plist 中，以保证 SKAdNetwork 的正确运行

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

- 要获取 App Tracking Transparency 权限，请更新您的 Info.plist，添加 NSUserTrackingUsageDescription 字段和自定义文案描述。代码示例：


```
 <key>NSUserTrackingUsageDescription</key>
 <string>该标识符将用于向您投放个性化广告</string>
```



- **调试阶段尽量中真机**, 以便获取idfa, 如果获取不到idfa, 则需要打开idfa开关</br>iphone 打开idfa 开关的的过程:设置 -> 隐私 -> 跟踪 -> 允许App请求跟踪

- [安装cocoapods及可能遇见的问题(cocoapods)](./_docs/ads/cocoapods.md)

- Podfile内容如下, 如果您已经集成了EasyAdsSDK, 并且想对某个渠道, 进行单独升级, 升级方法如下

```
use_frameworks!

platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'EasyAdsSDK_Example' do

  pod 'EasyAdsSDK'
  pod 'EasyAdsSDK/CSJ' #如果想集成穿山甲,则添加 如果不需要则不添加
  pod 'EasyAdsSDK/GDT' #如果想集成广点通,则添加 如果不需要则不添加
  pod 'EasyAdsSDK/BD'  #如果想集成广点通,则添加 如果不需要则不添加
  pod 'EasyAdsSDK/KS'  #如果想集成快手,则添加 如果不需要则不添加

# 如果想单独升级穿山甲 则需要指明升级的版本号 例如:
#  pod 'Ads-CN', '~> 3.5.1.2'
  终端里执行 pod update Ads-CN

# 如果想单独升级广点通 则需要指明升级的版本号 例如:
# pod 'GDTMobSDK', '~> 4.12.60'
  终端里执行 pod update GDTMobSDK

# 如果想单独升级快手 则需要指明升级的版本号 例如:
# pod 'KSAdSDK', '~> 3.3.10'
  终端里执行 pod update KSAdSDK

# 如果想单独升级快手 则需要指明升级的版本号 例如:
# pod 'BaiduMobAdSDK', '~> 4.771'
  终端里执行 pod update KSAdSDK

end

```


## 接入代码

您可以运行自带的Example工程，参考Example工程中的接入代码进行开发。

### SDK全局配置

```
// 设置log级别
[EasyAdSdkConfig shareInstance].level = EasyAdLogLevel_Debug;
// 获取 EasyAdsSdk的版本号
[EasyAdSdkConfig sdkVersion];
```

### EasyAdsSDK支持统一管理的广告位类型为：

- [开屏广告位(Splash)](./_docs/ads/splash_ad.md)
- [横幅广告位(Banner)](./_docs/ads/banner_ad.md)
- [插屏广告位（Interstitial)](./_docs/ads/Interstitial_ad.md)
- [激励视频(RewardVideo)](./_docs/ads/reward_video_ad.md)
- [原生模板信息流广告位(NativeExpress)](./_docs/ads/native_express_ad.md)
- [全屏视频视频(FullScreenVideo)](./_docs/ads/full_screen_ad.md)



## **广告位初始化设置**

广告位初始化的时候需要传入一个字典(NSDictionary),该字典是由json转化而来, json格式请参照Demo当中DataJson目录下的.json文件, 该json 也可以开发者的服务器自行下发, 切记格式务必严谨

### json格式示例
```

{
  "rules": [
    {
      "tag": "A",
      "sort": [
        1,
        3
      ],
      "percent": 30
    },
    {
      "tag": "B",
      "sort": [
        2,
        4
      ],
      "percent": 70
    }
  ],
  "suppliers": [
    {
      "tag": "csj",
      "adspotId": "887477661",
      "appId": "5051624",
      "index": 1
    },
    {
      "tag": "ylh",
      "adspotId": "2001447730515391",
      "appId": "1101152570",
      "index": 2
    },
    {
      "tag": "ks",
      "adspotId": "4000000042",
      "appId": "90009",
      "index": 3
    },
    {
      "tag": "bd",
      "adspotId": "2058622",
      "appId": "e866cfb0",
      "index": 4
    }
  ]
}

```

### json各字段的含义

| 字段名| 字段类型 |  含义 | 
|:-------------|:-------------:|-------------|
| tag(rules) | String | **策略组唯一标记**，用于区分标记不同组的执行情况 |
| sort |  List  &lt;Integer&#x0003E; | **广告SDK执行顺序表**，依照组内顺序，优先级从高到低，组内成员对应suppliers字段中的index变量 |
| percent | int | **流量占比值**，SDK内部会根据多组内配置的值，自动计算比例，执行流量百分比的分发模式，建议使用百分值。<br><br>比如上述json示例中配置的含义为：在发起请求后，有30%的概率执行策略组A中配置，按照1->3的顺序依次执行广告加载；70%的概率执行策略组A中配置，按照2->4的顺序依次执行广告加载。<br><br>如果A、B两组中percent配置值分别为201、799，代表20.1%的概率执行A，79.9%的概率执行B。<br><br>如果A、B两组中percent配置值分别为2、3，代表40%的概率执行A，60%的概率执行B。 <br><br>如果仅有一组A，不论percent按照多少设置，都默认100%的流量执行A|
| index | int | **渠道唯一标识**，用来和rules信息内sort字段关联，确定广告执行顺序 |
| tag | String | **SDK类别标识**，<br>"csj"代表头条-穿山甲SDK<br>"ylh"代表腾讯-优量汇SDK（前广点通）<br>"ks"代表快手-快手联盟SDK<br>"bd"代表百度-百青藤SDK |
| adspotId | String | 广告位id，在变现SDK后台申请到的具体广告位id |
| appId | String | 应用id，在变现SDK后台申请到的应用id |

### json文件转成NSDictionary的示例代码

```
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

聚合SDK要正确工作需要各个SDK在app启动时正确初始化，具体各个SDK的设置方式不尽相同，请参考各个SDK的文档。


