//
//  KsRewardVideoAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/4/23.
//

#import <Foundation/Foundation.h>
#import "EasyAdRewardVideoDelegate.h"
#import "EasyAdBaseAdPosition.h"
NS_ASSUME_NONNULL_BEGIN
@class EasyAdSupplier;
@class EasyAdRewardVideo;

@interface KsRewardVideoAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdRewardVideoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
