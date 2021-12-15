//
//  BayesUtils.h
//  advancelib
//
//  Created by allen on 2019/9/18.
//  Copyright © 2019 Bayescom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoUtils : NSObject
+ (void)showToast:(NSString *)text;
+ (void)showToast:(NSString *)text inView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END
