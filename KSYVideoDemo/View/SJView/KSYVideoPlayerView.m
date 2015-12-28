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
#import "KSYBrightnessView.h"
#import "KSYVoiceView.h"
#import "KSYProgressView.h"
#import "KSYLockView.h"
#import "KSYToolView.h"
#import "KSYSetView.h"
#import "KSBarrageView.h"
@interface KSYVideoPlayerView ()
{
    KSYTopView *topView;
    KSYBottomView *bottomView;
    KSYBrightnessView *kBrightnessView;
    KSYVoiceView *kVoiceView;
    KSYProgressView *kProgressView;
    KSYLockView *kLockView;
    KSYToolView *kToolView;
    KSYSetView *kSetView;
    KSBarrageView *kDanmuView;
    BOOL isActive;
    BOOL isLock;
    BOOL isOpen;
}
//播放类型
@property (nonatomic, assign) KSYPopularLivePlayState playState;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat curPosition;
@property (nonatomic, assign) CGFloat curVoice;
@property (nonatomic, assign) CGFloat curBrightness;
@property (nonatomic, assign) CGRect kPreviousSelfFrame;
@property (nonatomic, assign) CGRect kPreviousPlayViewFrame;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) BOOL fullScreenModeToggled;
@end




@implementation KSYVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame UrlWithString:(NSString *)urlString playState:(KSYPopularLivePlayState)playState
{
    //重置播放界面的大小
    self = [super initWithFrame:frame urlString:urlString];//初始化父视图的(frame、url)
    if (self) {
        _playState=playState;
        isLock=NO;
        self.kPreviousSelfFrame=self.frame;
        self.kPreviousPlayViewFrame=self.player.view.frame;
        [self addTopView];
        [self addBottomView];
        [self addBrightnessVIew];
        [self addVoiceView];
        [self registerApplicationObservers];
        [self addProgressView];
        [self addLockBtn];
        [self performSelector:@selector(hiddenAllControls) withObject:nil afterDelay:3.0];
    }
    return self;
}
#pragma mark 添加设置视图
- (void)addSetView
{
    if (!kSetView) {
        kSetView=[[KSYSetView alloc]initWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height)];
        kSetView.hidden=YES;
    }
    [self addSubview:kSetView];
}
#pragma mark 添加工具视图
- (KSYToolView *)kToolView
{
    WeakSelf(KSYVideoPlayerView);
    if (!kToolView)
    {
        kToolView=[[KSYToolView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        kToolView.hidden=YES;
        kToolView.showSetView=^(UIButton *btn){
            [weakSelf showSetView:(btn)];
        };
    }
    return kToolView;
}
#pragma mark 添加锁屏按钮
- (void)addLockBtn
{
    WeakSelf(KSYVideoPlayerView);
    kLockView=[[KSYLockView alloc]initWithFrame:CGRectMake(kCoverLockViewLeftMargin, (self.width - self.width / 6) / 2, self.width / 6, self.width / 6)];
    kLockView.kLockViewBtn=^(UIButton *btn){
        [weakSelf lockBtn:btn];
    };
    kLockView.hidden=YES;
    [self addSubview:kLockView];
}
#pragma mark 添加进度指示
- (void)addProgressView
{
    kProgressView=[[KSYProgressView alloc]initWithFrame:CGRectMake((self.width - kProgressViewWidth) / 2, (self.height - 50) / 4, kProgressViewWidth, 50)];
    kProgressView.hidden=YES;
    [self addSubview:kProgressView];
}
#pragma mark 添加顶部视图
- (void)addTopView
{
    topView=[[KSYTopView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
    if (_playState==KSYPopularLivePlay) {
        topView.hidden=YES;
    }
    [self addSubview:topView];
}
#pragma mark 添加底部视图
- (void)addBottomView
{
        
    WeakSelf(KSYVideoPlayerView);
    bottomView=[[KSYBottomView alloc]initWithFrame:CGRectMake(0, self.height/2-40, self.width, 40) PlayState:_playState];
    if (_playState==KSYPopularLivePlay) {
        bottomView.hidden=YES;
    }
    bottomView.progressDidBegin=^(UISlider *slider){
        [weakSelf progDidBegin:slider];
    };
    bottomView.progressChanged=^(UISlider *slider){
        [weakSelf progChanged:slider];
    };
    bottomView.progressChangeEnd=^(UISlider *slider){
        [weakSelf progChangeEnd:slider];
    };
    bottomView.BtnClick=^(UIButton *btn){
        [weakSelf BtnClick:btn];
    };
    bottomView.FullBtnClick=^(UIButton *btn){
        [weakSelf Fullclick:btn];
    };
    bottomView.changeBottomFrame=^(UITextField *textField){
        [weakSelf changeBottom:textField];
    };
    bottomView.rechangeBottom=^(){
        [weakSelf rechangeBottom];
    };
    bottomView.addDanmu=^(UIButton *btn){
        [weakSelf addDanmuView:(btn)];
    };
    [self addSubview: bottomView];
}
#pragma mark 添加弹幕
- (void)addDanmuView:(UIButton *)btn
{
    isOpen=!isOpen;
    if (isOpen==YES) {
        if (!kDanmuView) {
            kDanmuView = [[KSBarrageView alloc] initWithFrame:CGRectMake(0, 0,self.width, self.height-60)];
            [self addSubview:kDanmuView];
            //设置弹幕内容
            NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"djsflkjoiwene",@"content", nil];
            NSDictionary *dict2=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"1212341",@"content", nil];
            NSDictionary *dict3=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"大家好啊啊啊啊啊啊啊啊啊啊啊啊啊",@"content", nil];
            NSDictionary *dict4=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"1212341",@"content", nil];
            NSDictionary *dict5=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"2342sdfsjhd束带结发哈斯",@"content", nil];
            kDanmuView.dataArray=[NSArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5, nil];
            [kDanmuView setDanmuFont:10];
            [kDanmuView setDanmuAlpha:0.5];
        }
        [kDanmuView start];
    }else{
        [kDanmuView stop];
    }
}
#pragma mark 修改bottom 的位置
- (void)changeBottom:(UITextField *)textField
{
    bottomView.alpha=1.0;
    bottomView.frame=CGRectMake(0, self.height/2-78, self.width, 40);
    
}
- (void)rechangeBottom
{
    if (_playState==KSYPopularLivePlay) {
        [bottomView.commentText resignFirstResponder];
        bottomView.frame=CGRectMake(0, self.height-40, self.width, 40);
        bottomView.alpha=0.6;
    }
}
#pragma mark 添加亮度视图
- (void)addBrightnessVIew
{
    WeakSelf(KSYVideoPlayerView);
    kBrightnessView=[[KSYBrightnessView alloc]initWithFrame:CGRectMake(kCoverBarLeftMargin, THESCREENWIDTH / 4, kCoverBarWidth, THESCREENWIDTH / 2)];
    kBrightnessView.brightDidBegin=^(UISlider *slider){
        [weakSelf brightnessDidBegin:slider];
    };
    kBrightnessView.brightChanged=^(UISlider *slider){
        [weakSelf brightnessChanged:slider];
    };
    kBrightnessView.brightChangeEnd=^(UISlider *slider){
        [weakSelf brightnessChangeEnd:slider];
    };
    kBrightnessView.hidden=YES;
    [self addSubview:kBrightnessView];
}
#pragma mark 添加声音视图
- (void)addVoiceView
{
    kVoiceView=[[KSYVoiceView alloc]initWithFrame:CGRectMake(THESCREENHEIGHT - kCoverBarWidth - kCoverBarRightMargin, THESCREENWIDTH / 4, kCoverBarWidth, THESCREENWIDTH / 2)];
    kVoiceView.hidden=YES;
    [self addSubview:kVoiceView];
}
#pragma mark -亮度调节
- (void)brightnessDidBegin:(UISlider *)slider {
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
}
- (void)brightnessChanged:(UISlider *)slider {
    [[UIScreen mainScreen] setBrightness:slider.value];
}
- (void)brightnessChangeEnd:(UISlider *)slider {
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
}

#pragma mark -滚动条
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
-(void)Fullclick:(UIButton *)btn
{
    _fullScreenModeToggled=!_fullScreenModeToggled;
    if (_fullScreenModeToggled) {
        [self changeDeviceOrientation:UIInterfaceOrientationLandscapeRight];
        [self lunchFullScreen];
        UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_exit_fullscreen_normal"];
        [btn setImage:fullImg forState:UIControlStateNormal];
    }else{
        [self changeDeviceOrientation:UIInterfaceOrientationPortrait];
        [self minFullScreen];
        UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
        [btn setImage:fullImg forState:UIControlStateNormal];
    }
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
- (void)lockBtn:(UIButton *)btn
{
    isLock=!isLock;
    if (isLock==YES) {
        kBrightnessView.hidden=YES;
        kVoiceView.hidden=YES;
        bottomView.hidden=YES;
        kToolView.hidden=YES;
        UIImage *lockCloseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_close_normal"];
        UIImage *lockCloseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_close_hl"];
        [btn setImage:lockCloseImg_n forState:UIControlStateNormal];
        [btn setImage:lockCloseImg_h forState:UIControlStateHighlighted];
    }
    else{
        kBrightnessView.hidden=NO;
        kVoiceView.hidden=NO;
        bottomView.hidden=NO;
        kToolView.hidden=NO;
        UIImage *lockOpenImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_normal"];
        UIImage *lockOpenImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_hl"];
        [btn setImage:lockOpenImg_n forState:UIControlStateNormal];
        [btn setImage:lockOpenImg_h forState:UIControlStateHighlighted];

    }
}
- (void)showSetView:(UIButton *)btn
{
    [self addSetView];
    kSetView.hidden=NO;
    [self hiddenAllControls];
    
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
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        UIDeviceOrientation  orientation=[[UIDevice currentDevice] orientation];
        if (orientation == UIDeviceOrientationLandscapeRight) {
            if (!KSYSYS_OS_IOS8) {
                [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
            else {
            }
        }
        else {
            if (!KSYSYS_OS_IOS8) {
                [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
                
            }
            else {
            }
        }
        if (self.changeNavigationBarColor) {
            self.changeNavigationBarColor();
        }
        [self lunchFullScreen];
    }
    else if (orientation == UIDeviceOrientationPortrait)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        [self minFullScreen];
    }
}

#pragma mark 全屏模式
- (void)lunchFullScreen
{
    self.frame=[UIScreen mainScreen].bounds;
    //设置播放器视图的中心点
    [self.player.view setCenter:CGPointMake(self.width/2, self.height/2)];
    //设置为全屏
    self.player.view.frame = CGRectMake(0, 0,self.width , self.height);
    topView.hidden=YES;
    bottomView.hidden=YES;
    self.detailView.hidden=YES;
    self.commtenView.hidden=YES;
    bottomView.frame=CGRectMake(0, self.height-40, self.width, 40);
    [bottomView setSubviews];
    kProgressView.frame=CGRectMake((self.width - kProgressViewWidth) / 2, (self.height - 50) / 2, kProgressViewWidth, 50);
    kLockView.frame=CGRectMake(kCoverLockViewLeftMargin, (self.height - self.height / 6) / 2, self.height / 6, self.height / 6);
    [self addSubview:self.kToolView];
    UIButton *fullBtn=(UIButton *)[self viewWithTag:kFullScreenBtnTag];
    UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_exit_fullscreen_normal"];
    [fullBtn setImage:fullImg forState:UIControlStateNormal];
    self.indicator.center=CGPointMake(self.width/2, self.height/2);
}

#pragma mark 窗口最小化 动手去做
- (void)minFullScreen
{
    self.frame=self.kPreviousSelfFrame;
    //设置播放器视图的中心点
    [self.indicator setCenter:CGPointMake(self.width/2, (self.height)/4)];
    //设置为全屏
    self.player.view.frame = CGRectMake(0, 0,self.width, (self.height)/2);
    self.detailView.hidden=NO;
    self.commtenView.hidden=NO;
    kBrightnessView.hidden=YES;
    kVoiceView.hidden=YES;
    kLockView.hidden=YES;
    if (_playState==KSYPopularLivePlay) {
        bottomView.hidden=YES;
    }
    bottomView.frame=CGRectMake(0, self.height/2-40, self.width, 40);
    [bottomView resetSubviews];
    kProgressView.frame=CGRectMake((self.width - kProgressViewWidth) / 2, (self.height - 50) / 4, kProgressViewWidth, 50);
    kToolView.hidden=YES;
    UIButton *unFullBtn=(UIButton *)[self viewWithTag:kFullScreenBtnTag];
    UIImage *unFullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
    [unFullBtn setImage:unFullImg forState:UIControlStateNormal];
    self.indicator.center=CGPointMake(self.width/2, self.height/4);
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
#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
    _startPoint = [[touches anyObject] locationInView:self];
    _curPosition = progressSlider.value;
    _curBrightness = [[UIScreen mainScreen] brightness];
    _curVoice = [MPMusicPlayerController applicationMusicPlayer].volume;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // **** 锁屏状态下，屏幕禁用
    if (isLock == YES) {
        return;
    }
    CGPoint curPoint = [[touches anyObject] locationInView: self];
    CGFloat deltaX = curPoint.x -  self.startPoint.x;
    CGFloat deltaY = curPoint.y -  self.startPoint.y;
    CGFloat totalWidth =  self.width;
    CGFloat totalHeight =  self.height;
//    if (totalHeight == [[UIScreen mainScreen] bounds].size.height) {//竖屏
//        totalWidth =  self.height;
//        totalHeight =  self.width;
//    }
    NSInteger duration = (NSInteger)self.player.duration;
    //    NSLog(@"durationnnnn is %@",@(duration));
    
    if (fabs(deltaX) < fabs(deltaY)) {
        // **** 亮度
        if ((curPoint.x < totalWidth / 2) && ( self.gestureType == kKSYUnknown ||  self.gestureType == kKSYBrightness)) {
            CGFloat deltaBright = deltaY / totalHeight * 1.0;
            [[UIScreen mainScreen] setBrightness: _curBrightness - deltaBright];
            UISlider *brightnessSlider = (UISlider *)[self viewWithTag:kBrightnessSliderTag];
            [brightnessSlider setValue: _curBrightness - deltaBright animated:NO];
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
            UIView *brightnessView = [self viewWithTag:kBrightnessViewTag];
            brightnessView.alpha = 1.0;
            self.gestureType = kKSYBrightness;
        }
        // **** 声音
        else if ((curPoint.x > totalWidth / 2) && ( self.gestureType == kKSYUnknown ||  self.gestureType == kKSYVoice)) {
            CGFloat deltaVoice = deltaY / totalHeight * 1.0;
            MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            CGFloat voiceValue =  _curVoice - deltaVoice;
            if (voiceValue < 0) {
                voiceValue = 0;
            }
            else if (voiceValue > 1) {
                voiceValue = 1;
            }
            [musicPlayer setVolume:voiceValue];
            MediaVoiceView *mediaVoiceView = (MediaVoiceView *)[self viewWithTag:kMediaVoiceViewTag];
            [mediaVoiceView setIVoice:voiceValue];
            self.gestureType = kKSYVoice;
        }
        return ;
    }
    else if ( self.gestureType == kKSYUnknown ||  self.gestureType == kKSYProgress) {
        
        if (fabs(deltaX) > fabs(deltaY)) {
            if(_playState==KSYPopularLivePlay){
                return;
            }
            self.gestureType = kKSYProgress;
            
            [self performSelector:@selector(showORhideProgressView:) withObject:@NO];
            CGFloat deltaProgress = deltaX / totalWidth * duration;
            UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
            UIView *progressView = [self viewWithTag:kProgressViewTag];
            UILabel *progressViewCurLabel = (UILabel *)[self viewWithTag:kCurProgressLabelTag];
            UIImageView *wardImageView = (UIImageView *)[self viewWithTag:kWardMarkImgViewTag];
            UILabel *startLabel = (UILabel *)[self viewWithTag:kProgressCurLabelTag];
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
            int iMin2  = ((int)fabs(deltaProgress) / 60);
            int iSec2  = ((int)fabs(deltaProgress) % 60);
            NSString *strCurTime1 = [NSString stringWithFormat:@"%02d:%02d", iMin1, iSec1];
            NSString *strCurTime2 = [NSString stringWithFormat:@"%02d:%02d", iMin2, iSec2];
            startLabel.text = strCurTime1;
            if (deltaX > 0) {
                strCurTime2 = [@"+" stringByAppendingString:strCurTime2];
                UIImage *forwardImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_forward_normal"];
                wardImageView.frame = CGRectMake(progressView.frame.size.width - 30, 15, 20, 20);
                wardImageView.image = forwardImg;
            }
            else {
                strCurTime2 = [@"-" stringByAppendingString:strCurTime2];
                UIImage *backwardImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_backward_normal"];
                wardImageView.frame = CGRectMake(10, 15, 20, 20);
                wardImageView.image = backwardImg;
            }
            progressViewCurLabel.text = strCurTime2;
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.gestureType == kKSYUnknown) { // **** tap 动作
        if (isActive == YES) {
            [self hiddenAllControls];
            kSetView.hidden=YES;
//            UITableView *epsTableView=(UITableView *)[self viewWithTag:kEpisodeTableViewTag];
//            epsTableView.hidden=YES;
//            UIView *commentView=[self viewWithTag:kCommentViewTag];
//            commentView.hidden=YES;
//            UITextField *commentField=(UITextField *)[self viewWithTag:kCommentFieldTag];
//            [commentField resignFirstResponder];
            [self rechangeBottom];
            
        }
        else {
            [self showAllControls];
            kSetView.hidden=YES;
        }
    }
    else if (self.gestureType == kKSYProgress) {
        
        UISlider *progressSlider = (UISlider *)[self viewWithTag:kProgressSliderTag];
        
        [self.player setCurrentPlaybackTime: progressSlider.value];
        
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
    }
    else if (self.gestureType == kKSYBrightness) {
        UISlider *brightnessSlider = (UISlider *)[self viewWithTag:kBrightnessSliderTag];
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
        if (isActive == NO) {
            UIView *brightnessView = [self viewWithTag:kBrightnessViewTag];
            [UIView animateWithDuration:0.3 animations:^{
                brightnessView.alpha = 0.0f;
            }];
        }
    }
    self.gestureType = kKSYUnknown;
}


#pragma mark 显示控件
- (void) showAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
//            获得的当前设备方向
            if (self.width<THESCREENHEIGHT) {//证明是竖直方向
                if (_playState==KSYPopularLivePlay) {
                    topView.hidden=YES;
                    bottomView.hidden=YES;
                }
                else{
                    topView.hidden=NO;
                    bottomView.hidden=NO;
                }
                kBrightnessView.hidden=YES;
                kVoiceView.hidden=YES;
                kLockView.hidden=YES;
                kToolView.hidden=YES;
            }else{
                if (isLock==NO) {
                    bottomView.hidden=NO;
                    kBrightnessView.hidden=NO;
                    kVoiceView.hidden=NO;
                    kToolView.hidden=NO;
                }
                kLockView.hidden=NO;
            }
    } completion:^(BOOL finished) {
        isActive = YES;
    }];
}
#pragma mark 隐藏控件
- (void) hiddenAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        if (isLock==NO) {
            topView.hidden=YES;
            bottomView.hidden=YES;
            kBrightnessView.hidden=YES;
            kVoiceView.hidden=YES;
            kToolView.hidden=YES;
        }
        kLockView.hidden=YES;
    } completion:^(BOOL finished) {
        isActive = NO;
    }];
    
    
}
- (void)showORhideProgressView:(NSNumber *)bShowORHide {
    UIView *progressView = [self viewWithTag:kProgressViewTag];
    progressView.hidden = bShowORHide.boolValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideProgressView) object:nil];
    if (!bShowORHide.boolValue) {
        [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:1];
    }
}

- (void)hideProgressView {
    UIView *progressView = [self viewWithTag:kProgressViewTag];
    progressView.hidden = YES;
}

@end
