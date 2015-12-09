//
//  KSYPhoneLivePlayView.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPhoneLivePlayView.h"
#import "UIView+BFExtension.h"
#import "KSYCommentViewList.h"
#import "CommentModel.h"
#import "KSYCommentTableView.h"
#import "KSYSpectatorsTableView.h"
#define DeviceSizeBounds [UIScreen mainScreen].bounds

@interface KSYPhoneLivePlayView ()
{
    UILabel     *_playStateLab;
    UILabel     *_curentTimeLab;
    UIButton    *_headBtn;
    BOOL        _isPlaying;
    KSYCommentViewList *_commentViewList;
    KSYCommentTableView *_commetnTableView;
    KSYSpectatorsTableView *_spectatorsView;
    UILabel     *_userNumLab;
    BOOL        _isAdd;
    UIImageView *_headImageView;
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

    _isPlaying = NO;
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
    
    [self initCommentView];
    
    [self initSpectatprsView];

    UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseBtn.backgroundColor = [UIColor redColor];
    praiseBtn.frame = CGRectMake(_spectatorsView.right + 24, _spectatorsView.top+4, 30, 30);
    [praiseBtn addTarget:self action:@selector(praiseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:praiseBtn];

    
    
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
    
    _playStateLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 75, 20)];
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

    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
    _headImageView.backgroundColor = [UIColor cyanColor];
    _headImageView.layer.cornerRadius = 17.5;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.userInteractionEnabled = YES;
    _headImageView.hidden = YES;
    [self addSubview:_headImageView];
    
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headBtn setFrame:CGRectMake(15, 15, 35, 35)];
//    [_headBtn setTitle:@"头像" forState:UIControlStateNormal];
    _headBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_headBtn addTarget:self action:@selector(headEvent:) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.hidden = YES;
    [self addSubview:_headBtn];

}

- (void)initCommentView
{
    _commetnTableView = [[KSYCommentTableView alloc] initWithFrame:CGRectMake(10, DeviceSizeBounds.size.height - 150 - 460, 200, 400)];
    _commetnTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_commetnTableView];
    
}

- (void)initSpectatprsView
{
    _spectatorsView = [[KSYSpectatorsTableView alloc] initWithFrame:CGRectMake(45, _commetnTableView.bottom + 110, self.bounds.size.width - 45 - 80, 40)];
    [self addSubview:_spectatorsView];
}


- (void)addNewCommentWith:(id)object
{
    CommentModel *model = object;
    [_commetnTableView newUserAdd:model];
    
    if (_isAdd == NO) {
        _userNumLab = [[UILabel alloc] initWithFrame:CGRectMake(13, _commetnTableView.bottom + 115, 30, 30)];
        _userNumLab.backgroundColor = [UIColor clearColor];
        _userNumLab.text = @"200";
        _userNumLab.font = [UIFont systemFontOfSize:12];
        _userNumLab.textColor = [UIColor whiteColor];
        [self addSubview:_userNumLab];
        _isAdd = YES;
    }


}
#pragma mark- KSYMediaPlayerDelegate

- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState
{
    if (PlayerState == KSYPlayerStatePlaying) {
        _headBtn.hidden = NO;
        _playStateLab.frame = CGRectMake(_headBtn.right + 5, 15, 75, 20);
        _playStateLab.text = @"直播中";
        _curentTimeLab.frame = CGRectMake(_headBtn.right  +5, _playStateLab.bottom, 70, 20);
        NSInteger position = (NSInteger)[KSYPlayer sharedKSYPlayer].currentPlaybackTime;
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        _curentTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
        _headImageView.hidden = NO;
    }
}

#pragma mark- buttonEvent

- (void)praiseEvent
{
    [self onPraiseWithSpectatorsInteractiveType:SpectatorsInteractivePraise];
}
- (void)liveBroadcastWillClose
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[KSYPlayer sharedKSYPlayer] shutdown];
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

#pragma 点赞
- (void)onPraiseWithSpectatorsInteractiveType:(SpectatorsInteractiveType)type
{
    UIImageView* flakeView = [[UIImageView alloc] init];
    if (type == SpectatorsInteractivePresent) {
        flakeView.backgroundColor = [UIColor orangeColor];
    }else {
        flakeView.backgroundColor = [UIColor purpleColor];

    }
    int startX = round(random() % 100);
//    int endX = round(random() % 100);
    double scale = 1 / round(random() % 700) + 1.0;
    double speed = 1 / round(random() % 900) + 1.0;
    
    flakeView.frame = CGRectMake(_spectatorsView.right + 24, _spectatorsView.top+4, 30, 30);

    flakeView.alpha = 1;
    
    [self addSubview:flakeView];
    
    [UIView beginAnimations:nil context:(__bridge void * _Nullable)(flakeView)];
    [UIView setAnimationDuration:5 * speed];
    flakeView.frame = CGRectMake(startX+300, 100, 25.0 * scale, 25.0 * scale);

    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    UIImageView *flakeView = (__bridge UIImageView *)(context);
    [flakeView removeFromSuperview];
    
    
}

@end
