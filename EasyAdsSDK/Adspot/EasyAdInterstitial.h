//
//  EasyAdInterstitial.h
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/7.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "EasyAdBaseAdapter.h"

#import <UIKit/UIKit.h>

#import "EasyAdSdkConfig.h"
#import "EasyAdInterstitialDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdInterstitial : EasyAdBaseAdapter
/// 广告方法回调代理
@property (nonatomic, weak) id<EasyAdInterstitialDelegate> delegate;

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                 viewController:(UIViewController *)viewController;



@end

NS_ASSUME_NONNULL_END
