//
//  BdNativeExpressAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/5/31.
//
#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import "EasyAdNativeExpressDelegate.h"

@class EasyAdSupplier;
@class EasyAdNativeExpress;


NS_ASSUME_NONNULL_BEGIN

@interface BdNativeExpressAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdNativeExpressDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
