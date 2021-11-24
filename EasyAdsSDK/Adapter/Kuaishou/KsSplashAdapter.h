//
//  KsSplashAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/4/20.
//
#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasyAdSplashDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@class EasyAdSupplier;
@class EasyAdSplash;

@interface KsSplashAdapter : EasyAdBaseAdPosition

@property (nonatomic, weak) id<EasyAdSplashDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
