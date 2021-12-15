//
//  TestCustomFeedTableViewCell.h
//  Example
//
//  Created by CherryKing on 2019/12/25.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYNativeAdCustomView.h"

@class MercuryNativeAdDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface TestCustomFeedTableViewCell : UITableViewCell

@property (nonatomic, strong) BYNativeAdCustomView *adView;
- (void)registerNativeAd:(MercuryNativeAd *)nativeAd
              dataObject:(MercuryNativeAdDataModel *)model;

+ (CGFloat)cellHeightWithModel:(MercuryNativeAdDataModel *)model;

@end

NS_ASSUME_NONNULL_END
