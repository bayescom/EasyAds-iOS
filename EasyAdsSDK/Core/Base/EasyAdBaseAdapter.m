//
//  EasyAdBaseAdapter.m
//  Demo
//
//  Created by CherryKing on 2020/11/20.
//

#import "EasyAdBaseAdapter.h"
#import "EasyAdSupplierManager.h"
#import "EasyAdSupplierDelegate.h"

#import "EasyAdSdkConfig.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface EasyAdBaseAdapter ()  <EasyAdSupplierManagerDelegate, EasyAdSupplierDelegate>
@property (nonatomic, strong) EasyAdSupplierManager *mgr;

@property (nonatomic, weak) id<EasyAdSupplierDelegate> baseDelegate;

/// 策略信息Json
@property (nonatomic, strong) NSDictionary *jsonDic;
@property (nonatomic, assign) BOOL isLoadAndShow;

@end

@implementation EasyAdBaseAdapter

- (instancetype)initWithJsonDic:(NSDictionary *)jsonDic {
    if (self = [super init]) {
        NSAssert(jsonDic != nil, @"广告位初始化必须要传入分发的策略信息,具体格式请参照DataJson目录下的.json文件");
        _jsonDic = jsonDic;
    }
    return self;
}

- (void)loadAd {
    _isLoadAndShow = NO;
    [self.mgr loadDataWithJsonDic:_jsonDic];
}

- (void)loadAndShowAd {
    _isLoadAndShow = YES;
    [self.mgr loadDataWithJsonDic:_jsonDic];
}

- (void)showAd {
    
}

- (void)loadNextSupplierIfHas {
    [_mgr loadNextSupplierIfHas];
}

- (void)reportWithType:(EasyAdSdkSupplierRepoType)repoType supplier:(EasyAdSupplier *)supplier error:(NSError *)error {
    // 1.这里可以进行根据自身需求添加EasyAdSdkSupplierRepoType 记录广告的生命周期并添加到每个adapter里
    // 2.关于广告的生命周期相关的操作都可以在这里进行, 比如成功失败 点击的上报
    
    
    // 失败了 并且不是并行才会走下一个渠道
    if (repoType == EasyAdSdkSupplierRepoFaileded) {
        // 搜集各渠道的错误信息
        [self collectErrorWithSupplier:supplier error:error];
        
        // 执行下一个渠道
        [_mgr loadNextSupplierIfHas];
    } else if (repoType == EasyAdSdkSupplierRepoLoaded) {
        if ([_baseDelegate respondsToSelector:@selector(easyAdBaseAdapterLoadAndShow)] && _isLoadAndShow) {
            [_baseDelegate easyAdBaseAdapterLoadAndShow];
        }
    }

}
- (void)collectErrorWithSupplier:(EasyAdSupplier *)supplier error:(NSError *)error {
    // key: 渠道名-index
    if (error) {
        NSString *key = [NSString stringWithFormat:@"%@-%@",supplier.tag, supplier.index];
        [self.errorDescriptions setObject:error forKey:key];
    }
}

- (void)deallocAdapter {
    self.mgr = nil;
    self.baseDelegate = nil;
    
}

// MARK: ======================= EasyAdSupplierManagerDelegate =======================
/// 加载策略Model成功
- (void)EasyAdSupplierManagerLoadSuccess:(EasyAdSupplierModel *)model {
    if ([_baseDelegate respondsToSelector:@selector(easyAdBaseAdapterLoadSuccess:)]) {
        [_baseDelegate easyAdBaseAdapterLoadSuccess:model];
    }
}

/// 加载策略Model失败
- (void)EasyAdSupplierManagerLoadError:(NSError *)error {
    if ([_baseDelegate respondsToSelector:@selector(easyAdBaseAdapterLoadError:)]) {
        [_baseDelegate easyAdBaseAdapterLoadError:error];
    }
}

- (void)EasyAdSupplierManagerLoadSortTag:(NSString *)tag {
    if ([_baseDelegate respondsToSelector:@selector(easyAdBaseAdapterLoadSortTag:)]) {
        [_baseDelegate easyAdBaseAdapterLoadSortTag:tag];
    }
}

/// 返回下一个渠道的参数
- (void)EasyAdSupplierLoadSuppluer:(nullable EasyAdSupplier *)supplier error:(nullable NSError *)error {

    
    // 初始化渠道参数
    NSString *clsName = @"";
    if ([supplier.tag isEqualToString:SDK_TAG_GDT]) {
        clsName = @"GDTSDKConfig";
    } else if ([supplier.tag isEqualToString:SDK_TAG_CSJ]) {
        clsName = @"BUAdSDKManager";
    } else if ([supplier.tag isEqualToString:SDK_TAG_KS]) {
        clsName = @"KSAdSDKManager";
    } else if ([supplier.tag isEqualToString:SDK_TAG_BAIDU]){
        clsName = @"BaiduMobAdSetting";
    }
    
    if ([supplier.tag isEqualToString:SDK_TAG_GDT]) {
        // 广点通SDK
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSClassFromString(clsName) performSelector:@selector(registerAppId:) withObject:supplier.appId];
        });
    } else if ([supplier.tag isEqualToString:SDK_TAG_CSJ]) {
        // 穿山甲SDK
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSClassFromString(clsName) performSelector:@selector(setAppID:) withObject:supplier.appId];
        });
    } else if ([supplier.tag isEqualToString:SDK_TAG_KS]) {
        // 快手
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSClassFromString(clsName) performSelector:@selector(setAppId:) withObject:supplier.appId];
        });

    } else if ([supplier.tag isEqualToString:SDK_TAG_BAIDU]) {
        // 百度
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            id bdSetting = ((id(*)(id,SEL))objc_msgSend)(NSClassFromString(clsName), @selector(sharedInstance));
            [bdSetting performSelector:@selector(setSupportHttps:) withObject:NO];

        });
    } else {
        
    }

    // 加载渠道
    if ([_baseDelegate respondsToSelector:@selector(easyAdBaseAdapterLoadSuppluer:error:)]) {
        [_baseDelegate easyAdBaseAdapterLoadSuppluer:supplier error:error];
    }
}

- (void)setSDKVersion {
    [self setGdtSDKVersion];
    [self setCsjSDKVersion];
    [self setMerSDKVersion];
    [self setKsSDKVersion];
}

- (void)setGdtSDKVersion {
    id cls = NSClassFromString(@"GDTSDKConfig");
    NSString *gdtVersion = [cls performSelector:@selector(sdkVersion)];
    
    [self setSDKVersionForKey:@"gdt_v" version:gdtVersion];
}

- (void)setCsjSDKVersion {
    id cls = NSClassFromString(@"BUAdSDKManager");
    NSString *csjVersion = [cls performSelector:@selector(SDKVersion)];
    
    [self setSDKVersionForKey:@"csj_v" version:csjVersion];
}

- (void)setMerSDKVersion {
    id cls = NSClassFromString(@"MercuryConfigManager");
    NSString *merVersion = [cls performSelector:@selector(sdkVersion)];

    [self setSDKVersionForKey:@"mry_v" version:merVersion];
}

- (void)setKsSDKVersion {
    id cls = NSClassFromString(@"KSAdSDKManager");
    NSString *ksVersion = [cls performSelector:@selector(SDKVersion)];
    
    [self setSDKVersionForKey:@"ks_v" version:ksVersion];
}


- (void)setSDKVersionForKey:(NSString *)key version:(NSString *)version {
    if (version) {
//        [_ext setValue:version forKey:key];
    }
}


// MARK: ======================= get =======================
- (EasyAdSupplierManager *)mgr {
    if (!_mgr) {
        _mgr = [EasyAdSupplierManager manager];
        _mgr.delegate = self;
        _baseDelegate = self;
    }
    return _mgr;
}

- (NSMutableDictionary *)errorDescriptions {
    if (!_errorDescriptions) {
        _errorDescriptions = [NSMutableDictionary dictionary];
    }
    return _errorDescriptions;
}

@end
