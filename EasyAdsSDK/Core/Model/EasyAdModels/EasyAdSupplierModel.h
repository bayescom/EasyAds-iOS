//
//  EasyAdSupplierModel.h
//  Demo
//
//  Created by CherryKing on 2020/11/18.
//

#import <Foundation/Foundation.h>

@class EasyAdSupplierModel;
@class EasyAdSetting;
@class EasyAdSupplier;
typedef NS_ENUM(NSUInteger, EasyAdSdkSupplierRepoType) {
    /// 点击
    EasyAdSdkSupplierRepoClicked,
    /// 数据拉取成功
    EasyAdSdkSupplierRepoSucceeded,
    /// 广告物料加载成功
    EasyAdSdkSupplierRepoLoaded,
    /// 曝光
    EasyAdSdkSupplierRepoImped,
    /// 失败
    EasyAdSdkSupplierRepoFaileded,
};

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface EasyAdSupplierModel : NSObject
@property (nonatomic, strong) NSMutableArray<EasyAdSetting *> *rules;
@property (nonatomic, strong) NSMutableArray<EasyAdSupplier *> *suppliers;
@property (nonatomic, copy)   NSString *sortTag;

@end

@interface EasyAdSetting : NSObject
@property (nonatomic, strong) NSMutableArray<NSNumber *> *sort;
@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, copy)   NSString *tag;



@end

@interface EasyAdSupplier : NSObject
@property (nonatomic, copy)   NSString *appId;
@property (nonatomic, copy)   NSString *adspotId;
@property (nonatomic, copy)   NSString *tag;
@property (nonatomic, strong)   NSNumber *index;

@end

NS_ASSUME_NONNULL_END
