//
//  UIWindow+Adv.m
//  BayesSDK
//
//  Created by CherryKing on 2020/1/9.
//  Copyright © 2020 BAYESCOM. All rights reserved.
//

#import "UIApplication+EasyAds.h"

@implementation UIApplication (Adv)

- (UIWindow *)easyAd_getCurrentWindow {
    UIWindow *window = nil;
    // 先判断系统
    if (@available(iOS 13, *)) {
        // 判断设备
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            // iPhone设备直接取windows第一个元素
            for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
                if (a_w.isKeyWindow) {
                    window = a_w;
                }
            }
            // 没有keywindow 直接取第一个
            if (!window) { window = [UIApplication sharedApplication].windows.firstObject; }
            if (!window) {   // 如果window还是不存在
                // 检测是否未支持iOS 13新特性，未采用兼容方案，看AppDelegate中是否有window
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                    window = [UIApplication sharedApplication].delegate.window;
                }
            }
        } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            // ipad设备获取keywindow
            for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
                if (a_w.isKeyWindow) {
                    window = a_w;
                }
            }
            if (!window) {  // 如果也没取到keyWindow，拿第一个Window
                window = [UIApplication sharedApplication].windows.firstObject;
            }
        }
    } else {
        window = UIApplication.sharedApplication.keyWindow;
    }
    return window;
}

@end
