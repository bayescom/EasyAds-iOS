//
//  EasyAdSplash.m
//  Demo
//
//  Created by CherryKing on 2020/11/19.
//

#import <objc/runtime.h>
#import <objc/message.h>

#import "EasyAdSplash.h"
#import "EasyAdSupplierDelegate.h"
#import "EasyAdSupplierModel.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"
#import "EasyAdError.h"

@interface EasyAdSplash ()
@property (nonatomic, strong) id adapter;

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, assign) NSInteger timeout_stamp;
@property (nonatomic, strong) CADisplayLink *timeoutCheckTimer;

@end

@implementation EasyAdSplash

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic viewController:(UIViewController *)viewController {
    if (self = [super initWithJsonDic:jsonDic]) {
        if (viewController) {
            self.viewController = viewController;
        } else {
            self.viewController = [UIApplication sharedApplication].easyAd_getCurrentWindow.rootViewController;
        }
    }
    return self;
}

- (void)loadAd {
    // 占位图
    [[UIApplication sharedApplication].easyAd_getCurrentWindow addSubview:self.bgImgV];
        
    if (_timeout <= 0) { _timeout = 60; }
    // 记录过期的时间
    _timeout_stamp = ([[NSDate date] timeIntervalSince1970] + _timeout)*1000;
    // 开启定时器监听过期
    [_timeoutCheckTimer invalidate];

    _timeoutCheckTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeoutCheckTimerAction)];
    [_timeoutCheckTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [super loadAd];
}

- (void)reportWithType:(EasyAdSdkSupplierRepoType)repoType supplier:(nonnull EasyAdSupplier *)supplier error:(nonnull NSError *)error {
    [super reportWithType:repoType supplier:supplier error:error];
    if (repoType == EasyAdSdkSupplierRepoImped) {
//        EasyAdLog(@"曝光成功 计时器清零");
        [_timeoutCheckTimer invalidate];
        _timeoutCheckTimer = nil;
        [_bgImgV removeFromSuperview];
        _bgImgV = nil;
    }
}

/// Override
- (void)deallocSelf {
    [_bgImgV removeFromSuperview];
    [_timeoutCheckTimer invalidate];
    _timeoutCheckTimer = nil;
    _timeout_stamp = 0;
}

- (void)deallocDelegate:(BOOL)execute {
    
    if([_delegate respondsToSelector:@selector(easyAdFailedWithError:description:)] && execute) {
        [_delegate easyAdFailedWithError:[EasyAdError errorWithCode:EasyAdErrorCode_115].toNSError description:[self.errorDescriptions copy]];
        [_adapter performSelector:@selector(deallocAdapter)];
        [self deallocAdapter];
    }
    _delegate = nil;
}

// 无论怎样到达超时时间时  都必须移除开屏广告
- (void)timeoutCheckTimerAction {
    if ([[NSDate date] timeIntervalSince1970]*1000 > _timeout_stamp) {
        [self deallocDelegate:YES];
        [self deallocSelf];
    }
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
    [self deallocSelf];
    [self deallocDelegate:NO];
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

- (void)easyAdBaseAdapterLoadSuppluer:(nullable EasyAdSupplier *)supplier error:(nullable NSError *)error {
    // 返回渠道有问题 则不用再执行下面的渠道了
    if (error) {
        EAD_LEVEL_ERROR_LOG(@"%@", error);
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(easyAdFailedWithError:description:)]) {
            [self.delegate easyAdFailedWithError:error description:[self.errorDescriptions copy]];
        }
        [self deallocSelf];
        [self deallocDelegate:NO];
        return;
    }
    
    // 根据渠道tag自定义初始化
    NSString *clsName = @"";
    if ([supplier.tag isEqualToString:SDK_TAG_GDT]) {
        clsName = @"GdtSplashAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_CSJ]) {
        clsName = @"CsjSplashAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_KS]) {
        clsName = @"KsSplashAdapter";
    } else if ([supplier.tag isEqualToString:SDK_TAG_BAIDU]) {
        clsName = @"BdSplashAdapter";
    }
    EAD_LEVEL_INFO_LOG(@"%@ | %@", supplier.tag, clsName);
    
    
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970]*1000;
    if ((_timeout_stamp > 0) && (now+500 > _timeout_stamp)) {
        [self deallocSelf];
    } else {
        if (NSClassFromString(clsName)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [_adapter performSelector:@selector(deallocAdapter)];
            _adapter = ((id (*)(id, SEL, id, id))objc_msgSend)((id)[NSClassFromString(clsName) alloc], @selector(initWithSupplier:adspot:), supplier, self);
            ((void (*)(id, SEL, id))objc_msgSend)((id)_adapter, @selector(setDelegate:), _delegate);
            ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(loadAd));
#pragma clang diagnostic pop
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@ 不存在", clsName];
            EasyAdLog(@"%@", msg);
            [self loadNextSupplierIfHas];
        }
    }
}

- (UIImageView *)bgImgV {
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:_backgroundImage];
    }
    _bgImgV.frame = [UIScreen mainScreen].bounds;
    _bgImgV.userInteractionEnabled = YES;
    return _bgImgV;
}

- (void)showAd {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    ((void (*)(id, SEL))objc_msgSend)((id)_adapter, @selector(showAd));
#pragma clang diagnostic pop
}

@end
