//
//  EasyAdFullScreenVideoDelegate.h
//  AdvanceSDKDev
//
//  Created by CherryKing on 2020/4/13.
//  Copyright © 2020 bayescom. All rights reserved.
//

#ifndef EasyAdFullScreenVideoDelegate_h
#define EasyAdFullScreenVideoDelegate_h
#import "EasyAdBaseDelegate.h"
@protocol EasyAdFullScreenVideoDelegate <EasyAdBaseDelegate>
@optional
/// 视频播放完成
- (void)easyAdFullScreenVideoOnAdPlayFinish;


@end

#endif
