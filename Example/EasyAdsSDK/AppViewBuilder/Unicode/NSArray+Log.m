//
//  NSArray+Log.m
//  EasyAdsSDK_Example
//
//  Created by MS on 2021/11/17.
//  Copyright © 2021 Cheng455153666. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

// 只需要在分类中,重写这个方法的实现,不需要导入分类文件就会生效
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    // 定义用于拼接字符串的容器
    NSMutableString *stringM = [NSMutableString string];
    
    // 拼接开头
    [stringM appendString:@"(\n"];
    
    // 拼接中间的数组元素
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [stringM appendFormat:@"\t%@,\n",obj];
        
    }];
    
    // 拼接结尾
    [stringM appendString:@")\n"];
    
    return stringM;
}

@end

@implementation NSDictionary (Log)

// 只需要在分类中,重写这个方法的实现,不需要导入分类文件就会生效
- (NSString *)descriptionWithLocale:(id)locale
{
    // 定义用于拼接字符串的容器
    NSMutableString *stringM = [NSMutableString string];
    
    // 拼接开头
    [stringM appendString:@"{\n"];
    
    // 遍历字典,拼接内容
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringM appendFormat:@"\t%@ = %@;\n",key,obj];
    }];
    
    // 拼接结尾
    [stringM appendString:@"}\n"];
    
    return stringM;
}

@end
