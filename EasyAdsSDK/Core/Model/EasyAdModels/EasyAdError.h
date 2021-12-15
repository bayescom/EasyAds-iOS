//
//  EasyAdError.h
//  Demo
//
//  Created by CherryKing on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 策略相关
typedef NS_ENUM(NSUInteger, EasyAdErrorCode) {
    EasyAdErrorCode_101    =    101,
    EasyAdErrorCode_102    =    102,
    EasyAdErrorCode_103    =    103,
    EasyAdErrorCode_104    =    104,
    EasyAdErrorCode_105    =    105,
    EasyAdErrorCode_110    =    110,
    EasyAdErrorCode_111    =    111,
    EasyAdErrorCode_112    =    112,
    EasyAdErrorCode_113    =    113,
    EasyAdErrorCode_114    =    114,
    EasyAdErrorCode_115    =    115,
    EasyAdErrorCode_116    =    116
};

@interface EasyAdError : NSObject

+ (instancetype)errorWithCode:(EasyAdErrorCode)code;

+ (instancetype)errorWithCode:(EasyAdErrorCode)code obj:(id)obj;

- (NSError *)toNSError;

@end

NS_ASSUME_NONNULL_END
