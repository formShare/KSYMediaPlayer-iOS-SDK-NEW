//
//  KSYVideoPlayerView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYVideoPlayerView.h"
#import "KSYTopView.h"
#import "KSYBottomView.h"
#import "SJNoticeView.h"
#import "SJDetailView.h"
#import "KSYCommentView.h"
@interface KSYVideoPlayerView ()<KSYBottomViewDelegate>
{
    KSYTopView *topView;
    KSYBottomView *bottomView;
    SJDetailView *detailView;
    KSYCommentView *commtenView;
}
//播放类型
@property (nonatomic, assign) KSYPopularLivePlayState playState;


@end




@implementation KSYVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString playState:(KSYPopularLivePlayState)playState
{
    //重置播放界面的大小
    self = [super initWithFrame:frame urlString:urlString];//初始化父视图的(frame、url)
    if (self) {
        self.player.view.frame=CGRectMake(0, 0, self.width, self.height/2);
        self.indicator.center=self.player.view.center;
        self.playState = playState;
        [self addTopView];
        [self addBottomView];
        [self addDetailView];
        [self addCommentView];
        [self refreshControl];
    }
    return self;
}

#pragma mark 添加顶部视图
- (void)addTopView
{
    topView=[[KSYTopView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44)];

    [self addSubview:topView];
}
#pragma mark 添加底部视图
- (void)addBottomView
{
    bottomView=[[KSYBottomView alloc]initWithFrame:CGRectMake(0, self.height/2-44, self.width, 44)];
    [self addSubview:bottomView];
}
#pragma mark 添加详细视图
- (void)addDetailView
{
    detailView=[[SJDetailView alloc]initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
    [self addSubview:detailView];
}
#pragma mark 添加底部评论视图
- (void)addCommentView
{
    commtenView=[[KSYCommentView alloc]initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
    [self addSubview:commtenView];
}
#pragma mark -KSYBottomViewDelegate

- (void)progressDidBegin:(id)slider
{
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [(UISlider *)slider setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration =self.player.duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        if ([self.player isPlaying] == YES) {
            [self.player pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self viewWithTag:kShortPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
    }
}

- (void)progressChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (![self.player isPreparedToPlay]) {
        slider.value = 0.0f;
        return;
    }
    //    kShortPlayBtnTag kCurrentLabelTag kPlaySliderTag kTotalLabelTag
    NSInteger duration = (NSInteger)self.player.duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        UISlider *progressSlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
        UILabel *startLabel = (UILabel *)[self viewWithTag:kCurrentLabelTag];
        
        if ([self.player isPlaying] == YES) {
            [self.player pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self viewWithTag:kShortPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
        NSInteger position = progressSlider.value;
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        NSString *strCurTime = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
        startLabel.text = strCurTime;
    }
    else {
        slider.value = 0.0f;
        [self showNotice:@"直播不支持拖拽"];
    }
}

- (void)progressChangeEnd:(id)sender {
    if (![self.player isPreparedToPlay]) {
        return;
    }
    
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration = (NSInteger)self.player.duration;
    if (duration > 0) {
        
        [self.player setCurrentPlaybackTime: slider.value];
        
    }
    else {
        slider.value = 0.0f;
        NSLog(@"###########当前是直播状态无法拖拽进度###########");
    }
}
- (void)playBtnClick
{
    
}
#pragma mark 显示提示
- (void)showNotice:(NSString *)strNotice {
    static BOOL isShowing = NO;
    if (isShowing == NO) {
        
        SJNoticeView *noticeView=[[SJNoticeView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        //和player.view没有关系
        CGFloat centerX=self.width/2;
        CGFloat centerY=self.height/2;
        CGPoint centerPoint=CGPointMake(centerX, centerY);
        noticeView.center = centerPoint;
        noticeView.noticeLabel.text=strNotice;
        [self.player.view addSubview:noticeView];
        
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
            isShowing = NO;
        }];
    }
}
#pragma mark 刷新播放时间
- (void)refreshControl {
    
    UILabel *kCurrentLabe = (UILabel *)[self viewWithTag:kCurrentLabelTag];
    UILabel *kTotalLabel = (UILabel *)[self viewWithTag:kTotalLabelTag];
    UISlider *kPlaySlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
    
    NSInteger duration = self.player.duration;
    //    NSInteger playableDuration = (NSInteger)_player.playableDuration;//获得可以播放时间
    
    NSInteger position = self.player.currentPlaybackTime;
    
    int iMin  = (int)(position / 60);
    int iSec  = (int)(position % 60);
    
    kCurrentLabe.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
    if (duration > 0) {
        int iDuraMin  = (int)(duration / 60);
        int iDuraSec  = (int)(duration % 3600 % 60);
        kTotalLabel.text = [NSString stringWithFormat:@"%02d:%02d", iDuraMin, iDuraSec];
        kPlaySlider.value = position;
        kPlaySlider.maximumValue = duration;
    }
    else {
        kTotalLabel.text = @"--:--";
        kPlaySlider.value = 0.0f;
        kPlaySlider.maximumValue = 1.0f;
    }
    if ([self.player isPlaying]==YES) {
        [self performSelector:@selector(refreshControl) withObject:nil afterDelay:1.0];
    }
    
}


#pragma mark 添加触摸事件和运动事件

@end
