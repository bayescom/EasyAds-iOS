//
//  BaseViewController.m
//  Example
//
//  Created by CherryKing on 2019/12/20.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewBuilder.h"

#define ssRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@interface BaseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;
@property (nonatomic, strong) UIButton *btnLoadAndShow;
@property (nonatomic, strong) UILabel *labNotify;
@property (nonatomic, copy) NSString *text;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _text = @"";
    self.isOnlyLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
        
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.standardAppearance = appearance;
    }
    
    [self.view addSubview:self.btnLoad];
    [self.view addSubview:self.btnShow];
    [self.view addSubview:self.btnLoadAndShow];
    [self.view addSubview:self.labNotify];
    [self.view addSubview:self.textV];
    [self loadAdWithState:AdState_Normal];

    self.btnLoad.frame = CGRectMake(50, 100, 140, 40);
    self.btnShow.frame = CGRectMake(50, 160, 140, 40);
    self.btnLoadAndShow.frame = CGRectMake(50, 220, 140, 40);
    self.labNotify.frame = CGRectMake(0, 280, self.view.frame.size.width, 40);
    self.textV.frame = CGRectMake(0, 330, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.labNotify.frame) - 20);
}

- (void)setIsOnlyLoad:(BOOL)isOnlyLoad {
    _isOnlyLoad = isOnlyLoad;
    self.btnLoad.hidden = !_isOnlyLoad;
    self.btnShow.hidden = !_isOnlyLoad;
}

- (void)loadAd {
    [self clearText];
    [self loadAdWithState:AdState_Normal];
}

- (void)showAd {
    
}

- (void)loadAndShowAd {
    [self clearText];
    [self loadAdWithState:AdState_Normal];
}

- (void)deallocAd {
    
}

- (void)showProcessWithText:(NSString *)text {
    _text = [_text stringByAppendingString:[NSString stringWithFormat:@"\r\n%@",text]];
    self.textV.text = _text;
}

- (void)showErrorWithDescription:(NSDictionary *)description {
    if (!description) {
        return;
    }
    
    NSString *highlightText = [self getSianKeyWithDic:description];
    _text = [_text stringByAppendingString:[NSString stringWithFormat:@", 失败原因如下:\r\n%@",highlightText]];

//    NSString *temp = [self replaceUnicode:_text];
    
    NSMutableAttributedString *attributedStr = [self setupAttributeString:_text highlightText:highlightText];
    _textV.attributedText = attributedStr;
}



- (void)clearText {
    
    _text = @"";
    self.textV.text = nil;
}

- (void)loadAdWithState:(AdState)state {
    switch (state) {
        case AdState_Normal:
            self.labNotify.text = @"未加载广告";
            break;
        case AdState_Loading:
            self.labNotify.text = @"广告加载中...";
            break;
        case AdState_LoadSucceed:
            self.labNotify.text = @"广告加载成功";
            break;
        case AdState_LoadFailed:
            self.labNotify.text = @"广告加载失败";
            break;

        default:
            break;
    }
}

- (UIButton *)btnLoad {
    if (!_btnLoad) {
        _btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnLoad.backgroundColor = ssRGBHex(0xf58220);
        _btnLoad.layer.cornerRadius = 5.f;
        _btnLoad.layer.masksToBounds = YES;
        [_btnLoad setTitle:@"load Ad" forState:UIControlStateNormal];
        [_btnLoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLoad;
}

- (UIButton *)btnShow {
    if (!_btnShow) {
        _btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnShow.backgroundColor = ssRGBHex(0xf58220);
        _btnShow.layer.cornerRadius = 5.f;
        _btnShow.layer.masksToBounds = YES;
        [_btnShow setTitle:@"show Ad" forState:UIControlStateNormal];
        [_btnShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnShow addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnShow;
}

- (UIButton *)btnLoadAndShow {
    if (!_btnLoadAndShow) {
        _btnLoadAndShow = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnLoadAndShow.backgroundColor = ssRGBHex(0xf58220);
        _btnLoadAndShow.layer.cornerRadius = 5.f;
        _btnLoadAndShow.layer.masksToBounds = YES;
        [_btnLoadAndShow setTitle:@"load and showAd" forState:UIControlStateNormal];
        [_btnLoadAndShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnLoadAndShow addTarget:self action:@selector(loadAndShowAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLoadAndShow;
}

- (UILabel *)labNotify {
    if (!_labNotify) {
        _labNotify = [UILabel new];
        _labNotify.textColor = ssRGBHex(0xf58220);
        _labNotify.font = [UIFont systemFontOfSize:15];
        _labNotify.textAlignment = NSTextAlignmentCenter;
    }
    return _labNotify;
}

- (UITextView *)textV {
    if (!_textV) {
        _textV = [UITextView new];
        _textV.font = [UIFont systemFontOfSize:15];
        _textV.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textV.textAlignment = NSTextAlignmentLeft;
        _textV.editable = NO;
    }
    return _textV;
}


- (NSString *)getSianKeyWithDic:(NSDictionary *)dic
{
    //按字典排序
    
    NSArray* arr = [dic allKeys];
    
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        
        return result == NSOrderedDescending;
    }];
    
    //拼接字符串
    NSMutableArray * strArray =[[NSMutableArray alloc]init];
    [arr enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *appendStr = [[NSString alloc] init];
        
        appendStr = obj;
        
        NSError *par = dic[obj];
        
        if (dic[obj]!=NULL) {
            
            appendStr = [appendStr stringByAppendingString:par.userInfo.description];
            
            NSInteger code = par.code;
            NSString *desc = par.userInfo[NSLocalizedDescriptionKey];
            if (!desc) {
                desc = par.userInfo[@"desc"];
            }
            
            NSString *errorInfo = [NSString stringWithFormat:@"%@: code: %ld 错误详情:%@", obj, code, desc];
            [strArray addObject:errorInfo];

        }
        
    }];
    
    NSString * str = [strArray componentsJoinedByString:@"\r\n"];
    
    return str;
    
}

- (NSMutableAttributedString *)setupAttributeString:(NSString *)text highlightText:(NSString *)highlightText {
    
    NSRange hightlightTextRange = [text rangeOfString:highlightText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:hightlightTextRange];
        
        return attributeStr;
    } else {
        return [highlightText copy];
    }
}

@end
