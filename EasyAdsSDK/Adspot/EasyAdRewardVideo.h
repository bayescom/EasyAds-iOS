//
//  EasyAdRewardVideo.h
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/7.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "EasyAdBaseAdapter.h"

#import <UIKit/UIKit.h>

#import "EasyAdSdkConfig.h"
#import "EasyAdRewardVideoDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdRewardVideo : EasyAdBaseAdapter
/// 广告方法回调代理
@property (nonatomic, weak) id<EasyAdRewardVideoDelegate> delegate;

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                 viewController:(nonnull UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
