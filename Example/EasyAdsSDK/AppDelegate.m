//
//  AppDelegate.m
//  EasyAdsSDK
//
//  Created by Cheng455153666 on 02/27/2020.
//  Copyright (c) 2020 Cheng455153666. All rights reserved.
//

#import "AppDelegate.h"

// DEBUG
//#import <STDebugConsole.h>
//#import <STDebugConsoleViewController.h>
//#import <JPFPSStatus.h>

#import "ViewController.h"

#import <EasyAdSplash.h>

#import <EasyAdsSDK/EasyAdSplash.h>
#import <EasyAdSdkConfig.h>

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate () <EasyAdSplashDelegate>
@property(strong,nonatomic) EasyAdSplash *EasyAdSplash;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    // 请现在 plist 文件中配置 NSUserTrackingUsageDescription
    /*
     <key>NSUserTrackingUsageDescription</key>
     <string>该ID将用于向您推送个性化广告</string>
     */
    // 项目需要适配http
    
    /*
     <key>NSAppTransportSecurity</key>
     <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
     </dict>
     */
    // 调试阶段尽量用真机, 以便获取idfa, 如果获取不到idfa, 则打开idfa开关
    // iphone 打开idfa 开关的的过程:设置 -> 隐私 -> 跟踪 -> 允许App请求跟踪
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // 申请权限代码 requestAppTrackAuth ;
    __block NSString *idfa = @"";
    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfa = [[manager advertisingIdentifier] UUIDString];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // do something
                [EasyAdSdkConfig shareInstance].level = EasyAdLogLevel_Debug;
//                [EasyAdSdkConfig shareInstance].appId = @"100255";
//                [self loadSplash];
            });
        }];
    }else{
        if ([manager isAdvertisingTrackingEnabled]) {
            idfa = [[manager advertisingIdentifier] UUIDString];
//            [EasyAdSdkConfig shareInstance].appId = @"100255";
//            [self loadSplash];
        }
    }

}

/**
ensure 保证 确保  insurance 保险 保障措施 保险费 surplus 过剩英语过于  evade 逃避 脱逃 规避  elaborate 精心设计 复杂的 efficient 效率高的  efficiency 效率 效能  effective 有效的 生效的 实际的
 exist 存在 生存 existence 存在生活  explore 勘探 探索  examine 调查 仔细检查   exaggrate 夸大  exert 施加 运用 努力  expand 扩大 扩展 expansion 扩涨 发展 prime 首要的 优质的 primary 主要的 首要的 最初的 primitive 原始的 低等的 落后的  priority 优先级  simulate 刺激 激发 鼓励 distinction instinction 本能直觉  dominate dominant 占支配地位 占优势的  demestic 国内的 家庭的  gene 基因 general 普遍的 总的 普通的  generation 生产 一代人 generous
 */

@end
