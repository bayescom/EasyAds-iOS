//
//  EasyAdFullScreenVideo.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/13.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "EasyAdBaseAdapter.h"

#import <UIKit/UIKit.h>

#import "EasyAdSdkConfig.h"
#import "EasyAdFullScreenVideoDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdFullScreenVideo : EasyAdBaseAdapter
/// 广告方法回调代理
@property (nonatomic, weak) id<EasyAdFullScreenVideoDelegate> delegate;

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                 viewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
