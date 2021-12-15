//
//  KsNativeExpressAdapter.h
//  AdvanceSDK
//
//  Created by MS on 2021/4/23.
//

#import "EasyAdBaseAdPosition.h"
#import <Foundation/Foundation.h>
#import "EasyAdNativeExpressDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class EasyAdSupplier;
@class EasyAdNativeExpress;

@interface KsNativeExpressAdapter : EasyAdBaseAdPosition
@property (nonatomic, weak) id<EasyAdNativeExpressDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
