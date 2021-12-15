//
//  EasyAdSplash.h
//  Demo
//
//  Created by CherryKing on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasyAdBaseAdapter.h"
#import "EasyAdSdkConfig.h"
#import "EasyAdSplashDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EasyAdSplash : EasyAdBaseAdapter

/// 广告方法回调代理
@property (nonatomic, weak) id<EasyAdSplashDelegate> delegate;

/// 是否必须展示Logo 默认: NO 注意: 强制展示Logo可能会影响收益 !!!
@property (nonatomic, assign) BOOL showLogoRequire;

/// 广告Logo
@property(nonatomic, strong) UIImage *logoImage;

/// 广告未加载出来时的占位图
@property(nonatomic, strong) UIImage *backgroundImage;

/// 总超时时间
@property (nonatomic, assign) NSInteger timeout;


- (instancetype)initWithJsonDic:(NSDictionary *_Nonnull)jsonDic
                 viewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
