//
//  EasyAdNativeExpress.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/13.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "EasyAdBaseAdapter.h"

#import <UIKit/UIKit.h>

#import "EasyAdSdkConfig.h"
#import "EasyAdNativeExpressDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdNativeExpress : EasyAdBaseAdapter
/// 广告方法回调代理
@property (nonatomic, weak) id<EasyAdNativeExpressDelegate> delegate;
@property (nonatomic, assign) CGSize adSize;

/// 构造函数
/// @param jsonDic 数据
/// @param viewController viewController
/// @param size 尺寸
- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                 viewController:(UIViewController *)viewController
                         adSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
