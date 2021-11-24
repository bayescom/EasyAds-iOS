//
//  GdtInterstitialAdapter.h
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

@interface GdtInterstitialAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdInterstitialDelegate> delegate;
//@property (nonatomic, assign) NSInteger tag;// 标记并行渠道为了找到响应的adapter

//- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(EasyAdInterstitial *)adspot;

//- (void)loadAd;
//
//- (void)showAd;

@end

NS_ASSUME_NONNULL_END
