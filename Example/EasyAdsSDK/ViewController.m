//
//  ViewController.m
//  EasyAdsSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "ViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *dataArr;

@property (nonatomic, strong) UIImageView *logoImgV;
@property (nonatomic, strong) UILabel *idfaLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    
    _dataArr = @[
//        @{@"title":@"自定义管理SDK", @"targetVCName": @"CustomListViewController"},
        @{@"title":@"开屏", @"targetVCName": @"DemoSplashViewController"},
        @{@"title":@"Banner", @"targetVCName": @"DemoBannerViewController"},
        @{@"title":@"插屏", @"targetVCName": @"DemoInterstitialViewController"},
        @{@"title":@"激励视频", @"targetVCName": @"DemoRewardVideoViewController"},
        @{@"title":@"信息流", @"targetVCName": @"DemoListFeedExpressViewController"},
        @{@"title":@"全屏视频", @"targetVCName": @"DemoFullScreenVideoController"},
        @{@"title":@"IDFA", @"targetVCName": @""},
    ];
    
    [_tableView reloadData];
}

- (void)initSubviews {
//    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"SDK设置" style:UIBarButtonItemStylePlain target:self action:@selector(toSettingsViewController)];
//    self.navigationItem.rightBarButtonItem = settingItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    _tableView.backgroundView = [UIView new];
    
    UILabel *vLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    vLbl.textAlignment = NSTextAlignmentCenter;
    
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }

    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)toSettingsViewController {
    [self.navigationController pushViewController:[[NSClassFromString(@"SettingsViewController") alloc] init] animated:YES];
}

// MARK: UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    cell.textLabel.text = _dataArr[indexPath.row][@"title"];
    if (indexPath.row == 6) {
        [self addIdfaLabeWithView:cell.contentView];
    }
    cell.detailTextLabel.text = [self getIDFA];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[NSClassFromString(_dataArr[indexPath.row][@"targetVCName"]) alloc] init];
    vc.title = _dataArr[indexPath.row][@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSString *)getIDFA{
    
    NSString *idfa = @"";
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        NSLog(@"IDFA:%@", idfa);
    } else {
        idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        NSLog(@"IDFA:%@", idfa);
    }
    
    return idfa;
}

- (void)addIdfaLabeWithView:(UIView *)view {
    [view addSubview:self.idfaLab];
    [self.idfaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(view);
        make.left.equalTo(view).offset(100);
    }];
    
    self.idfaLab.text = [[self getIDFA] isEqualToString:@""] ? @"请在设置-隐私-跟踪中允许App请求跟踪" : [self getIDFA];
}

- (UILabel *)idfaLab {
    if (!_idfaLab) {
        _idfaLab = [UILabel new];
        _idfaLab.numberOfLines = 0;
    }
    return _idfaLab;
}



@end
