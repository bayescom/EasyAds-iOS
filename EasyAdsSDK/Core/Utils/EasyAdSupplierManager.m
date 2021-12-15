//
//  EasyAdSupplierManager.m
//  Demo
//
//  Created by CherryKing on 2020/11/18.
//

#import "EasyAdSupplierManager.h"
#import "EasyAdSdkConfig.h"
#import "EasyAdSupplierModel.h"
#import "EasyAdError.h"
#import "EasyAdLog.h"
#import "EasyAdModel.h"
#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(weak##type) strong##type = weak##type;
@interface EasyAdSupplierManager ()
@property (nonatomic, strong) EasyAdSupplierModel *model;

// 可执行渠道
@property (nonatomic, strong) NSMutableArray<EasyAdSupplier *> *supplierM;
@property (nonatomic, strong) NSMutableArray *setting;
@property (nonatomic, copy) NSString *sortTag;


@end

@implementation EasyAdSupplierManager

+ (instancetype)manager {
    EasyAdSupplierManager *mgr = [EasyAdSupplierManager new];
    return mgr;
}

- (void)loadDataWithJsonDic:(NSDictionary *)jsonDic {
    _model = [EasyAdSupplierModel easyAd_modelWithDictionary:jsonDic];
    
    if (_model) {
        if ([_delegate respondsToSelector:@selector(EasyAdSupplierManagerLoadSuccess:)]) {
            [_delegate EasyAdSupplierManagerLoadSuccess:_model];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(EasyAdSupplierManagerLoadError:)]) {
            [_delegate EasyAdSupplierManagerLoadError:[EasyAdError errorWithCode:EasyAdErrorCode_104 obj:nil].toNSError];
        }
        return;
    }
    
    _supplierM = [_model.suppliers mutableCopy];
    
    [self sortSupplierMByPercent];
}

- (void)loadNextSupplierIfHas {
    // 执行渠道逻辑
    [self loadNextSupplier];
}

- (void)loadNextSupplier {
    
    
    NSNumber *idx = _setting.firstObject;
    
    EasyAdSupplier *currentSupplier;
    for (EasyAdSupplier *supplier in _supplierM) {
        if (supplier.index == idx) {
            currentSupplier = supplier;
        }
    }
    
    [self notCPTLoadNextSuppluer:currentSupplier index:idx];
}


/// 执行下个渠道
- (void)notCPTLoadNextSuppluer:(nullable EasyAdSupplier *)supplier index:(NSNumber *)idx {
    // 选择渠道执行都失败
    if (_setting.count <= 0) {
        // 抛异常
        if ([_delegate respondsToSelector:@selector(EasyAdSupplierLoadSuppluer:error:)]) {
            [_delegate EasyAdSupplierLoadSuppluer:nil error:[EasyAdError errorWithCode:EasyAdErrorCode_114].toNSError];
        }
        return;
    }
    
    @try {
        [_setting removeObjectAtIndex:0];
    } @catch (NSException *exception) {EAD_LEVEL_INFO_LOG(@"exception: %@", exception);}
        
    if ([_delegate respondsToSelector:@selector(EasyAdSupplierLoadSuppluer:error:)]) {
        [_delegate EasyAdSupplierLoadSuppluer:supplier error:nil];
    }
}

// MARK: ======================= Private =======================
- (void)sortSupplierMByPercent {
    NSAssert(_model.rules != nil, @"setting字段不能为空, json格式请严格遵守文档");
    
    if (_model.rules.count == 0) {
        EAD_LEVEL_ERROR_LOG(@"setting字段内未设置任何信息, 请严格遵守文档");
        if ([_delegate respondsToSelector:@selector(EasyAdSupplierLoadSuppluer:error:)]) {
            [_delegate EasyAdSupplierLoadSuppluer:nil error:[EasyAdError errorWithCode:EasyAdErrorCode_113].toNSError];
        }
        return;
    }

    [self doPercent];
}

- (void)doPercent {
    __block NSInteger percentSum = 0;
    
    NSMutableArray *temp = [_model.rules mutableCopy];
    
    // 对所有percent 求和
    [temp enumerateObjectsUsingBlock:^(EasyAdSetting *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        percentSum += obj.percent;
    }];
    
    // 生成 0 - 100 之间随机数(0% - 100%)
    NSInteger result = [self getRandomNumber:0 to:10000];
    
    __block CGFloat currentPercentSum = 0;
    
    // 计算各组百分比 并且和随机数比较 当随机数落到该组的概率范围内 则选取该组的顺序
    WeakSelf(self);
    [temp enumerateObjectsUsingBlock:^(EasyAdSetting *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StrongSelf(self);
        
        CGFloat currentObjPercent = ((CGFloat)obj.percent / (CGFloat)percentSum) * 10000;
        
        currentPercentSum += currentObjPercent;
        if (currentPercentSum > result) {
            // 逆序 是为了后续代码方便
            _setting = [obj.sort mutableCopy];
            _sortTag = obj.tag;
            
            if ([_delegate respondsToSelector:@selector(EasyAdSupplierManagerLoadSortTag:)]) {
                [_delegate EasyAdSupplierManagerLoadSortTag:_sortTag];
            }

            [strongself loadNextSupplier];
            *stop = YES;
        }
    }];
}

- (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

- (void)sortSupplierMByIndex {
    if (_supplierM.count > 1) {
        [_supplierM sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
            EasyAdSupplier *obj11 = obj1;
            EasyAdSupplier *obj22 = obj2;
            if (obj11.index > obj22.index) {
                return NSOrderedDescending;
            } else if (obj11.index == obj22.index) {
                return NSOrderedSame;
            } else {
                return NSOrderedAscending;
            }
        }];
    }
}



- (void)dealloc {
    EAD_LEVEL_INFO_LOG(@"EasyAdSupplierManager 释放啦");
    self.model = nil;
}
@end
