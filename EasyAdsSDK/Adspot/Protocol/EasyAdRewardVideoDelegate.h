//
//  EasyAdRewardVideoProtocol.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/9.
//  Copyright © 2020 bayescom. All rights reserved.
//

#ifndef EasyAdRewardVideoProtocol_h
#define EasyAdRewardVideoProtocol_h
#import "EasyAdBaseDelegate.h"
@protocol EasyAdRewardVideoDelegate <EasyAdBaseDelegate>
@optional

/// 广告视频缓存完成
- (void)easyAdRewardVideoOnAdVideoCached;

/// 广告视频播放完成
- (void)easyAdRewardVideoAdDidPlayFinish;

/// 广告到达激励时间
- (void)easyAdRewardVideoAdDidRewardEffective;

@end

#endif
