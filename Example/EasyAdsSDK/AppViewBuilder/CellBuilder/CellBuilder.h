//
//  CellBuilder.h
//  Example
//
//  Created by CherryKing on 2019/12/11.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamTableViewCell.h"

@class BYExamCellModelElement;

NS_ASSUME_NONNULL_BEGIN

@interface CellBuilder : NSObject
+ (NSArray<BYExamCellModelElement *> *)dataFromJsonFile:(NSString *)jFileName;

// Style Builder
+ (NSAttributedString *)titleAttributeText:(NSString *)text;

+ (NSAttributedString *)subtitleAttributeText:(NSString *)text;

+ (NSAttributedString *)infoAttributeText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
