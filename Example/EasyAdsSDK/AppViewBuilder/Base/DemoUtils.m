//
//  BayesUtils.m
//  advancelib
//
//  Created by allen on 2019/9/18.
//  Copyright © 2019 Bayescom. All rights reserved.
//


#import "DemoUtils.h"

@implementation DemoUtils

+ (void)showToast:(NSString *)text {
    [DemoUtils showToast:text inView:[UIApplication sharedApplication].windows.lastObject];
}

+ (void)showToast:(NSString *)text inView:(UIView *)superView {
    if (!superView) {
        return;
    }
    CGSize labelSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f]}];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18.f];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = labelSize.height/4;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:38/255.f green:187/255.f blue:251/255.f alpha:1.f];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake((superView.bounds.size.width - labelSize.width)/2, (superView.bounds.size.height-labelSize.height-100), labelSize.width, labelSize.height);
    [superView addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}
@end
