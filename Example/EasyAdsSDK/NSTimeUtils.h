//
//  NSTimeUtils.h
//  EasyAdsSDKExample
//
//  Created by CherryKing on 2020/3/16.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimeUtils : NSObject
+ (instancetype)shareInstance;
/// 记录此时的时间
- (void)beginTimeTag;
/// 结束时间
- (void)endTimeTag;
/// 得出结束和开始时间的时间差(单位:ms)
- (void)endTimeWithMillisecond:(char[_Nullable])info;

@end

NS_ASSUME_NONNULL_END
