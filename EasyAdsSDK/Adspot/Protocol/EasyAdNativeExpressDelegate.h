//
//  EasyAdNativeExpressProtocol.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#ifndef EasyAdNativeExpressProtocol_h
#define EasyAdNativeExpressProtocol_h
#import "EasyAdCommonDelegate.h"
@class EasyAdNativeExpressView;
@protocol EasyAdNativeExpressDelegate <EasyAdCommonDelegate>
@optional
/// 广告数据拉取成功
- (void)easyAdNativeExpressOnAdLoadSuccess:(nullable NSArray<EasyAdNativeExpressView *> *)views;

/// 广告曝光
- (void)easyAdNativeExpressOnAdShow:(nullable EasyAdNativeExpressView *)adView;

/// 广告点击
- (void)easyAdNativeExpressOnAdClicked:(nullable EasyAdNativeExpressView *)adView;

/// 广告渲染成功
- (void)easyAdNativeExpressOnAdRenderSuccess:(nullable EasyAdNativeExpressView *)adView;

/// 广告渲染失败
- (void)easyAdNativeExpressOnAdRenderFail:(nullable EasyAdNativeExpressView *)adView;

/// 广告被关闭 (注: 百度广告(百青藤), 不支持该回调, 若使用百青藤,则该回到功能请自行实现)
- (void)easyAdNativeExpressOnAdClosed:(nullable EasyAdNativeExpressView *)adView;

@end

#endif
