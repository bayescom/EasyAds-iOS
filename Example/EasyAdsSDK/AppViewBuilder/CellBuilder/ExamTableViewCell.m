//
//  ExamTableViewCell01.m
//  Example
//
//  Created by CherryKing on 2019/12/11.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "ExamTableViewCell.h"
#import "BYExamCellModel.h"
#import "CellBuilder.h"

#define GlobleHeight [UIScreen mainScreen].bounds.size.height
#define GlobleWidth [UIScreen mainScreen].bounds.size.width
#define imgBgColor [UIColor colorWithRed:0.81 green:0.81 blue:0.82 alpha:1.00]
#define edge 15

@interface ExamTableViewCell ()
@property (nonatomic, strong, nullable) UIView *separatorLine;
@property (nonatomic, strong, nullable) UILabel *titleLabel;
@property (nonatomic, strong, nullable) UILabel *inconLable;
@property (nonatomic, strong, nullable) UILabel *sourceLable;
@property (nonatomic, strong, nullable) UIImageView *closeIncon;
@property (nonatomic, strong, nullable) UIImageView *img;
@property (nonatomic, strong, nullable) UIImageView *bigImg;
@property (nonatomic, strong, nullable) UIImageView *img1;
@property (nonatomic, strong, nullable) UIImageView *img2;
@property (nonatomic, strong, nullable) UIImageView *img3;

@end

@implementation ExamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildupView];
    }
    return self;
}

- (void)buildupView {
    _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(edge, 0, GlobleWidth-edge*2, 0.5)];
    _separatorLine.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.94 alpha:1.00];
    [self.contentView addSubview:_separatorLine];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    _sourceLable = [[UILabel alloc] init];
    _sourceLable.font = [UIFont systemFontOfSize:12];
    _sourceLable.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLable];
    
    _inconLable = [[UILabel alloc] init];
    _inconLable.font = [UIFont systemFontOfSize:10];
    _inconLable.textColor = [UIColor redColor];
    _inconLable.textAlignment = NSTextAlignmentCenter;
    _inconLable.clipsToBounds = YES;
    _inconLable.layer.cornerRadius = 3;
    _inconLable.layer.borderWidth = 0.5;
    _inconLable.layer.borderColor = [UIColor redColor].CGColor;
    [self.contentView addSubview:_inconLable];
    
    _closeIncon = [[UIImageView alloc] init];
    [_closeIncon setImage:[UIImage imageNamed:@"feedClose.png"]];
    [self.contentView addSubview:_closeIncon];
}

- (void)setItem:(BYExamCellModelElement *)item {
    _item = item;
    
    _titleLabel.attributedText = [CellBuilder titleAttributeText:item.title];
    _sourceLable.attributedText = [CellBuilder subtitleAttributeText:_item.ctime];
    _inconLable.text = _item.tag;
    
    _inconLable.frame = CGRectMake(edge, _item.cellh - 12 - edge, 27, 14);
    if (_item.tag && _item.tag.length!=0) {
        _inconLable.hidden = NO;
        _sourceLable.frame = CGRectMake(self.inconLable.frame.origin.x+self.inconLable.frame.size.width + edge, self.inconLable.frame.origin.y+1, 200, 12);
    } else{
        _inconLable.hidden = YES;
        _sourceLable.frame = CGRectMake(edge, self.inconLable.frame.origin.y, 200, 12);
    }
    _closeIncon.frame = CGRectMake(GlobleWidth - 10 - edge, _item.cellh - 10 - edge, 10, 10);
    
    [self.img removeFromSuperview];
    [self.bigImg removeFromSuperview];
    [self.img1 removeFromSuperview];
    [self.img2 removeFromSuperview];
    [self.img3 removeFromSuperview];
    
    if (_item.showtype == 1) {
        self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
    } else if (_item.showtype == 2) {
        self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
        self.bigImg = [[UIImageView alloc] initWithFrame:CGRectMake(edge, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, GlobleWidth-edge*2, (GlobleWidth-edge*2)*0.6)];
        self.bigImg.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1.00];
        [self.contentView addSubview:self.bigImg];
    } else if (_item.showtype == 3) {
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(GlobleWidth-edge-120, edge, 120, 80)];
        self.img.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1.00];
        [self.contentView addSubview:self.img];
        self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-120-edge*3, 50);
    } else if (_item.showtype == 4) {
        self.titleLabel.frame = CGRectMake(edge, edge, GlobleWidth-edge*2, 50);
        
        self.img1 = [[UIImageView alloc] initWithFrame:CGRectMake(edge, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80)];
        self.img1.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1.00];
        [self.contentView addSubview:self.img1];
        
        self.img2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.img1.frame.size.width+self.img1.frame.origin.x + 5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80)];
        self.img2.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1.00];
        [self.contentView addSubview:self.img2];
        
        self.img3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.img2.frame.size.width+self.img2.frame.origin.x + 5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + edge, (GlobleWidth - edge*2-5-5)/3, 80)];
        self.img3.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1.00];
        [self.contentView addSubview:self.img3];
    }
}

@end
