//
//  CellBuilder.m
//  Example
//
//  Created by CherryKing on 2019/12/11.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "CellBuilder.h"
#import "BYExamCellModel.h"

@implementation CellBuilder

+ (NSArray<BYExamCellModelElement *> *)dataFromJsonFile:(NSString *)jFileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:jFileName ofType:@"json"];
    NSError *e = nil;
    return [BYExamCellModelFromData([[NSData alloc] initWithContentsOfFile:path], &e) copy];
}

+ (NSAttributedString *)titleAttributeText:(NSString *)text {
    if (text == nil) {
        return nil;
    }
    NSMutableDictionary *attribute = @{}.mutableCopy;
    NSMutableParagraphStyle * titleStrStyle = [[NSMutableParagraphStyle alloc] init];
    titleStrStyle.lineSpacing = 5;
    titleStrStyle.alignment = NSTextAlignmentJustified;
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:17.f];
    attribute[NSParagraphStyleAttributeName] = titleStrStyle;
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

+ (NSAttributedString *)subtitleAttributeText:(NSString *)text {
    if (text == nil) {
        return nil;
    }
    NSMutableDictionary *attribute = @{}.mutableCopy;
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:12.f];
    attribute[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

+ (NSAttributedString *)infoAttributeText:(NSString *)text {
    if (text == nil) {
        return nil;
    }
    NSMutableDictionary *attribute = @{}.mutableCopy;
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:12.f];
    attribute[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end
