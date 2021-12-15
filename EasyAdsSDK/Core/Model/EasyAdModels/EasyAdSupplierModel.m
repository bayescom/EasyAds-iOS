//
//  EasyAdSupplierModel.m
//  Demo
//
//  Created by CherryKing on 2020/11/18.
//

#import "EasyAdSupplierModel.h"

NS_ASSUME_NONNULL_BEGIN



@implementation EasyAdSupplierModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"suppliers" : [EasyAdSupplier class],
             @"rules" : [EasyAdSetting class]
    };
}


@end

@implementation EasyAdSetting

@end


@implementation EasyAdSupplier


@end

NS_ASSUME_NONNULL_END
