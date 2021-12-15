//
//  KsInterstitialAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "EasyAdInterstitialDelegate.h"
#import "EasyAdBaseAdPosition.h"

NS_ASSUME_NONNULL_BEGIN
@class EasyAdSupplier;
@class EasyAdInterstitial;

@interface KsInterstitialAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdInterstitialDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
