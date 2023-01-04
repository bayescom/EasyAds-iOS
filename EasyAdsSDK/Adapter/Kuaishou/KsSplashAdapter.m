//
//  KsSplashAdapter.m
//  AdvanceSDK
//
//  Created by MS on 2021/4/20.
//

#import "KsSplashAdapter.h"

#if __has_include(<KSAdSDK/KSAdSDK.h>)
#import <KSAdSDK/KSAdSDK.h>
#else
//#import "KSAdSDK.h"
#endif

#import "EasyAdSplash.h"
#import "UIApplication+EasyAds.h"
#import "EasyAdLog.h"
#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(weak##type) strong##type = weak##type;

@interface KsSplashAdapter ()<KSSplashAdViewDelegate>
@property (nonatomic, weak) EasyAdSplash *adspot;
@property (nonatomic, strong) EasyAdSupplier *supplier;

// 剩余时间，用来判断用户是点击跳过，还是正常倒计时结束
@property (nonatomic, assign) NSUInteger leftTime;
// 是否点击了
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) KSSplashAdView *ks_ad;
@property (nonatomic, strong) UIImageView *imgV;


@end

@implementation KsSplashAdapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super initWithSupplier:supplier adspot:adspot]) {
        _adspot = adspot;
        _supplier = supplier;
        _leftTime = 5;  // 默认5s
        _ks_ad = [[KSSplashAdView alloc] initWithPosId:_supplier.adspotId];
    }
    return self;
}

- (void)supplierStateLoad {
    EAD_LEVEL_INFO_LOG(@"加载快手 supplier: %@", _supplier);
    
    NSInteger timeout = 5;
    if (self.adspot.timeout) {
        if (self.adspot.timeout > 500) {
            timeout = self.adspot.timeout / 1000.0;
        }
    }

    _ks_ad.delegate = self;
    _ks_ad.rootViewController = _adspot.viewController;
    _ks_ad.timeoutInterval = timeout;
    [_ks_ad loadAdData];

}

- (void)loadAd {
    [super loadAd];
}

- (void)deallocAdapter {
//    _gdt_ad = nil;
    if (self.ks_ad) {
        [self.ks_ad removeFromSuperview];
        self.ks_ad = nil;
        [self.imgV removeFromSuperview];
        self.imgV = nil;
    }
}


/**
 * splash ad request done
 */
- (void)ksad_splashAdDidLoad:(KSSplashAdView *)splashAdView {
//    [self showAd];

}
/**
 * splash ad material load, ready to display
 */
- (void)ksad_splashAdContentDidLoad:(KSSplashAdView *)splashAdView {
    if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
        [self.delegate easyAdUnifiedViewDidLoad];
    }
    [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
    [self.adspot reportWithType:EasyAdSdkSupplierRepoLoaded supplier:_supplier error:nil];
}
/**
 * splash ad (material) failed to load
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didFailWithError:(NSError *)error {
    EAD_LEVEL_INFO_LOG(@"%@",error);
    [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
    [self deallocAdapter];
}
/**
 * splash ad did visible
 */
- (void)ksad_splashAdDidVisible:(KSSplashAdView *)splashAdView {
    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
        [self.delegate easyAdExposured];
    }
    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
}
/**
 * splash ad video begin play
 * for video ad only
 */
- (void)ksad_splashAdVideoDidBeginPlay:(KSSplashAdView *)splashAdView {

}
/**
 * splash ad clicked
 * @param inMiniWindow whether click in mini window
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didClick:(BOOL)inMiniWindow {
    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
        [self.delegate easyAdClicked];
    }
    [_imgV removeFromSuperview];
    _imgV = nil;
}
/**
 * splash ad will zoom out, frame can be assigned
 * for video ad only
 * @param frame target frame
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView willZoomTo:(inout CGRect *)frame {
    
}
/**
 * splash ad zoomout view will move to frame
 * @param frame target frame
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView willMoveTo:(inout CGRect *)frame {
    
}
/**
 * splash ad skipped
 * @param showDuration  splash show duration (no subsequent callbacks, remove & release KSSplashAdView here)
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didSkip:(NSTimeInterval)showDuration {
//    NSLog(@"----%@", NSStringFromSelector(_cmd));
    if ([self.delegate respondsToSelector:@selector(easyAdSplashOnAdSkipClicked)]) {
        [self.delegate easyAdSplashOnAdSkipClicked];
    }
    [self deallocAdapter];
}
/**
 * splash ad close conversion viewcontroller (no subsequent callbacks, remove & release KSSplashAdView here)
 */
- (void)ksad_splashAdDidCloseConversionVC:(KSSplashAdView *)splashAdView interactionType:(KSAdInteractionType)interactType {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
    [self deallocAdapter];

}

/**
 * splash ad play finished & auto dismiss (no subsequent callbacks, remove & release KSSplashAdView here)
 */
- (void)ksad_splashAdDidAutoDismiss:(KSSplashAdView *)splashAdView {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
    [self deallocAdapter];

}
/**
 * splash ad close by user (zoom out mode) (no subsequent callbacks, remove & release KSSplashAdView here)
 */
- (void)ksad_splashAdDidClose:(KSSplashAdView *)splashAdView {
    if ([self.delegate respondsToSelector:@selector(easyAdDidClose)]) {
        [self.delegate easyAdDidClose];
    }
    [self deallocAdapter];

}
















//- (void)checkAction {
//    NSInteger timeout = 5;
//    if (self.adspot.timeout) {
//        if (self.adspot.timeout > 500) {
//            timeout = self.adspot.timeout / 1000.0;
//        }
//    }
//
//    WeakSelf(self);
//    [KSAdSplashManager checkSplashWithTimeoutv2:timeout completion:^(KSAdSplashViewController * _Nullable splashViewController, NSError * _Nullable error) {
//        StrongSelf(self);
//        NSLog(@"kssplashViewController %@   error:%@", splashViewController, error);
//        [strongself checkResultWith:splashViewController error:error];
//    }];
//}
//
//- (void)checkResultWith:(KSAdSplashViewController *)splashViewController error:(NSError *)error {
//    if (splashViewController) {
//        // 请求数据成功
//        [self.adspot reportWithType:EasyAdSdkSupplierRepoSucceeded supplier:_supplier error:nil];
//        if ([self.delegate respondsToSelector:@selector(easyAdUnifiedViewDidLoad)]) {
//            [self.delegate easyAdUnifiedViewDidLoad];
//        }
//        self.vc = splashViewController;
//        if (_supplier.isParallel == YES) {
//            _supplier.state = AdvanceSdk  ;
//            return;
//        }
//        [self showAd];
//    }
//
//    if (error) {
//        [self.adspot reportWithType:EasyAdSdkSupplierRepoFaileded supplier:_supplier error:error];
//        if (_supplier.isParallel == YES) {
//            _supplier.state = AdvanceSdk ;
//        }
//    }
//}

- (void)showAd {
    if (!_ks_ad) {
        return;
    }
    // 设置logo
    CGRect adFrame = [UIScreen mainScreen].bounds;
    if (_adspot.logoImage && _adspot.showLogoRequire) {
        
        NSAssert(_adspot.logoImage != nil, @"showLogoRequire = YES时, 必须设置logoImage");
        CGFloat real_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat real_h = _adspot.logoImage.size.height*(real_w/_adspot.logoImage.size.width);
        adFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-real_h);
        
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-real_h, real_w, real_h)];
        self.imgV.userInteractionEnabled = YES;
        self.imgV.image = _adspot.logoImage;
        [[UIApplication sharedApplication].easyAd_getCurrentWindow addSubview:self.imgV];
    }
    _ks_ad.frame = adFrame;
    [_ks_ad showInView:[UIApplication sharedApplication].easyAd_getCurrentWindow];
}

//- (void)ksad_splashAdDismiss:(BOOL)converted {
//    //convert为YES时需要直接隐藏掉splash，防止影响后续转化页面展示
//    WeakSelf(self)
//    [self.vc dismissViewControllerAnimated:!converted completion:^{
//        StrongSelf(self);
//        if ([strongself.delegate respondsToSelector:@selector(easyAdDidClose)]) {
//            [strongself.delegate easyAdDidClose];
//        }
//    }];
//
//}
//
//- (void)ksad_splashAdClicked {
//    NSLog(@"----%@", NSStringFromSelector(_cmd));
//    [self.adspot reportWithType:EasyAdSdkSupplierRepoClicked supplier:_supplier error:nil];
//    if ([self.delegate respondsToSelector:@selector(easyAdClicked)]) {
//        [self.delegate easyAdClicked];
//    }
//}
//
//- (void)ksad_splashAdDidShow {
//    NSLog(@"----%@", NSStringFromSelector(_cmd));
//    [self.adspot reportWithType:EasyAdSdkSupplierRepoImped supplier:_supplier error:nil];
//    if ([self.delegate respondsToSelector:@selector(easyAdExposured)]) {
//        [self.delegate easyAdExposured];
//    }
//}
//
//- (void)ksad_splashAdTimeOver {
//    NSLog(@"----%@", NSStringFromSelector(_cmd));
//    if ([self.delegate respondsToSelector:@selector(easyAdSplashOnAdCountdownToZero)]) {
//        [self.delegate easyAdSplashOnAdCountdownToZero];
//    }
//
//}
//
//- (void)ksad_splashAdVideoDidSkipped:(NSTimeInterval)playDuration {
//    NSLog(@"----%@", NSStringFromSelector(_cmd));
//    if ([self.delegate respondsToSelector:@selector(easyAdSplashOnAdSkipClicked)]) {
//        [self.delegate easyAdSplashOnAdSkipClicked];
//    }
//}
//
//- (void)ksad_splashAdVideoDidStartPlay {
//    NSLog(@"----%@", NSStringFromSelector(_cmd));
//}
//
//- (void)ksad_splashAdVideoFailedToPlay:(NSError *)error {
//    NSLog(@"----%@, %@", NSStringFromSelector(_cmd), error);
//}
//
//- (UIViewController *)ksad_splashAdConversionRootVC {
//    return [UIApplication sharedApplication].easyAd_getCurrentWindow.rootViewController;
//}
//

@end
