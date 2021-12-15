//
//  EasyAdBanner.h
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/7.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "EasyAdBaseAdapter.h"
#import "EasyAdSdkConfig.h"
#import "EasyAdBannerDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdBanner : EasyAdBaseAdapter
/// 广告方法回调代理
@property (nonatomic, weak) id<EasyAdBannerDelegate> delegate;

@property(nonatomic, weak) UIView *adContainer;

@property(nonatomic, assign) int refreshInterval;

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                    adContainer:(UIView *)adContainer
                 viewController:(nonnull UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
