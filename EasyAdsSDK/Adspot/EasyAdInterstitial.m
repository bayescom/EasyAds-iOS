//
//  EasyAdInterstitial.m
//  AdvanceSDKExample
//
//  Created by CherryKing on 2020/4/7.
//  Copyright © 2020 Mercury. All rights reserved.
//

#import "EasyAdInterstitial.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EasyAdLog.h"

@interface EasyAdInterstitial ()
@property (nonatomic, strong) id adapter;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIViewController *controller;

@end

@implementation EasyAdInterstitial

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic
                 viewController:(UIViewController *)viewController {
    if (self = [super initWithJsonDic:jsonDic]) {
        self.viewController = viewController;
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
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(easyAdFailedWithError:description:)]) {
            [self.delegate easyAdFailedWithError:error description:[self.errorDescriptions copy]];
        }
        [self deallocDelegate:NO];
        return;
    }

    // 根据渠道id自定义初始化
    NSString *clsName = @"";
    if ([supplier.tag isEqualToString:SDK_TAG_GDT]) {
        clsName = @"GdtInterstitialAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_CSJ]) {
        clsName = @"CsjInterstitialProAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_KS]) {
        clsName = @"KsInterstitialAdapter";
    }
    
    if (NSClassFromString(clsName)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _adapter = ((id (*)(id, SEL, id, id))objc_msgSend)((id)[NSClassFromString(clsName) alloc], @selector(initWithSupplier:adspot:), supplier, self);
        ((void (*)(id, SEL, id))objc_msgSend)((id)_adapter, @selector(setDelegate:), _delegate);
        ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(loadAd));
#pragma clang diagnostic pop
    } else {
        [self loadNextSupplierIfHas];
    }
    
}

- (void)deallocDelegate:(BOOL)execute {
    if(execute) {
        [_adapter performSelector:@selector(deallocAdapter)];
        [self deallocAdapter];
    }
    _delegate = nil;
}


- (void)showAd {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(showAd));
#pragma clang diagnostic pop
}

@end
