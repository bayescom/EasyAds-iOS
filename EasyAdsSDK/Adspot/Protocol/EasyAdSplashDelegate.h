//
//  EasyAdSplashProtocol.h
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/8.
//  Copyright © 2020 Mercury. All rights reserved.
//

#ifndef EasyAdSplashProtocol_h
#define EasyAdSplashProtocol_h
#import "EasyAdBaseDelegate.h"
@protocol EasyAdSplashDelegate <EasyAdBaseDelegate>
@optional
/// 广告点击跳过
#pragma 百度广告不支持该回调
- (void)easyAdSplashOnAdSkipClicked;

/// 广告倒计时结束回调 百度广告不支持该回调
#pragma 百度广告不支持该回调
- (void)easyAdSplashOnAdCountdownToZero;


@end

#endif 
