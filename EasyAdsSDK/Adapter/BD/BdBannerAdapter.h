//
//  BdBannerAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/5/28.
//
#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import "EasyAdBannerDelegate.h"

@class EasyAdSupplier;
@class EasyAdBanner;

NS_ASSUME_NONNULL_BEGIN

@interface BdBannerAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdBannerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
