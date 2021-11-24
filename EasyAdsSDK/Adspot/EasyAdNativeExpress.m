//
//  EasyAdNativeExpress.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/13.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "EasyAdNativeExpress.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EasyAdLog.h"

@interface EasyAdNativeExpress ()
@property (nonatomic, strong) id adapter;

@end

@implementation EasyAdNativeExpress

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                 viewController:(UIViewController *)viewController
                         adSize:(CGSize)size {
    if (self = [super initWithJsonDic:jsonDic]) {
        self.viewController = viewController;
        _adSize = size;
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

// loadAndShow时触发 在该回调里调用show
- (void)easyAdBaseAdapterLoadAndShow {
    [self showAd];
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
    
    // 根据渠道id自定义初始化
    NSString *clsName = @"";
    if ([supplier.tag isEqualToString:SDK_TAG_GDT]) {
        // 广点通 信息流1.0 2.0 已经合并 合并后统一走旧的回调
        clsName = @"GdtNativeExpressAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_CSJ]) {
        clsName = @"CsjNativeExpressAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_KS]) {
        clsName = @"KsNativeExpressAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_BAIDU]) {
        clsName = @"BdNativeExpressAdapter";
    }
    
    if (NSClassFromString(clsName)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _adapter = ((id (*)(id, SEL, id, id))objc_msgSend)((id)[NSClassFromString(clsName) alloc], @selector(initWithSupplier:adspot:), supplier, self);
        ((void (*)(id, SEL, id))objc_msgSend)((id)_adapter, @selector(setController:), self.viewController);
        ((void (*)(id, SEL, id))objc_msgSend)((id)_adapter, @selector(setDelegate:), _delegate);
        ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(loadAd));
#pragma clang diagnostic pop
    } else {
//        EasyAdLog(@"%@ 不存在", clsName);
        [self loadNextSupplierIfHas];
    }

}

- (void)showAd {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(showAd));
#pragma clang diagnostic pop
}

@end
