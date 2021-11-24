//
//  BdSplashAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/5/24.
//

#import <Foundation/Foundation.h>
#import "EasyAdSplashDelegate.h"
#import "EasyAdBaseAdPosition.h"
@class EasyAdSupplier;
@class EasyAdSplash;

NS_ASSUME_NONNULL_BEGIN

@interface BdSplashAdapter : EasyAdBaseAdPosition

@property (nonatomic, weak) id<EasyAdSplashDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
