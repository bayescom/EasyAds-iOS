//
//  EasyAdBaseAdPosition.m
//  AdvanceSDK
//
//  Created by MS on 2021/10/12.
//

#import "EasyAdBaseAdPosition.h"
#import "EasyAdLog.h"
#import "EasyAdSupplierModel.h"
@interface EasyAdBaseAdPosition ()
@property (nonatomic, strong) EasyAdSupplier *supplier;

@end

@implementation EasyAdBaseAdPosition

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot {
    if (self = [super init]) {
        _supplier = supplier;
    }
    return self;
}



- (void)loadAd {

    if (!_supplier) {
        return;
    }
    
    [self supplierStateLoad];
}

- (void)supplierStateLoad {
    
}





- (void)showAd {
    
}

- (void)deallocAdapter {
    
}

@end
