//
//  TestCustomFeedTableViewCell.m
//  Example
//
//  Created by CherryKing on 2019/12/25.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "TestCustomFeedTableViewCell.h"

#import <MercurySDK/MercurySDK.h>
#import "Masonry.h"

@interface TestCustomFeedTableViewCell ()
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@end

@implementation TestCustomFeedTableViewCell

- (void)dealloc {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adView = [[BYNativeAdCustomView alloc] init];
        [self addSubview:self.adView];
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.right.bottom.mas_equalTo(-10);
        }];
        [self addSubview:self.playBtn];
        [self addSubview:self.pauseBtn];
        [self addSubview:self.stopBtn];
        [self addSubview:self.voiceBtn];
        [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.stopBtn.mas_left).offset(-2);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.pauseBtn.mas_left).offset(-2);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.playBtn.mas_left).offset(-2);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.adView unregisterDataObject]; // unregister 必须执行，为了 cell 复用。
//    self.adView.titleLabel.text = @"";
//    self.adView.descLabel.text = @"";
//    self.adView.imageView.image = nil;
//    self.adView.iconImageView.image = nil;
//    self.adView.leftImageView.image = nil;
//    self.adView.midImageView.image = nil;
//    self.adView.rightImageView.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)registerNativeAd:(MercuryNativeAd *)nativeAd
              dataObject:(MercuryNativeAdDataModel *)model {
    [self.adView unregisterDataObject];
    [self.adView registerNativeAd:nativeAd dataObject:model];
    
    model.videoConfig.autoResumeEnable = NO;
    model.videoConfig.userControlEnable = YES;
    model.videoConfig.progressViewEnable = YES;
    model.videoConfig.coverImageEnable = YES;
    model.videoConfig.videoPlayPolicy = MercuryVideoAutoPlayPolicyWIFI;
    
    [_playBtn addTarget:self.adView.mediaView action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [_pauseBtn addTarget:self.adView.mediaView action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [_stopBtn addTarget:self.adView.mediaView action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [_voiceBtn addTarget:self action:@selector(voiceOn_Off) forControlEvents:UIControlEventTouchUpInside];
    
    self.playBtn.hidden = !model.isVideoAd;
    self.pauseBtn.hidden = !model.isVideoAd;
    self.stopBtn.hidden = !model.isVideoAd;
    self.voiceBtn.hidden = !model.isVideoAd;
    
    [self.adView registerClickableCallToActionView:self.adView.mediaView];
}

- (void)voiceOn_Off {
    self.adView.dataModel.videoConfig.videoMuted = !self.adView.dataModel.videoConfig.videoMuted;
    _voiceBtn.selected = self.adView.dataModel.videoConfig.videoMuted;
}

+ (CGFloat)cellHeightWithModel:(MercuryNativeAdDataModel *)model {
    return 230;
}

// MARK: ======================= get =======================
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn.backgroundColor = [UIColor yellowColor];
        [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _pauseBtn.backgroundColor = [UIColor yellowColor];
        [_pauseBtn setTitle:@"pause" forState:UIControlStateNormal];
    }
    return _pauseBtn;
}

- (UIButton *)stopBtn {
    if (!_stopBtn) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _stopBtn.backgroundColor = [UIColor yellowColor];
        [_stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    }
    return _stopBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _voiceBtn.backgroundColor = [UIColor yellowColor];
        [_voiceBtn setTitle:@"voice on" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"voice off" forState:UIControlStateSelected];
    }
    return _voiceBtn;
}

@end
