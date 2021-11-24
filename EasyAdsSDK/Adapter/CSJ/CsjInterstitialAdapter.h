//
//  CsjInterstitialAdapter.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasyAdInterstitialDelegate.h"

@class EasyAdSupplier;
@class EasyAdInterstitial;

NS_ASSUME_NONNULL_BEGIN

@interface CsjInterstitialAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdInterstitialDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
