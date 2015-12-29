//
//  KSYVideoOnDemandPlayVC.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYVideoOnDemandPlayVC.h"
#import "MediaControlViewController.h"
#import "MediaControlView.h"
#import "KSBarrageView.h"
#import "MediaControlDefine.h"
#import "KSYDefine.h"
#import "SJSnapeView.h"
#import "SJNoticeView.h"
#import "SJDetailView.h"
#import "AppDelegate.h"
@interface KSYVideoOnDemandPlayVC ()
@property (nonatomic, strong) KSYBasePlayView *phoneLivePlayVC;
@end

@implementation KSYVideoOnDemandPlayVC{
    //这个控制器调用AMZPlayer的接口
    MediaControlViewController *_mediaControlViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置导航栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //修改导航栏模式
    [self changeNavigationStayle];
    
    _isCycleplay = NO;
    _beforeOrientation = UIDeviceOrientationPortrait;
    _pauseInBackground = YES;
    _motionInterfaceOrientation = UIInterfaceOrientationMaskLandscape;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initPlayerWithLowTimelagType:NO];
    [self addDetailPart];
    [self performSelector:@selector(refreshControl) withObject:nil afterDelay:1.0];
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    appDelegate.allowRotation=YES;
}
#pragma mark 改变导航栏状态
- (void)changeNavigationStayle
{
    //设置返回按钮
    UIButton *ksyBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ksyBackBtn.frame=CGRectMake(5, 5, 40, 30);
    [ksyBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [ksyBackBtn setTitleColor:KSYCOLER(52, 211, 220) forState:UIControlStateNormal];
    ksyBackBtn.titleLabel.font=[UIFont systemFontOfSize:WORDFONT16];
    [ksyBackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:ksyBackBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    //添加标题标签
    UILabel *ksyTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    ksyTitleLabel.text=@"视频标题";
    ksyTitleLabel.textColor=[UIColor whiteColor];
    ksyTitleLabel.textAlignment=NSTextAlignmentCenter;
    ksyTitleLabel.font=[UIFont systemFontOfSize:WORDFONT18];
    ksyTitleLabel.center=self.navigationItem.titleView.center;
    self.navigationItem.titleView = ksyTitleLabel;
    
    
    //添加选项按钮
    UIButton *ksyMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ksyMenuBtn.frame=CGRectMake(self.view.right-45, 5, 40, 30);
    [ksyMenuBtn setTitle:@"选项" forState:UIControlStateNormal];
    [ksyMenuBtn setTitleColor:KSYCOLER(52, 211, 220) forState:UIControlStateNormal];
    ksyMenuBtn.titleLabel.font=[UIFont systemFontOfSize:WORDFONT16];
    [ksyMenuBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:ksyMenuBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

#pragma mark 初始化低延时模式
- (void)initPlayerWithLowTimelagType:(BOOL)isLowTimeType {
    
    _phoneLivePlayVC = [[KSYBasePlayView alloc] initWithFrame:CGRectMake(0,64,self.view.width,(self.view.bottom-64)/2) urlString:_videoPath];
    [self.view addSubview:_phoneLivePlayVC];

    //设置播放器播放视图的大小
    //初始化控制器（这个控制器用来调用AMZPlayer的接口）
    _mediaControlViewController = [[MediaControlViewController alloc] init];
    _mediaControlViewController.delegate = self;
    _mediaControlViewController.view.frame=_phoneLivePlayVC.bounds;
    [_phoneLivePlayVC addSubview:_mediaControlViewController.view];
    [_phoneLivePlayVC.player setScalingMode:MPMovieScalingModeAspectFit];
    
    //注册其他通知
    [self registerApplicationObservers];
}

#pragma mark 添加下面的内容
- (void)addDetailPart
{
    CGFloat backgroundViewX=0;
    CGFloat backgroundViewY=_phoneLivePlayVC.bottom+10;
    CGFloat backgroundVieWidth=THESCREENWIDTH;
    CGFloat backgroundViewHeight=_phoneLivePlayVC.width;
    CGRect backgroundViewRect=CGRectMake(backgroundViewX, backgroundViewY, backgroundVieWidth, backgroundViewHeight);
    //在这里初始化
    SJDetailView *detailView=[[SJDetailView alloc]initWithFrame:backgroundViewRect];
    detailView.tag=kDetailViewTag;
    [self.view addSubview:detailView];
}
- (void)registerApplicationObservers
{
    //添加通知设备方向改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
/**
 *  移除通知
 */
- (void)unregisterApplicationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait)
    {
        self.deviceOrientation = orientation;
        [self minimizeVideo];
        SJDetailView *detailView=(SJDetailView *)[self.view viewWithTag:kDetailViewTag];
        detailView.hidden=NO;
        [self FullBtnImage];
        
    }
    else if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
    {
        self.deviceOrientation = orientation;
        [self launchFullScreen];
        SJDetailView *detailView=(SJDetailView *)[self.view viewWithTag:kDetailViewTag];
        detailView.hidden=YES;
        [self unFullBtnImage];
    }
}
#pragma mark 全屏显示
- (void)launchFullScreen
{
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
    self.navigationController.navigationBar.hidden=YES;
    //设置播放器视图的中心点
    [_phoneLivePlayVC setCenter:CGPointMake(self.view.width/2, self.view.height/2)];
    //设置为全屏
    _phoneLivePlayVC.bounds = CGRectMake(0, 0,self.view.width , self.view.height);
    MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
    mediaControlView.center =_phoneLivePlayVC.center;
    mediaControlView.bounds =_phoneLivePlayVC.bounds;
    [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
}
#pragma mark 窗口最小化
- (void)minimizeVideo
{
    //导航栏不隐藏
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    _phoneLivePlayVC.frame = CGRectMake(0,64,self.view.width,(self.view.bottom-64)/2);
    MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
    mediaControlView.frame = _phoneLivePlayVC.bounds;
    [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
}


- (void)getVideoState
{
    //    //NSLog(@"[_player state] = = =%d",[_player state]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KSYMediaPlayDelegate
- (void)play {
    //在这里进行判断
    if (_phoneLivePlayVC.player.isPreparedToPlay)
    {
        [_phoneLivePlayVC.player play];
    }
}

- (void)pause {
    if ([_phoneLivePlayVC.player isPlaying]==YES)
    {
         [_phoneLivePlayVC pause];
    }
   
}

- (void)stop {
    if ([_phoneLivePlayVC.player isPlaying]==YES)
    {
        [_phoneLivePlayVC stop];
    }
}

- (BOOL)isPlaying {
    return [_phoneLivePlayVC.player isPlaying];
}

- (void)shutdown {
    [_phoneLivePlayVC stop];
}

- (void)seekProgress:(CGFloat)position {
    [_phoneLivePlayVC moviePlayerSeekTo:position];
}

- (void)setVideoQuality:(KSYVideoQuality)videoQuality {
    //NSLog(@"set video quality");
}

- (void)setVideoScale:(KSYVideoScale)videoScale {
    CGRect videoRect = self.view.frame;
    NSInteger scaleW = 16;
    NSInteger scaleH = 9;
    switch (videoScale) {
        case kKSYVideo16W9H:
            scaleW = 16;
            scaleH = 9;
            break;
        case kKSYVideo4W3H:
            scaleW = 4;
            scaleH = 3;
            break;
        default:
            break;
    }
    if (videoRect.size.height >= videoRect.size.width * scaleW / scaleH) {
        videoRect.origin.x = 0;
        videoRect.origin.y = (videoRect.size.height - videoRect.size.width * scaleW / scaleH) / 2;
        videoRect.size.height = videoRect.size.width * scaleW / scaleH;
        
    }
    else {
        videoRect.origin.x = (videoRect.size.height - videoRect.size.height * scaleH / scaleW) / 2;
        videoRect.origin.y = 0;
        videoRect.size.width = videoRect.size.width * scaleH / scaleW;

    }
    _phoneLivePlayVC.frame = videoRect;
}

- (void)setAudioAmplify:(CGFloat)amplify {
//    [_player setAudioAmplify:amplify];
}

- (void)setCycleplay:(BOOL)isCycleplay {
    
}
#pragma mark 点击全屏按钮
- (void)clickFullBtn{
    
    _fullScreenModeToggled=!_fullScreenModeToggled;
    if (_fullScreenModeToggled) {
        [self changeDeviceOrientation:UIInterfaceOrientationLandscapeRight];
        [self launchFullScreen];
        [self unFullBtnImage];
    }else{
        [self changeDeviceOrientation:UIInterfaceOrientationPortrait];
        [self minimizeVideo];
        [self FullBtnImage];
    }
}
#pragma mark changeFullBtn
- (void)FullBtnImage
{
    UIButton *fullBtn=(UIButton *)[self.view viewWithTag:kFullScreenBtnTag];
    UIImage *unFullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
    [fullBtn setImage:unFullImg forState:UIControlStateNormal];
}
- (void)unFullBtnImage
{
    UIButton *fullBtn=(UIButton *)[self.view viewWithTag:kFullScreenBtnTag];
    UIImage *unFullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_exit_fullscreen_normal"];
    [fullBtn setImage:unFullImg forState:UIControlStateNormal];
}
#pragma mark 手动设置设备方向
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

- (void)refreshControl {
        UILabel *startLabel = (UILabel *)[self.view viewWithTag:kProgressCurLabelTag];
        UILabel *endLabel = (UILabel *)[self.view viewWithTag:kProgressMaxLabelTag];
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
    
        NSInteger duration =  _phoneLivePlayVC.player.duration;
        NSLog(@"duration is %@",@(duration));
    
        NSInteger position = _phoneLivePlayVC.player.currentPlaybackTime;
        NSLog(@"position is %@",@(position));
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        startLabel.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
        if (!_isRtmp) {
            int iDuraMin  = (int)(duration / 60);
            int iDuraSec  = (int)(duration % 3600 % 60);
            endLabel.text = [NSString stringWithFormat:@"/%02d:%02d", iDuraMin, iDuraSec];
            progressSlider.value = position;
            progressSlider.maximumValue = duration;
        }
        else {
            endLabel.text = @"--:--";
            progressSlider.value = 0.0f;
            progressSlider.maximumValue = 1.0f;
        }
        if ([_phoneLivePlayVC.player isPlaying]==YES) {
            [self performSelector:@selector(refreshControl) withObject:nil afterDelay:1.0];
        }
    
}

- (void)progressDidBegin:(id)sender
{
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [sender setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        if ([_phoneLivePlayVC.player isPlaying] == YES) {
//            _isActive = NO;
//            [_phoneLivePlayVC.player pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
    }
}
- (void)progressChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
//    if (!_phoneLivePlayVC.player.isPlaying) {
//        progressSlider.value=0.0;
//        return;
//    }
        NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
        if (duration > 0&&_isRtmp==NO) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
            UILabel *startLabel = (UILabel *)[self.view viewWithTag:kProgressCurLabelTag];
    
            if ([_phoneLivePlayVC.player isPlaying] == YES) {
//                _isActive = NO;
//                [_phoneLivePlayVC.player pause];
                UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
                UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
                [btn setImage:playImg forState:UIControlStateNormal];
            }
            NSInteger position = slider.value;
            int iMin  = (int)(position / 60);
            int iSec  = (int)(position % 60);
            NSString *strCurTime = [NSString stringWithFormat:@"%02d:%02d/", iMin, iSec];
            startLabel.text = strCurTime;
        }
        else {
            slider.value = 0.0f;
            [self showNotice:@"直播不支持拖拽"];
        }
}
#pragma mark 显示提示
- (void)showNotice:(NSString *)strNotice {
    static BOOL isShowing = NO;
    if (isShowing == NO) {
        
        SJNoticeView *noticeView=[[SJNoticeView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        noticeView.center = CGPointMake(_phoneLivePlayVC.size.width/2, _phoneLivePlayVC.size.height/2);
        noticeView.noticeLabel.text=strNotice;
        [_phoneLivePlayVC addSubview:noticeView];
        
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
            isShowing = NO;
        }];
    }
}

- (void)progressChangeEnd:(id)sender {
   UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
        NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
        if (duration > 0&&_isRtmp==NO) {
            [self seekProgress:slider.value];
        }
        else {
            slider.value = 0.0f;
            [self showNotice:@"直播不支持拖拽"];
        }
}
#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
        _mediaControlViewController.startPoint = [[touches anyObject] locationInView:_mediaControlViewController.view];
        _mediaControlViewController.curPosition = progressSlider.value;
        _mediaControlViewController.curBrightness = [[UIScreen mainScreen] brightness];
        _mediaControlViewController.curVoice = [MPMusicPlayerController applicationMusicPlayer].volume;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // **** 锁屏状态下，屏幕禁用
    if ( _mediaControlViewController.isLocked == YES) {
        return;
    }
    CGPoint curPoint = [[touches anyObject] locationInView: _mediaControlViewController.view];
    CGFloat deltaX = curPoint.x -  _mediaControlViewController.startPoint.x;
    CGFloat deltaY = curPoint.y -  _mediaControlViewController.startPoint.y;
    CGFloat totalWidth =  self.view.frame.size.width;
    CGFloat totalHeight =  self.view.frame.size.height;
    if (totalHeight == [[UIScreen mainScreen] bounds].size.height) {
        totalWidth =  self.view.frame.size.height;
        totalHeight =  self.view.frame.size.width;
    }
        NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
    //    NSLog(@"durationnnnn is %@",@(duration));
    
    if (fabs(deltaX) < fabs(deltaY)) {
        // **** 亮度
        if ((curPoint.x < totalWidth / 2) && ( _mediaControlViewController.gestureType == kKSYUnknown ||  _mediaControlViewController.gestureType == kKSYBrightness)) {
            CGFloat deltaBright = deltaY / totalHeight * 1.0;
            [[UIScreen mainScreen] setBrightness: _mediaControlViewController.curBrightness - deltaBright];
            UISlider *brightnessSlider = (UISlider *)[self.view viewWithTag:kBrightnessSliderTag];
            [brightnessSlider setValue: _mediaControlViewController.curBrightness - deltaBright animated:NO];
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
            UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
            brightnessView.alpha = 1.0;
             _mediaControlViewController.gestureType = kKSYBrightness;
        }
        // **** 声音
        else if ((curPoint.x > totalWidth / 2) && ( _mediaControlViewController.gestureType == kKSYUnknown ||  _mediaControlViewController.gestureType == kKSYVoice)) {
            CGFloat deltaVoice = deltaY / totalHeight * 1.0;
            MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            CGFloat voiceValue =  _mediaControlViewController.curVoice - deltaVoice;
            if (voiceValue < 0) {
                voiceValue = 0;
            }
            else if (voiceValue > 1) {
                voiceValue = 1;
            }
            [musicPlayer setVolume:voiceValue];
            MediaVoiceView *mediaVoiceView = (MediaVoiceView *)[self.view viewWithTag:kMediaVoiceViewTag];
            [mediaVoiceView setIVoice:voiceValue];
             _mediaControlViewController.gestureType = kKSYVoice;
        }
        return ;
    }
        else if (_isRtmp==NO&&duration > 0 && ( _mediaControlViewController.gestureType == kKSYUnknown ||  _mediaControlViewController.gestureType == kKSYProgress)) {
    
            
            if (fabs(deltaX) > fabs(deltaY)) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
                if ([_phoneLivePlayVC.player isPlaying] == YES) {
//                    [_mediaControlViewController clickPlayBtn:nil]; // **** 拖拽进度时，暂停播放
                }
                _mediaControlViewController.gestureType = kKSYProgress;
    
//                [self performSelector:@selector(showORhideProgressView:) withObject:@NO];
                CGFloat deltaProgress = deltaX / totalWidth * duration;
                UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
                UIView *progressView = [self.view viewWithTag:kProgressViewTag];
                UILabel *progressViewCurLabel = (UILabel *)[self.view viewWithTag:kCurProgressLabelTag];
                UIImageView *wardImageView = (UIImageView *)[self.view viewWithTag:kWardMarkImgViewTag];
                UILabel *startLabel = (UILabel *)[self.view viewWithTag:kProgressCurLabelTag];
                NSInteger position = _mediaControlViewController.curPosition + deltaProgress;
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
                NSString *strCurTime1 = [NSString stringWithFormat:@"%02d:%02d/", iMin1, iSec1];
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
        else if (_isRtmp==YES && (_mediaControlViewController.gestureType == kKSYUnknown || _mediaControlViewController.gestureType == kKSYProgress)) {
            if (![_phoneLivePlayVC.player isPreparedToPlay]) {
                return;
            }
            NSLog(@"durationnnnn is %@",@(duration));
    
            [self showNotice:@"直播不支持拖拽"];
        }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mediaControlViewController.gestureType == kKSYUnknown) { // **** tap 动作
        if (_mediaControlViewController.isActive == YES) {
            [_mediaControlViewController hideAllControls];
            UITableView *epsTableView=(UITableView *)[self.view viewWithTag:kEpisodeTableViewTag];
            epsTableView.hidden=YES;
            UIView *commentView=[self.view viewWithTag:kCommentViewTag];
            commentView.hidden=YES;
            UITextField *commentField=(UITextField *)[self.view viewWithTag:kCommentFieldTag];
            [commentField resignFirstResponder];
        }
        else {
            [_mediaControlViewController showAllControls];
            UIView *setView=[self.view viewWithTag:kSetViewTag];
            setView.hidden=YES;
        }
    }
    else if (_mediaControlViewController.gestureType == kKSYProgress) {
        
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
        
        [self seekProgress:progressSlider.value];
        
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
    }
    else if (_mediaControlViewController.gestureType == kKSYBrightness) {
        UISlider *brightnessSlider = (UISlider *)[self.view viewWithTag:kBrightnessSliderTag];
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
//        if (_isActive == NO) {
//            UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
//            [UIView animateWithDuration:0.3 animations:^{
//                brightnessView.alpha = 0.0f;
//            }];
//        }
    }
    _mediaControlViewController.gestureType = kKSYUnknown;
}

- (void)clickSnapBtn:(id)sender
{
    UIImage *snapImage = [_phoneLivePlayVC.player thumbnailImageAtCurrentTime];
    UIImageWriteToSavedPhotosAlbum(snapImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - Snap delegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        CGRect noticeRect = CGRectMake(0, 0, 100, 100);
        SJSnapeView *noticeView = [[SJSnapeView alloc] initWithFrame:noticeRect];
        noticeView.center = _phoneLivePlayVC.center;
        [_phoneLivePlayVC addSubview:noticeView];
        // **** dismiss
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
        }];
    }
}


#pragma mark 转到另一个控制器
-(void)back
{
    [_phoneLivePlayVC.player stop];
    [self.navigationController popViewControllerAnimated:YES];
    //修改状态栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
}

#pragma mark  菜单按钮
- (void)menu
{
    
}

- (void)dealloc
{
    [self unregisterApplicationObservers];

    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation=NO;

}




@end
