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
#import "KSYMessageToolBar.h"
#import "KSYAlertView.h"

#define DeviceSizeBounds [UIScreen mainScreen].bounds
//  弱引用宏
#define WeakSelf(VC) __weak VC *weakSelf = self

@interface KSYPhoneLivePlayView ()<KSYMediaPlayerDelegate,UIAlertViewDelegate>


@property (nonatomic, strong)KSYInteractiveView *interactiveView;
@property (nonatomic, strong)UIButton           *closeButton;
@property (nonatomic, strong)UIButton           *reportButton;
@property (nonatomic, strong)UILabel            *playStateLab;
@property (nonatomic, strong)UILabel            *curentTimeLab;
@property (nonatomic, strong)UIButton           *headButton;
@property (nonatomic, strong)UIImageView        *headImageView;
@property (nonatomic, strong)KSYAlertView        *alertView;

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


    [self addSubview:self.closeButton];
    [self addSubview:self.reportButton];
    [self addSubview:self.playStateLab];
    [self addSubview:self.curentTimeLab];
    [self addSubview:self.headButton];
    [self addSubview:self.headImageView];
    [self addSubview:self.interactiveView];
    [self addSubview:self.alertView];

    [self bringSubviewToFront:self.closeButton];
    return YES;
}

- (KSYInteractiveView *)interactiveView
{
    WeakSelf(KSYPhoneLivePlayView);
    if (!_interactiveView) {
        _interactiveView = [[KSYInteractiveView alloc] initWithFrame:CGRectMake(0, 270, self.frame.size.width, self.frame.size.height - 270) playState:self.playState];
        _interactiveView.alertViewBlock = ^(id obj){
//            [weakSelf.alertView show];
            [weakSelf setInfoViewFrame:YES];
//            [weakSelf shakeToShow:weakSelf.alertView];
        };
    }
    return _interactiveView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setFrame:CGRectMake(DeviceSizeBounds.size.width - 60, 10, 40, 30)];
        [_closeButton setTitle:@"X" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_closeButton addTarget:self action:@selector(liveBroadcastWillClose) forControlEvents:UIControlEventTouchUpInside];

    }
    return _closeButton;
}

- (UIButton *)reportButton
{
    if (!_reportButton) {
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportBtn setFrame:CGRectMake(DeviceSizeBounds.size.width - 115, 10, 40, 30)];
        [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        reportBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [reportBtn addTarget:self action:@selector(liveBroadcastWillBeReport) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reportBtn];

    }
    return _reportButton;
}

- (UILabel *)playStateLab
{
    if (!_playState) {
        _playStateLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 75, 20)];
        _playStateLab.text = @"直播连线中...";
        _playStateLab.textColor = [UIColor whiteColor];
        _playStateLab.font = [UIFont systemFontOfSize:12.0];
        _playStateLab.backgroundColor = [UIColor clearColor];

    }
    return _playStateLab;
}

- (UILabel *)curentTimeLab
{
    if (!_curentTimeLab) {
        _curentTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _curentTimeLab.textColor = [UIColor whiteColor];
        _curentTimeLab.font = [UIFont systemFontOfSize:12.0];
        _curentTimeLab.backgroundColor = [UIColor clearColor];

    }
    return _curentTimeLab;
}

- (UIButton *)headButton
{
    if (!_headButton) {
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headButton setFrame:CGRectMake(15, 15, 35, 35)];
        //    [_headBtn setTitle:@"头像" forState:UIControlStateNormal];
        _headButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_headButton addTarget:self action:@selector(headEvent:) forControlEvents:UIControlEventTouchUpInside];
        _headButton.hidden = YES;

    }
    return _headButton;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        _headImageView.backgroundColor = [UIColor cyanColor];
        _headImageView.layer.cornerRadius = 17.5;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.hidden = YES;

    }
    return _headImageView;
}

- (KSYAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[KSYAlertView alloc] initWithFrame:CGRectMake(70, 150 ,DeviceSizeBounds.size.width - 140, 430)];
        _alertView.backgroundColor = [UIColor blackColor];
        _alertView.alpha = 0.8;
        _alertView.hidden = YES;
    }
    return _alertView;
}

- (void)addNewCommentWith:(id)object
{
    
    [self.interactiveView addNewCommentWith:object];

}
#pragma mark- KSYMediaPlayerDelegate

- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState
{
    if (PlayerState == KSYPlayerStatePlaying) {
        _headButton.hidden = NO;
        _playStateLab.frame = CGRectMake(_headButton.right + 5, 15, 75, 20);
        _playStateLab.text = @"直播中";
        _curentTimeLab.frame = CGRectMake(_headButton.right  +5, _playStateLab.bottom, 70, 20);
        NSInteger position = (NSInteger)[KSYPlayer sharedKSYPlayer].currentPlaybackTime;
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        _curentTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
        _headImageView.hidden = NO;
    }
}

#pragma mark- buttonEvent

- (void)liveBroadcastWillClose
{
    
    [self.interactiveView messageToolBarInputResignFirstResponder];
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

- (void)onPraiseWithSpectatorsInteractiveType:(SpectatorsInteractiveType)type
{
    [self.interactiveView onPraiseWithSpectatorsInteractiveType:type];
}

#pragma aletView

- (void)setInfoViewFrame:(BOOL)isDown{
    if(isDown == NO)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [self.alertView setFrame:CGRectMake(100, 0+60, 320, 90)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
//                                                  [self.alertView setFrame:CGRectMake(0, SCREENHEIGHT, 320, 90)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
        
    }else
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:0
                         animations:^{
                             [self.alertView setFrame:CGRectMake(70, 250, 0, 0)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseInOut
                                              animations:^{
                                                  self.alertView.hidden = NO;
                                                  [self.alertView setFrame:CGRectMake(70, 150 ,DeviceSizeBounds.size.width - 140, 430)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    }
}


@end
