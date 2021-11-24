//
//  ViewBuilder.h
//  Example
//
//  Created by CherryKing on 2019/12/20.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DemoUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewBuilder : NSObject

+ (UIView *)buildView;

+ (UILabel *)buildLbl01;

+ (UITextField *)buildTxt01;

+ (UITableView *)buildTableView;

@end

NS_ASSUME_NONNULL_END
