//
//  KSYBasePlayView.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/18.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYBasePlayView.h"
#import "KSYPlayer.h"

@interface KSYBasePlayView ()<KSYMediaPlayerDelegate>

@property (nonatomic, strong)KSYPlayer *player;

@end

@implementation KSYBasePlayView

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _player = [[KSYPlayer alloc] initWithURL:[NSURL URLWithString:urlString]];
        _player.shouldAutoplay = YES;
        _player.delegate = self;
        [self addSubview:_player.videoView];
        _player.videoView.frame = frame;
        _player.videoView.backgroundColor = [UIColor blackColor];

        
        //开启低延时模式
        [_player playerSetUseLowLatencyWithBenable:LOW_LATENCY_DROP_AUDIO maxMs:3000 minMs:500];
        
        [_player setScalingMode:MPMovieScalingModeAspectFit];
        
        [_player prepareToPlay];


    }
    return self;
}

- (void)dealloc
{
    [self.player shutdown];
    self.player = nil;
}
@end
