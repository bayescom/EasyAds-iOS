//
//  ViewBuilder.m
//  Example
//
//  Created by CherryKing on 2019/12/20.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "ViewBuilder.h"

@implementation ViewBuilder

+ (UIView *)buildView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    v.backgroundColor = [self randomColor];
    return v;
}

+ (UILabel *)buildLbl01 {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.textColor = [UIColor colorWithRed:0.16 green:0.17 blue:0.21 alpha:1.00];
    lbl.font = [UIFont systemFontOfSize:14];
    return lbl;
}

+ (UITextField *)buildTxt01 {
    UITextField *txtF = [[UITextField alloc] initWithFrame:CGRectZero];
    txtF.borderStyle = UITextBorderStyleRoundedRect;
    return txtF;
}

+ (UITableView *)buildTableView {
    UITableView *tbv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tbv.tableFooterView = [UIView new];
    return tbv;
}

+ (UIColor *)randomColor {
    CGFloat hue = (arc4random() %256/256.0);
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    UIColor*color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end
