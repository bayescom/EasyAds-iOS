//
//  UnifiedNativeAdBaseTableViewCell.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdBaseTableViewCell.h"

@interface UnifiedNativeAdBaseTableViewCell()

@end

@implementation UnifiedNativeAdBaseTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adView = [[UnifiedNativeAdCustomView alloc] init];
        [self addSubview:self.adView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adView = [[UnifiedNativeAdCustomView alloc] init];
        [self addSubview:self.adView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.adView unregisterDataObject]; // unregister 必须执行，为了 cell 复用。
    self.adView.titleLabel.text = @"";
    self.adView.titleLabel.accessibilityIdentifier = @"title_id";
    self.adView.descLabel.text = @"";
    self.adView.descLabel.accessibilityIdentifier = @"descLabel_id";
    self.adView.imageView.image = nil;
    self.adView.imageView.accessibilityIdentifier = @"imageView_id";
    self.adView.iconImageView.image = nil;
    self.adView.iconImageView.accessibilityIdentifier = @"iconImageView_id";
    self.adView.leftImageView.image = nil;
    self.adView.leftImageView.accessibilityIdentifier = @"leftImageView_id";
    self.adView.midImageView.image = nil;
    self.adView.midImageView.accessibilityIdentifier = @"midImageView_id";
    self.adView.rightImageView.image = nil;
    self.adView.rightImageView.accessibilityIdentifier = @"rightImageView_id";
}


#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    
}

+ (CGFloat)cellHeightWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
{
    return 0;
}

@end
