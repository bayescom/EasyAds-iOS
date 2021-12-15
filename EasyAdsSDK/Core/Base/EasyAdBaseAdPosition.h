//
//  EasyAdBaseAdPosition.h
//  AdvanceSDK
//
//  Created by MS on 2021/10/12.
//

#import <Foundation/Foundation.h>
@class EasyAdSupplier;
NS_ASSUME_NONNULL_BEGIN

@interface EasyAdBaseAdPosition : NSObject
@property (nonatomic, assign) NSInteger tag;// 标记并行渠道为了找到响应的adapter

- (instancetype)initWithSupplier:(EasyAdSupplier *)supplier adspot:(id)adspot;

- (void)supplierStateLoad;



- (void)loadAd;

- (void)showAd;

- (void)deallocAdapter;

@end

NS_ASSUME_NONNULL_END
