//
//  KSYVideoPlayerView.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//
typedef enum : NSUInteger {
    KSYPopularLivePlay,       //手机直播播放
    KSYPopularPlayBack,       //手机直播回放
} KSYPopularLivePlayState;

#import "KSYBasePlayView.h"


@interface KSYVideoPlayerView : KSYBasePlayView

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString playState:(KSYPopularLivePlayState)playState;

@end
