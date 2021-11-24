//
//  GDTFullScreenVideoProAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/4/29.
//
#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import "EasyAdFullScreenVideoDelegate.h"

@class EasyAdSupplier;
@class EasyAdFullScreenVideo;

NS_ASSUME_NONNULL_BEGIN

@interface GDTFullScreenVideoProAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdFullScreenVideoDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
