//
//  GdtBannerAdapter.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasyAdBannerDelegate.h"

@class EasyAdSupplier;
@class EasyAdBanner;

NS_ASSUME_NONNULL_BEGIN

@interface GdtBannerAdapter : EasyAdBaseAdPosition

@property (nonatomic, weak) id<EasyAdBannerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
