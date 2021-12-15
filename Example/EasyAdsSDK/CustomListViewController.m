//
//  CustomListViewController.m
//  EasyAdsSDKDev
//
//  Created by CherryKing on 2020/4/10.
//  Copyright © 2020 bayescom. All rights reserved.
//

#import "CustomListViewController.h"
#import <Masonry.h>

@interface CustomListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *dataArr;

@property (nonatomic, strong) UIImageView *logoImgV;

@end

@implementation CustomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    
    _dataArr = @[
        @{@"title":@"开屏广告-自定义管理", @"targetVCName": @"CustomSplashViewController"},
        @{@"title":@"Banner-自定义管理", @"targetVCName": @"CustomBannerViewController"},
        @{@"title":@"插屏广告-自定义管理", @"targetVCName": @"CustomInterstitialViewController"},
        @{@"title":@"激励视频-自定义管理", @"targetVCName": @"CustomRewardVideoViewController"},
        @{@"title":@"信息流-自定义管理", @"targetVCName": @"CustomFeedExpressViewController"},
        @{@"title":@"自渲染广告-自定义管理", @"targetVCName": @"CustomListNativeAdViewController"},
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


@end
