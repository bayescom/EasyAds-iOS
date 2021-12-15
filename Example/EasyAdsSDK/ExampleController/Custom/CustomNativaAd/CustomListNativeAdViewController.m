//
//  CustomListNativeAdViewController.m
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/14.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "CustomListNativeAdViewController.h"
#import "CellBuilder.h"
#import "BYExamCellModel.h"
#import "DemoUtils.h"

#import <AdvanceSDK/AdvanceNativeExpress.h>

#import "BUDFeedAdTableViewCell.h"
#import "BUDFeedNormalTableViewCell.h"
#import <BUAdSDK/BUNativeAdsManager.h>

#import <MercurySDK/MercurySDK.h>
#import "TestCustomFeedTableViewCell.h"

#import <GDTUnifiedNativeAd.h>
#import <GDTUnifiedNativeAdView.h>
#import "UnifiedNativeAdImageCell.h"
#import "UnifiedNativeAdThreeImageCell.h"

@interface CustomListNativeAdViewController (CSJ) <BUNativeAdsManagerDelegate, BUVideoAdViewDelegate, BUNativeAdDelegate>
- (UITableViewCell *)csj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)csj_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CustomListNativeAdViewController (Mercury) <MercuryNativeAdDelegate, MercuryNativeAdViewDelegate>
- (UITableViewCell *)mercury_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mercury_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CustomListNativeAdViewController (GDT) <GDTUnifiedNativeAdDelegate, GDTUnifiedNativeAdViewDelegate>
- (UITableViewCell *)gdt_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)gdt_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CustomListNativeAdViewController () <UITableViewDelegate, UITableViewDataSource, AdvanceBaseAdspotDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) AdvanceBaseAdspot *adspot;
@property (nonatomic, strong) NSMutableArray *dataArrM;

@property (nonatomic, strong) BUNativeAdsManager *csj_ad;
@property (nonatomic, strong) MercuryNativeAd *mercury_ad;
@property (nonatomic, strong) GDTUnifiedNativeAd *gdt_ad;


@end

@implementation CustomListNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息流";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];

    [_tableView registerClass:[ExamTableViewCell class] forCellReuseIdentifier:@"ExamTableViewCell"];
    [_tableView registerClass:[BUDFeedAdLeftTableViewCell class] forCellReuseIdentifier:@"BUDFeedAdLeftTableViewCell"];
    [_tableView registerClass:[BUDFeedAdLargeTableViewCell class] forCellReuseIdentifier:@"BUDFeedAdLargeTableViewCell"];
    [_tableView registerClass:[BUDFeedAdGroupTableViewCell class] forCellReuseIdentifier:@"BUDFeedAdGroupTableViewCell"];
    [_tableView registerClass:[BUDFeedVideoAdTableViewCell class] forCellReuseIdentifier:@"BUDFeedVideoAdTableViewCell"];
    [_tableView registerClass:[BUDFeedNormalTableViewCell class] forCellReuseIdentifier:@"BUDFeedNormalTableViewCell"];
    [_tableView registerClass:[BUDFeedNormalTitleTableViewCell class] forCellReuseIdentifier:@"BUDFeedNormalTitleTableViewCell"];
    [_tableView registerClass:[BUDFeedNormalTitleImgTableViewCell class] forCellReuseIdentifier:@"BUDFeedNormalTitleImgTableViewCell"];
    [_tableView registerClass:[BUDFeedNormalBigImgTableViewCell class] forCellReuseIdentifier:@"BUDFeedNormalBigImgTableViewCell"];
    [_tableView registerClass:[BUDFeedNormalthreeImgsableViewCell class] forCellReuseIdentifier:@"BUDFeedNormalthreeImgsableViewCell"];
    [self.tableView registerClass:[UnifiedNativeAdImageCell class] forCellReuseIdentifier:@"UnifiedNativeAdImageCell"];
    [self.tableView registerClass:[UnifiedNativeAdThreeImageCell class] forCellReuseIdentifier:@"UnifiedNativeAdThreeImageCell"];
    
    [_tableView registerClass:[TestCustomFeedTableViewCell class] forCellReuseIdentifier:@"TestCustomFeedTableViewCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    
    _dataArrM = [NSMutableArray arrayWithArray:[CellBuilder dataFromJsonFile:@"cell01"]];
    
    [self loadBtnAction:nil];
}

- (void)loadBtnAction:(id)sender {
    _adspot = [[AdvanceNativeExpress alloc] initWithAdspotId:@"10002698" viewController:self adSize:CGSizeMake(self.view.bounds.size.width, 300)];
    
    _adspot.supplierDelegate = self;
    [_adspot setDefaultAdvSupplierWithMediaId:@"100255"
                                          adspotId:@"10002698"
                                          mediaKey:@"757d5119466abe3d771a211cc1278df7"
                                            sdkId:SDK_ID_MERCURY];
    [_adspot loadAd];
}

// MARK: ======================= AdvanceBaseAdspotDelegate =======================
/// 加载渠道广告，将会返回渠道所需参数
/// @param sdkId 渠道Id
/// @param params 渠道参数
- (void)advanceBaseAdspotWithSdkId:(NSString *)sdkId params:(NSDictionary *)params {
    // 根据渠道id自定义初始化
    int adCount = 1;
    if (_adspot && _adspot.currentAdvSupplier.adCount > 0) {
        adCount = _adspot.currentAdvSupplier.adCount;
    }
    if ([sdkId isEqualToString:SDK_ID_GDT]) {
        self.gdt_ad = [[GDTUnifiedNativeAd alloc] initWithPlacementId:[params objectForKey:@"2000566593234845"]];//@"2000566593234845"];
        self.gdt_ad.delegate = self;
        [self.gdt_ad loadAdWithAdCount:adCount];
    } else if ([sdkId isEqualToString:SDK_ID_CSJ]) {
        BUNativeAdsManager *nad = [BUNativeAdsManager new];
        BUAdSlot *slot1 = [[BUAdSlot alloc] init];
        slot1.ID = [params objectForKey:@"900546910"];//@"900546910";
        slot1.AdType = BUAdSlotAdTypeFeed;
        slot1.position = BUAdSlotPositionTop;
        slot1.imgSize = [BUSize sizeBy:BUProposalSize_Feed690_388];
        slot1.isSupportDeepLink = YES;
        nad.adslot = slot1;
        nad.delegate = self;
        _csj_ad = nad;
        [nad loadAdDataWithCount:adCount];
    } else if ([sdkId isEqualToString:SDK_ID_MERCURY]) {
        _mercury_ad = [[MercuryNativeAd alloc] initAdWithAdspotId:[params objectForKey:@"10002698"]];//@"10002698"];
        _mercury_ad.delegate = self;
        [_mercury_ad loadAdWithCount:adCount];
    }
}

- (void)advanceBaseAdspotFailedWithError:(NSError *)error {
    NSLog(@"%@", error);
}

// MARK: ======================= UITableViewDelegate, UITableViewDataSource =======================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArrM[indexPath.row] isKindOfClass:[BYExamCellModelElement class]]) {
        return ((BYExamCellModelElement *)_dataArrM[indexPath.row]).cellh;
    } else {
        if ([_dataArrM[indexPath.row] isKindOfClass:[BUNativeAd class]]) { // 穿山甲
            return [self csj_tableView:tableView heightForRowAtIndexPath:indexPath];
        } else if ([_dataArrM[indexPath.row] isKindOfClass:[MercuryNativeAdDataModel class]]) { // Mercury
            return [self mercury_tableView:tableView heightForRowAtIndexPath:indexPath];
        } else if ([_dataArrM[indexPath.row] isKindOfClass:[GDTUnifiedNativeAdDataObject class]]) { // 广点通
            return [self gdt_tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([_dataArrM[indexPath.row] isKindOfClass:[BYExamCellModelElement class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ExamTableViewCell"];
        ((ExamTableViewCell *)cell).item = _dataArrM[indexPath.row];
        return cell;
    } else if ([_dataArrM[indexPath.row] isKindOfClass:[BUNativeAd class]]) {
        cell = [self csj_tableView:tableView cellForRowAtIndexPath:indexPath];
    } else if ([_dataArrM[indexPath.row] isKindOfClass:[MercuryNativeAdDataModel class]]) { // Mercury
        cell = [self mercury_tableView:tableView cellForRowAtIndexPath:indexPath];
    } else if ([_dataArrM[indexPath.row] isKindOfClass:[GDTUnifiedNativeAdDataObject class]]) { // 广点通
        cell = [self gdt_tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

@end

// MARK: ======================= 穿山甲 =======================
@implementation CustomListNativeAdViewController (CSJ)

// MARK: BUNativeAdsManagerDelegate
- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    if (nativeAdDataArray.count > 0) {
        [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
        for (BUNativeAd *model in nativeAdDataArray) {
            NSUInteger index = rand() % (self.dataArrM.count-3)+2;
            [self.dataArrM insertObject:model atIndex:index];
        }
        NSLog(@"广告拉取成功");
        [_tableView reloadData];
    } else {
        [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
        [self.adspot selectAdvSupplierWithError:nil];
        NSLog(@"广告拉取失败");
    }
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
    [self.adspot selectAdvSupplierWithError:error];
    NSLog(@"广告请求失败");
}

// MARK: BUVideoAdViewDelegate
- (void)videoAdViewDidClick:(BUVideoAdView *)videoAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"广告点击");
}

// MARK: BUNativeAdDelegate
- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"广告曝光");
}

// MARK: TableView
- (UITableViewCell *)csj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isVideoCell = NO;
    BUNativeAd *nativeAd = (BUNativeAd *)_dataArrM[indexPath.row];
    nativeAd.rootViewController = self;
    nativeAd.delegate = self;
    UITableViewCell<BUDFeedCellProtocol> *cell = nil;
    if (nativeAd.data.imageMode == BUFeedADModeSmallImage) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BUDFeedAdLeftTableViewCell" forIndexPath:indexPath];
    } else if (nativeAd.data.imageMode == BUFeedADModeLargeImage || nativeAd.data.imageMode == BUFeedADModeImagePortrait) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BUDFeedAdLargeTableViewCell" forIndexPath:indexPath];
    } else if (nativeAd.data.imageMode == BUFeedADModeGroupImage) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BUDFeedAdGroupTableViewCell" forIndexPath:indexPath];
    } else if (nativeAd.data.imageMode == BUFeedVideoAdModeImage) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BUDFeedVideoAdTableViewCell" forIndexPath:indexPath];
        // Set the delegate to listen for status of video
        isVideoCell = YES;
    }
    
    BUInteractionType type = nativeAd.data.interactionType;
    if (cell) {
        [cell refreshUIWithModel:nativeAd];
        if (isVideoCell) {
            BUDFeedVideoAdTableViewCell *videoCell = (BUDFeedVideoAdTableViewCell *)cell;
            videoCell.nativeAdRelatedView.videoAdView.delegate = self;
            [nativeAd registerContainer:videoCell withClickableViews:@[videoCell.creativeButton]];
        } else {
            if (type == BUInteractionTypeDownload) {
                [cell.customBtn setTitle:@"ClickDownload" forState:UIControlStateNormal];
                [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
            } else if (type == BUInteractionTypePhone) {
                [cell.customBtn setTitle:@"Call" forState:UIControlStateNormal];
                [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
            } else if (type == BUInteractionTypeURL) {
                [cell.customBtn setTitle:@"ExternalLink" forState:UIControlStateNormal];
                [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
            } else if (type == BUInteractionTypePage) {
                [cell.customBtn setTitle:@"InternalLink" forState:UIControlStateNormal];
                [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
            } else {
                [cell.customBtn setTitle:@"NoClick" forState:UIControlStateNormal];
            }
        }
        return cell;
    }
    return cell;
}

- (CGFloat)csj_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = _dataArrM[index];
    BUNativeAd *nativeAd = (BUNativeAd *)model;
    CGFloat width = CGRectGetWidth(_tableView.bounds);
    if (nativeAd.data.imageMode == BUFeedADModeSmallImage) {
        return [BUDFeedAdLeftTableViewCell cellHeightWithModel:nativeAd width:width];
    } else if (nativeAd.data.imageMode == BUFeedADModeLargeImage || nativeAd.data.imageMode == BUFeedADModeImagePortrait) {
        return [BUDFeedAdLargeTableViewCell cellHeightWithModel:nativeAd width:width];
    } else if (nativeAd.data.imageMode == BUFeedADModeGroupImage) {
        return [BUDFeedAdGroupTableViewCell cellHeightWithModel:nativeAd width:width];
    } else if (nativeAd.data.imageMode == BUFeedVideoAdModeImage) {
        return [BUDFeedVideoAdTableViewCell cellHeightWithModel:nativeAd width:width];
    }
    return 0;
}

@end

// MARK: ======================= Mercury =======================
@implementation CustomListNativeAdViewController (Mercury)
// MARK: MercuryNativeAdDelegate
- (void)mercury_nativeAdLoaded:(NSArray<MercuryNativeAdDataModel *> * _Nullable)nativeAdDataModels error:(NSError * _Nullable)error {
    if (!error && nativeAdDataModels.count > 0) {
        [_tableView reloadData];
        [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
        NSUInteger index = rand() % (self.dataArrM.count-3)+2;
        [_dataArrM insertObject:nativeAdDataModels[0] atIndex:index];
        [_tableView reloadData];
        NSLog(@"广告拉取成功");
        return;
    } else {
        [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
        [self.adspot selectAdvSupplierWithError:error];
        NSLog(@"广告渲染失败");
    }
}

// MARK: MercuryNativeAdViewDelegate
- (void)mercury_nativeAdViewWillExpose:(MercuryNativeAdView *)nativeAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"广告曝光成功");
}

- (void)mercury_nativeAdViewDidClick:(MercuryNativeAdView *)nativeAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"广告点击");
}

// MARK: TableView
- (UITableViewCell *)mercury_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [_tableView dequeueReusableCellWithIdentifier:@"TestCustomFeedTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ((TestCustomFeedTableViewCell *)cell).adView.delegate = self;
    [((TestCustomFeedTableViewCell *)cell) registerNativeAd:_mercury_ad dataObject:_dataArrM[indexPath.row]];
    return cell;
}

- (CGFloat)mercury_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TestCustomFeedTableViewCell cellHeightWithModel:_dataArrM[indexPath.row]];
}

@end

// MARK: ======================= 广点通 =======================
@implementation CustomListNativeAdViewController (GDT)
// MARK: GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error {
    if (!error && unifiedNativeAdDataObjects.count > 0) {
        NSUInteger index = rand() % (self.dataArrM.count-3)+2;
        [_dataArrM insertObject:unifiedNativeAdDataObjects[0] atIndex:index];
        [self.tableView reloadData];
        [self.adspot reportWithType:AdvanceAdvSupplierRepoSucceeded];
        NSLog(@"成功请求到广告数据");
        return;
    } else {
        [self.adspot reportWithType:AdvanceAdvSupplierRepoFaileded];
        [self.adspot selectAdvSupplierWithError:error];
    }
    
    if (error.code == 5004) {
        NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    } else if (error.code == 5005) {
        NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    } else if (error.code == 5009) {
        NSLog(@"流量控制导致没有广告，超过小时限额");
    } else if (error.code == 5006) {
        NSLog(@"包名错误");
    } else if (error.code == 5010) {
        NSLog(@"广告样式校验失败");
    } else if (error.code == 3001) {
        NSLog(@"网络错误");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

// MARK: GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoClicked];
    NSLog(@"广告点击");
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [self.adspot reportWithType:AdvanceAdvSupplierRepoImped];
    NSLog(@"广告曝光");
}

// MARK: TableView
- (UITableViewCell *)gdt_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GDTUnifiedNativeAdDataObject *dataObject = _dataArrM[indexPath.row];
    if (dataObject.isThreeImgsAd) {
        UnifiedNativeAdThreeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnifiedNativeAdThreeImageCell"];
        [cell setupWithUnifiedNativeAdDataObject:dataObject delegate:self vc:self];
        return cell;
    } else {
        UnifiedNativeAdImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnifiedNativeAdImageCell"];
        [cell setupWithUnifiedNativeAdDataObject:dataObject delegate:self vc:self];
        return cell;
    }
}

- (CGFloat)gdt_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GDTUnifiedNativeAdDataObject *dataObject = _dataArrM[indexPath.row];
    if (dataObject.isThreeImgsAd) {
        return [UnifiedNativeAdThreeImageCell cellHeightWithUnifiedNativeAdDataObject:dataObject];
    } else {
        return [UnifiedNativeAdImageCell cellHeightWithUnifiedNativeAdDataObject:dataObject];
    }
}
@end
