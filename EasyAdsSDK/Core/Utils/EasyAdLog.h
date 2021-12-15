//
//  EasyAdLog.h
//  Example
//
//  Created by CherryKing on 2019/11/5.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyAdSdkConfig.h"

@class EasyAdLog;



#define EAD_LEVEL_FATAL_LOG(format,...)  [EasyAdLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__] level:EasyAdLogLevel_Fatal]

#define EAD_LEVEL_ERROR_LOG(format,...)  [EasyAdLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__] level:EasyAdLogLevel_Error]

#define EAD_LEVEL_WARING_LOG(format,...)  [EasyAdLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__] level:EasyAdLogLevel_Warning]

#define EAD_LEVEL_INFO_LOG(format,...)  [EasyAdLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__] level:EasyAdLogLevel_Info]

#define EAD_LEVEL_DEBUG_LOG(format,...)  [EasyAdLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__] level:EasyAdLogLevel_Debug]


#define EasyAdLog(format,...)  [EasyAdLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__]]
#define EasyAdLogJSONData(data)  [EasyAdLog logJsonData:data]

NS_ASSUME_NONNULL_BEGIN


@interface EasyAdLog : NSObject

// 日志输出方法
+ (void)customLogWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString level:(EasyAdLogLevel)level;

+ (void)customLogWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString;

// 记录data类型数据
+ (void)logJsonData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
