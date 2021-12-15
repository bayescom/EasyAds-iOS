//
//  UnifiedNativeAdBaseTableViewCell.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTUnifiedNativeAd.h"
#import "UnifiedNativeAdCustomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnifiedNativeAdBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UnifiedNativeAdCustomView *adView;

- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id <GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc;
+ (CGFloat)cellHeightWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject;

@end

NS_ASSUME_NONNULL_END
