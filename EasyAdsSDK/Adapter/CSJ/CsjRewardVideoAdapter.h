//
//  CsjRewardVideoAdapter.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasyAdRewardVideoDelegate.h"

@class EasyAdSupplier;
@class EasyAdRewardVideo;

NS_ASSUME_NONNULL_BEGIN

@interface CsjRewardVideoAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdRewardVideoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
