//
//  EasyAdError.m
//  Demo
//
//  Created by CherryKing on 2020/11/18.
//

#import "EasyAdError.h"

@interface EasyAdError ()
@property (nonatomic, assign) EasyAdErrorCode code;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) id obj;

@end

@implementation EasyAdError

+ (instancetype)errorWithCode:(EasyAdErrorCode)code {
    return [self errorWithCode:code obj:@""];
}

+ (instancetype)errorWithCode:(EasyAdErrorCode)code obj:(id)obj {
    EasyAdError *advErr = [[EasyAdError alloc] init];
    advErr.code = code;
    advErr.desc = [EasyAdError errorCodeDescMap:code];
    advErr.obj = obj;
    return advErr;
}

- (NSError *)toNSError {
    if (self.obj == nil) { self.obj = @""; }
    if (self.desc == nil) { self.desc = @""; }
    NSError *error = [NSError errorWithDomain:@"com.Advance.Error" code:self.code userInfo:@{
        @"desc": self.desc,
        @"obj": self.obj,
    }];
    return error;
}

+ (NSString *)errorCodeDescMap:(EasyAdErrorCode)code {
    NSDictionary *codeMap = @{
        @(EasyAdErrorCode_101) : @"策略请求失败",
        @(EasyAdErrorCode_102) : @"策略请求返回失败",
        @(EasyAdErrorCode_103) : @"策略请求网络状态码错误",
        @(EasyAdErrorCode_104) : @"策略请求返回内容解析错误",
        @(EasyAdErrorCode_105) : @"策略请求网络状态码错误",
        @(EasyAdErrorCode_110) : @"未设置打底渠道",
        @(EasyAdErrorCode_111) : @"CPT但本地无策略",
        @(EasyAdErrorCode_112) : @"本地有策略但未命中目标渠道",
        @(EasyAdErrorCode_113) : @"本地无策略",
        @(EasyAdErrorCode_114) : @"本地策略都执行失败",
        @(EasyAdErrorCode_115) : @"请求超出设定总时长",
        @(EasyAdErrorCode_116) : @"策略中未配置渠道",
    };
    return [codeMap objectForKey:@(code)];
}

@end
