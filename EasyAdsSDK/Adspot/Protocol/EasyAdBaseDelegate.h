//
//  EasyAdBaseDelegate.h
//  Pods
//
//  Created by MS on 2020/12/9.
//

#ifndef EasyAdBaseDelegate_h
#define EasyAdBaseDelegate_h
#import "EasyAdCommonDelegate.h"
// 策略相关的代理
@protocol EasyAdBaseDelegate <EasyAdCommonDelegate>

@optional

/// 广告曝光成功
- (void)easyAdExposured;

/// 广告点击回调
- (void)easyAdClicked;

/// 广告数据请求成功后调用
- (void)easyAdUnifiedViewDidLoad;

/// 广告关闭的回调
- (void)easyAdDidClose;

@end

#endif /* EasyAdBaseDelegate_h */
