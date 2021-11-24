//
//  EasyAdBanner.m
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/7.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "EasyAdBanner.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EasyAdLog.h"

@interface EasyAdBanner ()
@property (nonatomic, strong) id adapter;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIViewController *controller;

@end

@implementation EasyAdBanner

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                    adContainer:(UIView *)adContainer
                 viewController:(nonnull UIViewController *)viewController {
    if (self = [super initWithJsonDic:jsonDic]) {
        _adContainer = adContainer;
        self.viewController = viewController;
        _refreshInterval = 30;
    }
    return self;
}


// MARK: ======================= EasyAdSupplierDelegate =======================
/// 加载策略Model成功
- (void)easyAdBaseAdapterLoadSuccess:(nonnull EasyAdSupplierModel *)model {

}

/// 加载策略Model失败
- (void)easyAdBaseAdapterLoadError:(nullable NSError *)error {
    if ([_delegate respondsToSelector:@selector(easyAdFailedWithError:description:)]) {
        [_delegate easyAdFailedWithError:error description:[self.errorDescriptions copy]];
    }
}

// 选中的rule Tag
- (void)easyAdBaseAdapterLoadSortTag:(NSString *)sortTag {
    if ([_delegate respondsToSelector:@selector(easyAdSuccessSortTag:)]) {
        [_delegate easyAdSuccessSortTag:sortTag];
    }
}

/// 返回下一个渠道的参数
- (void)easyAdBaseAdapterLoadSuppluer:(nullable EasyAdSupplier *)supplier error:(nullable NSError *)error {
    // 返回渠道有问题 则不用再执行下面的渠道了
    if (error) {
        // 错误回调只调用一次
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(easyAdFailedWithError:description:)]) {
            [self.delegate easyAdFailedWithError:error description:[self.errorDescriptions copy]];
        }
        return;
    }
    
    // 开始加载渠道前通知调用者
    if ([self.delegate respondsToSelector:@selector(easyAdSupplierWillLoad:)]) {
        [self.delegate easyAdSupplierWillLoad:supplier.tag];
    }

    // 根据渠道id自定义初始化
    NSString *clsName = @"";
    if ([supplier.tag isEqualToString:SDK_TAG_GDT]) {
        clsName = @"GdtBannerAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_CSJ]) {
        clsName = @"CsjBannerAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_BAIDU]) {
        clsName = @"BdBannerAdapter";
    }
    
    
    EAD_LEVEL_INFO_LOG(@"%@ | %@", supplier.tag, clsName);
    
    if (NSClassFromString(clsName)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _adapter = ((id (*)(id, SEL, id, id))objc_msgSend)((id)[NSClassFromString(clsName) alloc], @selector(initWithSupplier:adspot:), supplier, self);
        ((void (*)(id, SEL, id))objc_msgSend)((id)_adapter, @selector(setDelegate:), _delegate);
        ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(loadAd));
#pragma clang diagnostic pop
    } else {
        NSString *msg = [NSString stringWithFormat:@"%@ 不存在", clsName];
        EAD_LEVEL_INFO_LOG(@"%@", msg);
        [self loadNextSupplierIfHas];
    }
}


@end
