//
//  UnifiedNativeAdThreeImageCell.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdThreeImageCell.h"
#import "UnifiedNativeAdCustomView.h"

@interface UnifiedNativeAdThreeImageCell()

@end

@implementation UnifiedNativeAdThreeImageCell


#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    CGFloat imageRate = 228 / 150.0; // 三小图默认比例
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    self.adView.backgroundColor = [UIColor grayColor];
    self.adView.clickButton.frame = CGRectMake(width - 68, 8, 60, 44);
    self.adView.titleLabel.frame = CGRectMake(8, 8, 250, 30);
    self.adView.descLabel.frame = CGRectMake(8, 46, width, 30);
    CGFloat imageWidth = (width - 16) / 3;
    self.adView.leftImageView.frame = CGRectMake(8, 84, imageWidth, imageWidth / imageRate);
    self.adView.midImageView.frame = CGRectMake(16 + imageWidth, 84, imageWidth, imageWidth / imageRate);
    self.adView.rightImageView.frame = CGRectMake(24 + imageWidth * 2, 84, imageWidth, imageWidth / imageRate);
    self.adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 92 + imageWidth / imageRate);
    self.adView.logoView.frame = CGRectMake(CGRectGetWidth(self.adView.frame) - kGDTLogoImageViewDefaultWidth, CGRectGetHeight(self.adView.frame) - kGDTLogoImageViewDefaultHeight, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
    self.adView.viewController = vc;
    self.adView.delegate = delegate;
    [self.adView setupWithUnifiedNativeAdObject:dataObject];
    [self.adView registerDataObject:dataObject clickableViews:@[self.adView.clickButton,
                                                                self.adView.leftImageView,
                                                                self.adView.midImageView,
                                                                self.adView.rightImageView]];
}

+ (CGFloat)cellHeightWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
{
    CGFloat height = 0;
    CGFloat imageRate = 228 / 150.0; // 三小图默认比例
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    CGFloat imageWidth = (width - 16) / 3;
    height = 92 + imageWidth / imageRate;
    return height;
}

@end
