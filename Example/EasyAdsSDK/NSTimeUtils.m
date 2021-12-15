//
//  NSTimeUtils.m
//  EasyAdsSDKExample
//
//  Created by CherryKing on 2020/3/16.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "NSTimeUtils.h"

@interface NSTimeUtils ()
@property (nonatomic, assign) double timeBegTag;
@property (nonatomic, assign) double timeEndTag;

@property (nonatomic, assign) int count;

@end

@implementation NSTimeUtils
static NSTimeUtils *instance;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [NSTimeUtils shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [NSTimeUtils shareInstance];
}

- (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return [NSTimeUtils shareInstance];
}


/// 记录此时的时间
- (void)beginTimeTag {
    _timeBegTag = CFAbsoluteTimeGetCurrent();
}

/// 结束时间
- (void)endTimeTag {
    _timeEndTag = CFAbsoluteTimeGetCurrent();
}
/// 得出结束和开始时间的时间差(单位:ms)
- (void)endTimeWithMillisecond:(char[_Nullable])info {
    _timeEndTag = CFAbsoluteTimeGetCurrent();
}

@end
