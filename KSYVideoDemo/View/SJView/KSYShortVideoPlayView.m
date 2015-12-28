//
//  KSYShortVideoPlayView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYShortVideoPlayView.h"
#import "KSYTopView.h"
#import "KSYBottomView.h"
@interface KSYShortVideoPlayView ()




@end


@implementation KSYShortVideoPlayView


- (instancetype)initWithFrame:(CGRect)frame UrlPathString:(NSString *)urlPathString
{
    //重置播放界面的大小
    self = [super initWithFrame:frame urlString:urlPathString];//初始化父视图的(frame、url)
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self registerApplicationObservers];
    }
    return self;
}
#pragma mark 添加顶部视图
- (KSYTopView *)topView
{
    if (!_topView) {
        _topView=[[KSYTopView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
        _topView.hidden=NO;
    }
    return  _topView;
}
#pragma mark 添加底部视图
- (KSYBottomView *)bottomView
{
    if (!_bottomView) {
        WeakSelf(KSYShortVideoPlayView);
        _bottomView=[[KSYBottomView alloc]initWithFrame:CGRectMake(0, self.height/2-40, self.width, 40)];
        _bottomView.progressDidBegin=^(UISlider *slider){
            [weakSelf progDidBegin:slider];
        };
        _bottomView.progressChanged=^(UISlider *slider){
            [weakSelf progChanged:slider];
        };
        _bottomView.progressChangeEnd=^(UISlider *slider){
            [weakSelf progChangeEnd:slider];
        };
        _bottomView.BtnClick=^(UIButton *btn){
            [weakSelf BtnClick:btn];
        };

    }
    return _bottomView;
}
#pragma mark -KSYBottomViewDelegate
- (void)progDidBegin:(UISlider *)slider
{
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
    if ([self.player isPlaying]==YES) {
        UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
        UIButton *btn = (UIButton *)[self viewWithTag:kBarPlayBtnTag];
        [btn setImage:playImg forState:UIControlStateNormal];
    }
    
}
-(void)progChanged:(UISlider *)slider
{
    if (![self.player isPreparedToPlay]) {
        slider.value = 0.0f;
        return;
    }
    UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
    UILabel *startLabel = (UILabel *)[self viewWithTag:kProgressCurLabelTag];
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
    if ([self.player isPlaying]==YES) {
        UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
        UIButton *btn = (UIButton *)[self viewWithTag:kBarPlayBtnTag];
        [btn setImage:playImg forState:UIControlStateNormal];
    }
    
    [self.player setCurrentPlaybackTime: slider.value];
}
- (void)BtnClick:(UIButton *)btn
{
    if (!self)
    {
        return;
    }
    if ([self.player isPlaying]==NO){
        [self play];
        UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
        [btn setImage:pauseImg_n forState:UIControlStateNormal];
    }
    else{
        [self pause];
        UIImage *playImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
        [btn setImage:playImg_n forState:UIControlStateNormal];
    }
    
}
#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
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
    else if (curPoint.y>64&&curPoint.y<self.player.view.bottom&&duration > 0 && (self.gestureType == kKSYUnknown || self.gestureType == kKSYProgress)) {
        
        if (![self.player isPreparedToPlay]) {
            return;
        }
        if (fabs(deltaX) > fabs(deltaY)) {
            self.gestureType = kKSYProgress;
            
            UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
            UILabel *startLabel = (UILabel *)[self viewWithTag:kProgressCurLabelTag];
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
    if (self.gestureType == kKSYUnknown) { // **** tap 动作
        if (_isActive == NO) {
            [self showAllControls];
        }
        else {
            [self hiddenAllControls];
        }
        [self resetTextFrame];
    }
    else if (self.gestureType == kKSYProgress) {
        if (![self.player isPreparedToPlay]) {
            return;
        }
        
        UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
        [self  moviePlayerSeekTo:progressSlider.value];
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
    }
    self.gestureType = kKSYUnknown;
}
#pragma mark 显示控件
- (void) showAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        _topView.hidden=NO;
        _bottomView.hidden=NO;
    } completion:^(BOOL finished) {
        _isActive = YES;
    }];
}
#pragma mark 隐藏控件
- (void) hiddenAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        _topView.hidden=YES;
        _bottomView.hidden=YES;
    } completion:^(BOOL finished) {
        _isActive = NO;
    }];
    
    
}
- (void)updateCurrentTime{
    UILabel *kCurrentLabe = (UILabel *)[self viewWithTag:kProgressCurLabelTag];
    UILabel *kTotalLabel = (UILabel *)[self viewWithTag:kProgressMaxLabelTag];
    UISlider *kPlaySlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
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
#pragma mark 退出全屏模式
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
- (void)dealloc
{
    [self unregisterApplicationObservers];
}


@end
