//
//  ExamTableViewCell01.h
//  Example
//
//  Created by CherryKing on 2019/12/11.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYExamCellModelElement;
NS_ASSUME_NONNULL_BEGIN

@interface ExamTableViewCell : UITableViewCell
@property (nonatomic, strong) BYExamCellModelElement *item;

@end

NS_ASSUME_NONNULL_END
