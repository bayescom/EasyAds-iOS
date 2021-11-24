//
//  UnifiedNativeAdImageCell.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdImageCell.h"

@implementation UnifiedNativeAdImageCell


#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    self.adView.delegate = delegate; // adView 广告回调
    self.adView.viewController = vc; // 跳转 VC
    CGFloat imageRate = 16 / 9;
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    self.adView.backgroundColor = [UIColor grayColor];
    self.adView.iconImageView.frame = CGRectMake(8, 8, 60, 60);
    self.adView.clickButton.frame = CGRectMake(width - 68, 8, 60, 44);
    self.adView.CTAButton.frame = CGRectMake(width - 100, 8, 100, 44);
    self.adView.titleLabel.frame = CGRectMake(76, 8, 250, 30);
    self.adView.descLabel.frame = CGRectMake(8, 76, width, 30);
    CGFloat imageWidth = width;
    self.adView.imageView.frame = CGRectMake(8, 114, imageWidth, imageWidth / imageRate);
    self.adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 122 + imageWidth / imageRate);
    self.adView.logoView.frame = CGRectMake(CGRectGetWidth(self.adView.frame) - kGDTLogoImageViewDefaultWidth, CGRectGetHeight(self.adView.frame) - kGDTLogoImageViewDefaultHeight, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
    [self.adView setupWithUnifiedNativeAdObject:dataObject];
    
    [self.adView registerDataObject:dataObject clickableViews:@[self.adView.clickButton,
                                                                self.adView.iconImageView,
                                                                self.adView.imageView]];
    if ([[dataObject callToAction] length] > 0) {
        [self.adView registerClickableCallToActionView:self.adView.CTAButton];
    }
    
}

+ (CGFloat)cellHeightWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject {
    CGFloat height = 0;
    CGFloat imageRate = 16 / 9;
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    CGFloat imageWidth = width;
    height = 130 + imageWidth / imageRate;
    return height;
}

@end
