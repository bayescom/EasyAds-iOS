//
//  EasyAdSupplierManager.h
//  Demo
//
//  Created by CherryKing on 2020/11/18.
//

#import <Foundation/Foundation.h>
#import "EasyAdSupplierModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EasyAdSupplierManagerDelegate <NSObject>

// MARK: ======================= 策略回调 =======================

/// 加载策略Model成功
- (void)EasyAdSupplierManagerLoadSuccess:(EasyAdSupplierModel *)model;

/// 加载策略Model失败
- (void)EasyAdSupplierManagerLoadError:(NSError *)error;

/// 返回下一个渠道的参数
- (void)EasyAdSupplierLoadSuppluer:(nullable EasyAdSupplier *)supplier error:(nullable NSError *)error;

/// 被选中的选择的sort标志
- (void)EasyAdSupplierManagerLoadSortTag:(NSString *)tag;

@end

@interface EasyAdSupplierManager : NSObject

/// 数据加载回调
@property (nonatomic, weak) id<EasyAdSupplierManagerDelegate> delegate;

/// 数据管理对象
+ (instancetype)manager;

- (void)loadDataWithJsonDic:(NSDictionary *)jsonDic;
/**
 * 加载下个渠道
 * 回调 EasyAdSupplierLoadSuppluer: error:
 */
- (void)loadNextSupplierIfHas;


@end

NS_ASSUME_NONNULL_END
