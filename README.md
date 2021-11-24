# EasyAdsSDK

[![Version](https://img.shields.io/cocoapods/v/EasyAdsSDK.svg?style=flat)](https://cocoapods.org/pods/EasyAdsSDK)
[![License](https://img.shields.io/cocoapods/l/EasyAdsSDK.svg?style=flat)](https://cocoapods.org/pods/EasyAdsSDK)
[![Platform](https://img.shields.io/cocoapods/p/EasyAdsSDK.svg?style=flat)](https://cocoapods.org/pods/EasyAdsSDK)

# EasyAdsSDK对接文档-IOS


本文档为EasyAdsSDK接入配置参考文档。用户可以参考Example工程中的配置以及广告位接入代码进行开发。

目前聚合SDK聚合的SDK有：Mercury，广点通，穿山甲，请在对接的时候使用支持相应sdk管理的EasyAdsSDK。

### [注意事项](https://www.pangle.cn/union/media/union/download/detail?id=16&docId=5f327098d44dc5000e1d45d5&osType=ios):

- EasyAdsSDK(version:3.2.4.3) 支持了广点通平台所有广告位的2.0, 建议将广点通SDK版本升至4.12.60及以上版本 [详见此处](https://developers.adnet.qq.com/doc/ios/union/union_native_express_pro)

- EasyAdsSDK(version:3.2.3.5) 将穿山甲依赖库由Bytedance-UnionAD更新为Ads-CN
- App Tracking Transparency（ATT）适用于请求用户授权，访问与应用相关的数据以跟踪用户或设备。 访问 https://developer.apple.com/documentation/apptrackingtransparency 了解更多信息。
- SKAdNetwork（SKAN）是 Apple 的归因解决方案，可帮助广告客户在保持用户隐私的同时衡量广告活动。 使用 Apple 的 SKAdNetwork 后，即使 IDFA 不可用，广告网络也可以正确获得应用安装的归因结果。 访问 https://developer.apple.com/documentation/storekit/skadnetwork 了解更多信息。

### Checklist
- 应用编译环境升级至 Xcode 12.0 及以上版本
- 升级穿山甲 iOS SDK 3.5.1.0 及以上版本，穿山甲提供了 iOS 14 与 SKAdNetwork 支持
-  升级广点通  iOS SDK  4.12.60 及以上版本, 该版本适配了SKAdNetwork,并删除了CAID相关的内容
- 将穿山甲和广点通的 SKAdNetwork ID 添加到 info.plist 中，以保证 SKAdNetwork 的正确运行
- 调试阶段尽量中真机, 以便获取idfa, 如果获取不到idfa, 则打开idfa开关, iphone 打开idfa 开关的的过程:设置 -> 隐私 -> 跟踪 -> 允许App请求跟踪

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
  </array>
```

- 支持苹果 ATT：从 iOS 14 开始，若开发者设置 App Tracking Transparency 向用户申请跟踪授权，在用户授权之前IDFA 将不可用。 如果用户拒绝此请求，应用获取到的 IDFA 将自动清零，可能会导致您的广告收入的降低
- 要获取 App Tracking Transparency 权限，请更新您的 Info.plist，添加 NSUserTrackingUsageDescription 字段和自定义文案描述。代码示例：

```
<key>NSUserTrackingUsageDescription</key>
<string>该标识符将用于向您投放个性化广告</string>
```

-  穿山甲在3.5.1.1及以上版本 适配的 iOS14.5 强烈建议更新 更新方法如下 <br>
   1: 先将EasyAdsSDK升级到3.2.4.2或以上版本(该版本添加新版穿山甲所依赖的工具库),否则更新完成将报编译错误<br>
   2:  Podfile中添加 pod 'Ads-CN', '~> 3.5.1.2'  并在 终端里执行 pod update Ads-CN
      

- 如果您已经集成了EasyAdsSDK, 并且想对 广点通, 穿山甲, mercurySDK, 进行单独升级, 升级方法如下

```
use_frameworks!

platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'EasyAdsSDK_Example' do

  pod 'EasyAdsSDK'
  pod 'EasyAdsSDK/Mercury' #必须添加
  pod 'EasyAdsSDK/CSJ' #如果想集成穿山甲,则添加 如果不需要则不添加
  pod 'EasyAdsSDK/GDT' #如果想集成广点通,则添加 如果不需要则不添加
  pod 'EasyAdsSDK/BD' #如果想集成广点通,则添加 如果不需要则不添加
  pod 'EasyAdsSDK/KS' #如果想集成快手,则添加 如果不需要则不添加
    
# 如果想单独升级MercurySDK 则需要指明升级的版本号 例如:
# pod 'MercurySDK', '~> 3.1.6.1'
  终端里执行 pod update MercurySDK

# 如果想单独升级穿山甲 则需要指明升级的版本号 例如:
#  pod 'Ads-CN', '~> 3.5.1.2'
  终端里执行 pod update Ads-CN

# 如果想单独升级广点通 则需要指明升级的版本号 例如:
# pod 'GDTMobSDK', '~> 4.12.60'
  终端里执行 pod update GDTMobSDK

# 如果想单独升级快手 则需要指明升级的版本号 例如:
# pod 'KSAdSDK', '~> 3.3.10'
  终端里执行 pod update KSAdSDK

# 建议添加 CSJ和GDT, BD,KS看需求

end

```


##### SDK全局配置

```

[EasyAdSdkConfig shareInstance].isDebug = YES;
// 设置appid
[EasyAdSdkConfig shareInstance].appId = @"100255";
```



##### 目前EasyAdsSDK支持统一管理的广告位类型为：

- [开屏广告位(Splash)](./_docs/ads/splash_ad.md)
- [横幅广告位(Banner)](./_docs/ads/banner_ad.md)
- [插屏广告位（Interstitial)](./_docs/ads/Interstitial_ad.md)
- [激励视频(RewardVideo)](./_docs/ads/reward_video_ad.md)
- [原生模板信息流广告位(NativeExpress)](./_docs/ads/native_express_ad.md)
- [全屏视频视频(FullScreenVideo)](./_docs/ads/full_screen_ad.md)


## SDK项目部署

自动部署可以省去您工程配置的时间。iOS SDK会通过CocoaPods进行发布，推荐您使用自动部署。

#### Step 1 安装CocoaPods

CocoaPods是Swift和Objective-C Cocoa项目的依赖项管理器。它拥有超过7.1万个库，并在超过300万个应用程序中使用。CocoaPods可以帮助您优雅地扩展项目。如果您未安装过cocoaPods，可以通过以下命令行进行安装。更多详情请访问CocoaPods官网。

```
$ sudo gem install cocoapods
```
注意：安装过程可能会耗时比较长，也有可能收到网络状况导致失败，请多次尝试直到安装成功。

#### Step 2 配置Podfile文件

```
$ pod init
```

打开Podfile文件，应该是如下内容（具体内容可能会有一些出入）：

```
# platform :ios, '9.0'
target '你的项目名称' do
  # use_frameworks!
  # Pods for 你的项目名称
end
```

修改Podfile文件，将pod 'EasyAdsSDK'添加到Podfile中，如下所示：

```
platform :ios, '9.0'
target '你的项目名称' do
  # use_frameworks!
  # Pods for 你的项目名称
  pod 'EasyAdsSDK', '~> 3.2.5.5' # 可指定你想要的版本号
  pod 'EasyAdsSDK/CSJ', 	# 如果需要导入穿山甲SDK 如果不需要则不添加
  pod 'EasyAdsSDK/GDT', 	# 如果需要导入广点通SDK 如果不需要则不添加
  pod 'EasyAdsSDK/Mercury' # 如果需要导入MercurySDK 如果不需要则不添加
  pod 'EasyAdsSDK/BD' # 如果需要导入百青藤SDK 如果不需要则不添加
  pod 'EasyAdsSDK/KS' #如果想集成快手,则添加 如果不需要则不添加

end
```

#### Step 3 使用CocoaPods进行SDK部署
通过CocoaPods安装SDK前，确保CocoaPods索引已经更新。可以通过运行以下命令来更新索引：

```
$ pod repo update
```
运行命令进行安装：
```
$ pod install
```
也可以将上述两条命令合成为如下命令:
```
$ pod install --repo-update
```

命令执行成功后，会生成.xcworkspace文件，可以打开.xcworkspace来启动工程。

#### Step 4 升级SDK

升级SDK时，首先要更新repo库，执行命令：
```
$ pod repo update
```
之后重新执行如下命令进行安装即可升级至最新版SDK

```
$ pod install
```
* 注意 ：只有在Podfile文件中没有指定SDK版本时，运行上述命令才会自动升级到最新版本。不然需要修改Podfile文件，手动指定SDK版本为最新版本。



#### Step 5 指定SDK版本

指定SDK版本前，请先确保repo库为最新版本，参考上一小节内容进行更新。如果需要指定SDK版本，需要在Podfile文件中，pod那一行指定版本号：

```
  pod 'EasyAdsSDK', '~> 3.2.5.5' # 可指定你想要的版本号
  pod 'EasyAdsSDK/CSJ'
  pod 'EasyAdsSDK/GDT'

```
之后运行命令：

```
$ pod install

```

> 注意: 如导入穿山甲SDK出现`_OBJC_CLASS_$_XXXX`提示，可尝试以下方案:

使用Git LFS安装

[Git LFS](https://git-lfs.github.com/) 是用于使用Git管理大型文件的命令行扩展和规范。您可以按照以下步骤安装它：

步骤 1: 点击并下载 [Git LFS](https://git-lfs.github.com/) 

步骤 2: 使用以下命令安装LFS：

```
sudo sh install.sh
```
步骤 3: 检查安装是否正确：

```
git lfs version
```
步骤 4: 再次执行`pod install `

如还有问题的话，有可能是 Cocoapods 的缓存，执行这个命令`rm -rf ~/Library/Caches/CocoaPods`，重新 pod install 就可以了。

#### Step 6 网络配置（必须)

苹果公司在iOS9中升级了应用网络通信安全策略，默认推荐开发者使用HTTPS协议来进行网络通信，并限制HTTP协议的请求，sdk需要app支持http请求：

![902CA139-0E5F-4165-BF3F-4B3E74404EF3](./_docs/imgs/902CA139-0E5F-4165-BF3F-4B3E74404EF3.png)

#### Step 7 链接设置(必须)

在Target->Build Settings -> Other Linker Flags中添加-ObjC, 字母o和c大写。

![1DFAFEBE-74DC-44D4-BFCC-EF0E194C5D45](./_docs/imgs/1DFAFEBE-74DC-44D4-BFCC-EF0E194C5D45.png)

## 接入代码

您可以运行自带的Example工程，参考Example工程中的接入代码进行开发。

### 全局初始化设置

聚合SDK要正确工作需要各个SDK在app启动时正确初始化，具体各个SDK的设置方式不尽相同，请参考各个SDK的文档。


## 验收测试

代码对接完成后请提供测试包给我方对接测试人员进行验收。
