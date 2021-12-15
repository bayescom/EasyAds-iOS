//
//  BYNativeAdCustomView.h
//  Example
//
//  Created by CherryKing on 2019/12/26.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import <MercurySDK/MercurySDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYNativeAdCustomView : MercuryNativeAdView
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UIImageView *iconImgV;
@property (nonatomic, strong) UIImageView *contentImgV;
@property (nonatomic, strong) UILabel *sourceLbl;

- (void)registerNativeAd:(MercuryNativeAd *)nativeAd
              dataObject:(MercuryNativeAdDataModel *)model;

@end

NS_ASSUME_NONNULL_END
