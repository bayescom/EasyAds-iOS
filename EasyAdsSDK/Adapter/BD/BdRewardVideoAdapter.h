//
//  BdRewardVideoAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/5/27.
//

#import <Foundation/Foundation.h>
#import "EasyAdRewardVideoDelegate.h"
#import "EasyAdBaseAdPosition.h"

@class EasyAdSupplier;
@class EasyAdRewardVideo;

NS_ASSUME_NONNULL_BEGIN

@interface BdRewardVideoAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdRewardVideoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
