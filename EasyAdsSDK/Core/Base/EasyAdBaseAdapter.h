//
//  EasyAdBaseAdapter.h
//  Demo
//
//  Created by CherryKing on 2020/11/20.
//

#import <Foundation/Foundation.h>
#import "EasyAdSupplierModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdBaseAdapter : NSObject

/// 各渠道错误的详细原因
@property (nonatomic, strong) NSMutableDictionary * errorDescriptions;

/// 控制器(在一次广告周期中 不可更改, 不然会引起未知错误)
@property(nonatomic, weak) UIViewController *viewController;

/// 初始化方法
/// @param jsonDic  策略广告的策略信息 json格式请参考 DataJson目录下的.json文件
- (instancetype)initWithJsonDic:(NSDictionary *_Nonnull)jsonDic;


/// 加载广告
- (void)loadAd;

/// 展示广告
- (void)showAd;

/// 加载并展现
- (void)loadAndShowAd;


/**
 * 加载下个渠道
 */
- (void)loadNextSupplierIfHas;


/// 上报
- (void)reportWithType:(EasyAdSdkSupplierRepoType)repoType supplier:(EasyAdSupplier *)supplier error:(NSError *)error;


/// 取消当前策略请求
- (void)deallocAdapter;

@end

NS_ASSUME_NONNULL_END
