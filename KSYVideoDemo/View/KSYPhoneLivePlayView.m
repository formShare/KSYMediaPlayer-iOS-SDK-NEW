//
//  KSYPhoneLivePlayView.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPhoneLivePlayView.h"
#import "UIView+BFExtension.h"
#define DeviceSizeBounds [UIScreen mainScreen].bounds

@interface KSYPhoneLivePlayView ()
{
    UILabel     *_playStateLab;
    UILabel     *_curentTimeLab;
    UIButton    *_headBtn;
}
@end


@implementation KSYPhoneLivePlayView


- (BOOL)start
{

    if (self.urlString ==nil) {
        NSLog(@"url can't be nil");
        return NO;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    KSYPlayer *player = [KSYPlayer sharedKSYPlayer];
    [player startWithMURL:[NSURL URLWithString:self.urlString] withOptions:nil allowLog:NO appIdentifier:@"ksy"];
    player.shouldAutoplay = YES;
    [player prepareToPlay];
    player.delegate = self;
    [self addSubview:player.videoView];
    player.videoView.frame = DeviceSizeBounds;
    player.videoView.backgroundColor = [UIColor blackColor];
    
    
    //开启低延时模式
    [player playerSetUseLowLatencyWithBenable:1 maxMs:3000 minMs:500];
    
    [player setScalingMode:MPMovieScalingModeAspectFit];

    
    [self initHeadViews];
    
    return YES;
}

- (void)initHeadViews
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(DeviceSizeBounds.size.width - 60, 10, 40, 30)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [closeBtn addTarget:self action:@selector(liveBroadcastWillClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportBtn setFrame:CGRectMake(DeviceSizeBounds.size.width - 115, 10, 40, 30)];
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [reportBtn addTarget:self action:@selector(liveBroadcastWillBeReport) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reportBtn];
    
    _playStateLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 75, 20)];
    _playStateLab.text = @"直播连线中...";
    _playStateLab.textColor = [UIColor whiteColor];
    _playStateLab.font = [UIFont systemFontOfSize:12.0];
    _playStateLab.backgroundColor = [UIColor clearColor];
    [self addSubview:_playStateLab];
    
    _curentTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _curentTimeLab.textColor = [UIColor whiteColor];
    _curentTimeLab.font = [UIFont systemFontOfSize:12.0];
    _curentTimeLab.backgroundColor = [UIColor clearColor];
    [self addSubview:_curentTimeLab];

    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headBtn setFrame:CGRectMake(15, 10, 40, 30)];
    [_headBtn setTitle:@"头像" forState:UIControlStateNormal];
    _headBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_headBtn addTarget:self action:@selector(headEvent:) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.hidden = YES;
    [self addSubview:_headBtn];

}

#pragma mark- KSYMediaPlayerDelegate

- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState
{
    if (PlayerState == KSYPlayerStatePlaying) {
        _headBtn.hidden = NO;
        _playStateLab.frame = CGRectMake(_headBtn.right + 5, 10, 75, 20);
        _playStateLab.text = @"直播中";
        _curentTimeLab.frame = CGRectMake(_headBtn.right  +5, _playStateLab.bottom, 70, 20);
        NSInteger position = (NSInteger)[KSYPlayer sharedKSYPlayer].currentPlaybackTime;
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        _curentTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
    }
}

#pragma mark- buttonEvent

- (void)liveBroadcastWillClose
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    if (self.liveBroadcastCloseBlock) {
        self.liveBroadcastCloseBlock();
    }
    
}

- (void)liveBroadcastWillBeReport
{
    if (self.liveBroadcastReporteBlock) {
        self.liveBroadcastReporteBlock();
    }
}

- (void)headEvent:(UIButton *)button
{

}
@end
