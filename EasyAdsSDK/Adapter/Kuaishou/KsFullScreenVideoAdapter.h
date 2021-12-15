//
//  KsFullScreenVideoAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/4/23.
//

#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import "EasyAdFullScreenVideoDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@class EasyAdSupplier;
@class EasyAdFullScreenVideo;

@interface KsFullScreenVideoAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdFullScreenVideoDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
