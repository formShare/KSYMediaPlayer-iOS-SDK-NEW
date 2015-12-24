//
//  KSYVideoPlayerView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYVideoPlayerView.h"
#import "KSYTopView.h"
#import "SJNoticeView.h"
#import "SJDetailView.h"
#import "KSYBottomView.h"
#import "KSYCommentView.h"

@interface KSYVideoPlayerView ()
{
    KSYTopView *topView;
    KSYBottomView *bottomView;
    SJDetailView *detailView;
    KSYCommentView *commtenView;
    BOOL isActive;
}
//播放类型
@property (nonatomic, assign) KSYPopularLivePlayState playState;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat curPosition;
@property (nonatomic, assign) KSYGestureType gestureType;
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
//        [self refreshControl];
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
    WeakSelf(KSYVideoPlayerView);
    bottomView=[[KSYBottomView alloc]initWithFrame:CGRectMake(0, self.height/2-44, self.width, 44)];
    bottomView.progressDidBegin=^(UISlider *slider){
        [weakSelf progDidBegin:slider];
    };
    bottomView.progressChanged=^(UISlider *slider){
        [weakSelf progChanged:slider];
    };
    bottomView.progressChangeEnd=^(UISlider *slider){
        [weakSelf progChangeEnd:slider];
    };
    bottomView.BtnClick=^{
        [weakSelf BtnClick];
    };
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
    WeakSelf(KSYVideoPlayerView);
    commtenView=[[KSYCommentView alloc]initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
    commtenView.textFieldDidBeginEditing=^{
        [weakSelf changeTextFrame];
    };
    commtenView.send=^{
        [weakSelf resetTextFrame];
    };
    [self addSubview:commtenView];
}
#pragma mark -KSYBottomViewDelegate
- (void)progDidBegin:(UISlider *)slider
{
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
    UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIButton *btn = (UIButton *)[self viewWithTag:kShortPlayBtnTag];
    [btn setImage:playImg forState:UIControlStateNormal];
}
-(void)progChanged:(UISlider *)slider
{
    if (![self.player isPreparedToPlay]) {
        slider.value = 0.0f;
        return;
    }
    UISlider *progressSlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
    UILabel *startLabel = (UILabel *)[self viewWithTag:kCurrentLabelTag];
    UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIButton *btn = (UIButton *)[self viewWithTag:kShortPlayBtnTag];
    [btn setImage:playImg forState:UIControlStateNormal];
    NSInteger position = progressSlider.value;
    int iMin  = (int)(position / 60);
    int iSec  = (int)(position % 60);
    NSString *strCurTime = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
    startLabel.text = strCurTime;

}
- (void)progChangeEnd:(UISlider *)slider
{
    if (![self.player isPreparedToPlay]) {
        slider.value=0.0f;
        return;
    }
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
        
    [self.player setCurrentPlaybackTime: slider.value];
}
- (void)BtnClick
{
    if (!self)
    {
        return;
    }
    if ([self.player isPlaying]==NO){
        [self play];
    }
    else{
        [self pause];
    }

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

- (void)updateCurrentTime{
    UILabel *kCurrentLabe = (UILabel *)[self viewWithTag:kCurrentLabelTag];
    UILabel *kTotalLabel = (UILabel *)[self viewWithTag:kTotalLabelTag];
    UISlider *kPlaySlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
    NSInteger duration = self.player.duration;
    NSInteger position = self.player.currentPlaybackTime;
    
    int iMin  = (int)(position / 60);
    int iSec  = (int)(position % 60);
    
    kCurrentLabe.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];

    int iDuraMin  = (int)(duration / 60);
    int iDuraSec  = (int)(duration % 3600 % 60);
    kTotalLabel.text = [NSString stringWithFormat:@"%02d:%02d", iDuraMin, iDuraSec];
    kPlaySlider.value = position;
    kPlaySlider.maximumValue = duration;
}

#pragma mark 刷新播放时间
- (void)refreshControl {
    
    UILabel *kCurrentLabe = (UILabel *)[self viewWithTag:kCurrentLabelTag];
    UILabel *kTotalLabel = (UILabel *)[self viewWithTag:kTotalLabelTag];
    UISlider *kPlaySlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
    
    NSInteger duration = self.player.duration;
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
        [self performSelector:@selector(refreshControl) withObject:nil afterDelay:1.0];//一秒钟更新一次
    }
}
#pragma mark 添加触摸事件和运动事件
#pragma mark 注册通知
- (void)registerApplicationObservers
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
#pragma mark 移除通知
- (void)unregisterApplicationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}
- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
    {
        [self changeDeviceOrientation:UIInterfaceOrientationPortrait];
    }
    
}
//手动设置设备方向，这样就能收到转屏事件
- (void)changeDeviceOrientation:(UIInterfaceOrientation)toOrientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = toOrientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UISlider *progressSlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
    _startPoint = [[touches anyObject] locationInView:self];
    _curPosition = progressSlider.value;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    CGFloat deltaX = curPoint.x - _startPoint.x;
    CGFloat deltaY = curPoint.y - _startPoint.y;
    NSInteger duration = (NSInteger)self.player.duration;
    
    if (fabs(deltaX) < fabs(deltaY)) {//如果是纵向滑动
        return ;
    }
    else if (curPoint.y>64&&curPoint.y<self.player.view.bottom&&duration > 0 && (_gestureType == kKSYUnknown || _gestureType == kKSYProgress)) {
        
        if (![self.player isPreparedToPlay]) {
            return;
        }
        if (fabs(deltaX) > fabs(deltaY)) {
            _gestureType = kKSYProgress;
            
            UISlider *progressSlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
            UILabel *startLabel = (UILabel *)[self viewWithTag:kCurrentLabelTag];
            CGFloat totalWidth=self.width;
            CGFloat deltaProgress = deltaX / totalWidth * duration;
            NSInteger position = _curPosition + deltaProgress;
            if (position < 0) {
                position = 0;
            }
            else if (position > duration) {
                position = duration;
            }
            progressSlider.value = position;
            int iMin1  = ((int)labs(position) / 60);
            int iSec1  = ((int)labs(position) % 60);
            NSString *strCurTime1 = [NSString stringWithFormat:@"%02d:%02d", iMin1, iSec1];
            startLabel.text = strCurTime1;
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_gestureType == kKSYUnknown) { // **** tap 动作
        if (isActive == NO) {
            [self showAllControls];
            
        }
        else {
            [self hiddenAllControls];
        }
        [self resetTextFrame];
    }
    else if (_gestureType == kKSYProgress) {
        if (![self.player isPreparedToPlay]) {
            return;
        }
        
        UISlider *progressSlider = (UISlider *)[self viewWithTag:kPlaySliderTag];
        [self  moviePlayerSeekTo:progressSlider.value];
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
    }
    _gestureType = kKSYUnknown;
}
#pragma mark 显示控件
- (void) showAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        topView.hidden=NO;
        bottomView.hidden=NO;
    } completion:^(BOOL finished) {
        isActive = YES;
        [self refreshControl];
    }];
}
#pragma mark 隐藏控件
- (void) hiddenAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        topView.hidden=YES;
        bottomView.hidden=YES;
    } completion:^(BOOL finished) {
        isActive = NO;
    }];
    
    
}
- (void)changeTextFrame
{
    //执行动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGFloat kCommentViewY=self.height/2-40;
        commtenView.frame=CGRectMake(0,  kCommentViewY, self.width, 40);
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];

}
- (void)resetTextFrame
{

    UITextField *textField=(UITextField *)[self viewWithTag:kTextFieldTag];
    [textField resignFirstResponder];
    //执行动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       commtenView.frame=CGRectMake(0, self.height-40, self.width, 40);
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];
}
@end
