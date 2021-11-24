//
//  UnifiedNativeAdCustomView.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTUnifiedNativeAdView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnifiedNativeAdCustomView : GDTUnifiedNativeAdView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIButton *CTAButton;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

- (void)setupWithUnifiedNativeAdObject:(GDTUnifiedNativeAdDataObject *)unifiedNativeDataObject;

@end

NS_ASSUME_NONNULL_END
