//
//  BYNativeAdCustomView.m
//  Example
//
//  Created by CherryKing on 2019/12/26.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "BYNativeAdCustomView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import <MercurySDK/MercurySDK.h>

@implementation BYNativeAdCustomView
- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)dealloc {
    [self.mediaView stop];
    
}

- (void)initSubviews {
    [self addSubview:self.titleLbl];
    [self addSubview:self.descLbl];
    [self addSubview:self.iconImgV];
    [self addSubview:self.contentImgV];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLbl.mas_bottom);
    }];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLbl.mas_top);
        make.height.width.mas_equalTo(40);
    }];
}

- (void)registerNativeAd:(MercuryNativeAd *)nativeAd
              dataObject:(MercuryNativeAdDataModel *)model {
    if (!model) { return; }
    
    self.titleLbl.text = model.title;
    self.descLbl.text = model.desc;
    self.sourceLbl.text = model.adsource;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    if (model.isVideoAd) {
        [super registerNativeAd:nativeAd dataObject:model clickableViews:@[]];
        [self addSubview:self.mediaView];
        [self.mediaView addSubview:self.sourceLbl];
        [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGFloat imgVH = ([UIScreen mainScreen].bounds.size.width-20)*720.0/1280.0;
            make.height.mas_equalTo(imgVH);
            make.top.mas_equalTo(self.descLbl.mas_bottom);
            make.left.right.mas_equalTo(0);
        }];
        [self.sourceLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
        }];
    } else {
        [super registerNativeAd:nativeAd dataObject:model clickableViews:@[self.contentImgV]];
        [self.contentImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
            make.top.mas_equalTo(self.descLbl.mas_bottom);
            make.left.right.mas_equalTo(0);
        }];
        [self.contentImgV sd_setImageWithURL:[NSURL URLWithString:model.image.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!image) {
                return ;
            }
            [self layoutIfNeeded];
            [self.contentImgV addSubview:self.sourceLbl];
            CGFloat imgVH = ([UIScreen mainScreen].bounds.size.width)*image.size.height/image.size.width;
            [self.contentImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imgVH);
                make.top.mas_equalTo(self.descLbl.mas_bottom);
                make.left.right.mas_equalTo(0);
            }];
            [self.sourceLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(0);
            }];
            [self setNeedsDisplay];
        }];
    }
}

// MARK: ======================= get =======================
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _titleLbl;
}

- (UILabel *)descLbl {
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _descLbl;
}

- (UIImageView *)iconImgV {
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgV;
}

- (UIImageView *)contentImgV {
    if (!_contentImgV) {
        _contentImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImgV;
}

- (UILabel *)sourceLbl {
    if (!_sourceLbl) {
        _sourceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLbl.font = [UIFont systemFontOfSize:12];
        _sourceLbl.textColor = [UIColor whiteColor];
        _sourceLbl.backgroundColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.24 alpha:0.6];
    }
    return _sourceLbl;
}

@end


