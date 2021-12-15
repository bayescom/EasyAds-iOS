//
//  EasyAdSupplierDelegate.h
//  Demo
//
//  Created by CherryKing on 2020/11/25.
//

#ifndef EasyAdSupplierDelegate_h
#define EasyAdSupplierDelegate_h

@class EasyAdSupplierModel;
@class EasyAdSupplier;
@protocol EasyAdSupplierDelegate <NSObject>

@optional

/// 加载策略Model成功
- (void)easyAdBaseAdapterLoadSuccess:(nonnull EasyAdSupplierModel *)model;

/// 加载策略Model失败
- (void)easyAdBaseAdapterLoadError:(nullable NSError *)error;

/// 加载的 sortTag
- (void)easyAdBaseAdapterLoadSortTag:(NSString *)sortTag;

- (void)easyAdBaseAdapterLoadAndShow;


/// 返回下一个渠道的参数
/// @param supplier 被加载的渠道
/// @param error 异常信息
- (void)easyAdBaseAdapterLoadSuppluer:(nullable EasyAdSupplier *)supplier error:(nullable NSError *)error;
@end

#endif /* EasyAdSupplierDelegate_h */
