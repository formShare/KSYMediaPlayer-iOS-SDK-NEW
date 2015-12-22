//
//  MediaControlViewController.m
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/18.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

#import "MediaControlViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MediaControlView.h"
#import "MediaControlDefine.h"
#import "ThemeManager.h"
#import "MediaVoiceView.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "KSBarrageView.h"

@interface MediaControlViewController (){
    
    MediaControlView *mediaControlView;
    BOOL _isKSYPlayerPling;
    UIActivityIndicatorView *_indicatorView;
    UILabel *_indicatorLabel;
    BOOL _isPrepared;
    KSYVideoQuality _curVideoQuality;
    KSYVideoScale _curVideoScale;
    
    CGFloat _minCPU, _maxCPU;
    CGFloat _minMem, _maxMem;
    NSTimer *_timer;
    BOOL     _isEnd;
    KSBarrageView *_barrageView;
    BOOL fullScreenModeToggled;
}

@end

@implementation MediaControlViewController
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
    
    _isEnd = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // **** player delegate
    
    _isEnd = NO;
    _isActive = YES;
    _isCompleted = NO;
    _isLocked = NO;
    _audioAmplify = 1;
    _gestureType = kKSYUnknown;
    _curVideoQuality = kKSYVideoNormal;
    _curVideoScale = kKSYVideo16W9H;
    fullScreenModeToggled=NO;
    
    _minCPU = 999, _maxCPU = 0;
    _minMem = 999, _maxMem = 0;
    
    // **** 主题包管理
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    //    [themeManager changeTheme:@"blue"];
    //    [themeManager changeTheme:@"green"];
    //    [themeManager changeTheme:@"orange"];
    //    [themeManager changeTheme:@"pink"];
    [themeManager changeTheme:@"red"];

    CGRect mediaControlRect = CGRectMake(0,64,self.view.width,(self.view.bottom-64)/2);
    mediaControlView = [[MediaControlView alloc] initWithFrame:mediaControlRect];
    self.view = mediaControlView;
    mediaControlView.controller = self;
    
    [self performSelector:@selector(hideAllControls) withObject:nil afterDelay:3.0];
    [self refreshControl];
    
    UIButton *playBtn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
    UIImage *playImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIImage *playImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_hl"];
    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
//    if (!player.shouldAutoplay) {
//        [playBtn setImage:playImg_n forState:UIControlStateNormal];
//        [playBtn setImage:playImg_h forState:UIControlStateHighlighted];
//        
//    }else{
//        [playBtn setImage:pauseImg_n forState:UIControlStateNormal];
//        [playBtn setImage:pauseImg_h forState:UIControlStateNormal];
//    }
    
    //    [self clickFullBtn:nil];
    
    // **** 水印
    //    NSString *strFileName = [[[(VideoViewController *)_delegate videoUrl] absoluteString] lastPathComponent];
    //    if ([strFileName isEqualToString:@"Phone-h265.480p.20Min.300K.mp4"] == YES) {
    //        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 240, 31)];
    //        UIImage *img = [UIImage imageNamed:@"phone-h265.480p.300kbps.png"];
    //        imgView.image = img;
    //        [self.view addSubview:imgView];
    //    }
    //    if ([strFileName isEqualToString:@"Pad-h265.720p.20Min.1M.mp4"] == YES) {
    //        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 175, 240, 31)];
    //        UIImage *img = [UIImage imageNamed:@"ipad-h265.720p.1Mbps.png"];
    //        imgView.image = img;
    //        [self.view addSubview:imgView];
    //    }
    
    // **** timer
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showSysInfo) userInfo:nil repeats:YES];
//    if (!player.shouldAutoplay) {
//        [playBtn setImage:playImg_n forState:UIControlStateNormal];
//        [playBtn setImage:playImg_h forState:UIControlStateHighlighted];
//        
//    }else{
//        [playBtn setImage:pauseImg_n forState:UIControlStateNormal];
//        [playBtn setImage:pauseImg_h forState:UIControlStateNormal];
//    }

}

- (void)showSysInfo {
    double usedMemoryofApp = [self usedMemory];
    float cpu_usage = [self cpu_usage];
    
    if (cpu_usage > _maxCPU) {
        _maxCPU = cpu_usage;
    }
    else if (cpu_usage < _minCPU) {
        _minCPU = cpu_usage;
    }
    
    if (usedMemoryofApp > _maxMem) {
        _maxMem = usedMemoryofApp;
    }
    else if (usedMemoryofApp < _minMem) {
        _minMem = usedMemoryofApp;
    }
    
    UILabel *cpuLabel = (UILabel *)[self.view viewWithTag:kCPULabel];
    UILabel *memLabel = (UILabel *)[self.view viewWithTag:kMemLabel];
    cpuLabel.text = [NSString stringWithFormat:@"CPU: %ld%%", (long)cpu_usage];
    memLabel.text = [NSString stringWithFormat:@"Mem: %.1f MB", usedMemoryofApp]; // **** 15: 临时的偏移量
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshControl {
    if ([_delegate respondsToSelector:@selector(refreshControl)]==YES)
    {
        [_delegate refreshControl];
    }
}
#pragma mark 点击弹幕按钮
- (void)clickDanmuBtn:(id)sender
{
    _isOpened=!_isOpened;
    UIButton *danmuBtn=(UIButton *)sender;
    UIColor *tintColor=[[ThemeManager sharedInstance] themeColor];
    danmuBtn.layer.borderColor=tintColor.CGColor;
    [danmuBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    if (_isOpened==YES)
    {
        [self performSelector:@selector(addDanmu) withObject:nil afterDelay:0.1];
        [danmuBtn setTitle:@"弹幕开" forState:UIControlStateNormal];
    }
    else
    {
        [self performSelector:@selector(removeDanmu) withObject:nil afterDelay:0.1];
        [danmuBtn setTitle:@"弹幕关" forState:UIControlStateNormal];
    }
    
}
#pragma mark 添加弹幕(就是对自己身体的控制)
- (void)addDanmu
{
    _barrageView = [[KSBarrageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-60)];
    [self.view addSubview:_barrageView];
    //设置弹幕内容
    NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"djsflkjoiwene",@"content", nil];
    NSDictionary *dict2=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"1212341",@"content", nil];
    NSDictionary *dict3=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"大家好啊啊啊啊啊啊啊啊啊啊啊啊啊",@"content", nil];
    NSDictionary *dict4=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"1212341",@"content", nil];
    NSDictionary *dict5=[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Logo2"],@"avatar",@"2342sdfsjhd束带结发哈斯",@"content", nil];
    _barrageView.dataArray=[NSArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5, nil];
    [_barrageView setDanmuFont:10];
    [_barrageView setDanmuAlpha:0.5];
    //开始弹幕
    [_barrageView start];
}
#pragma mark 关闭弹幕
- (void)removeDanmu
{
    [_barrageView removeFromSuperview];
}
#pragma mark 点击评论按钮
-(void)clickCommentBtn:(id)sender
{
    UIButton *commentBtn=(UIButton *)sender;
    UIColor *tintColor=[[ThemeManager sharedInstance] themeColor];
    commentBtn.layer.borderColor=tintColor.CGColor;
    [commentBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    
    
    //获得评论视图
    UIView *commentView=[self.view viewWithTag:kCommentViewTag];
    UITextField *commentField=(UITextField *)[self.view viewWithTag:kCommentFieldTag];
    
    CGFloat commentViewX=0;
    CGFloat commentViewY=self.view.frame.size.height/2-70;
    CGFloat commentVierWidth=self.view.frame.size.width;
    CGFloat commentViewHeight=40;
    
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        commentView.frame=CGRectMake(commentViewX, commentViewY, commentVierWidth, commentViewHeight);
    } completion:^(BOOL finished) {
        NSLog(@"Animation end.");
    }];
    commentView.backgroundColor=[UIColor lightGrayColor];
    //重置commentFiled的位置和大小
    commentField.backgroundColor=[UIColor orangeColor];
    [commentField setFrame:CGRectMake(10, 0, CGRectGetWidth(commentView.frame)-80, CGRectGetHeight(commentView.frame))];
    [commentField becomeFirstResponder];
    //重置发送按钮的位置和大小
    UIButton *sendBtn=(UIButton *)[self.view viewWithTag:kSendBtnTag];
    [sendBtn setFrame:CGRectMake(CGRectGetMaxX(commentField.frame)+10, 0, 60,  CGRectGetHeight(commentView.frame))];
    [sendBtn setBackgroundColor:[UIColor greenColor]];
    [sendBtn addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    commentView.hidden=NO;
    
    //隐藏 锁屏 声音 亮度视图
    UIView *brightnessView=[self.view viewWithTag:kBrightnessViewTag];
    UIView *lockView=[self.view viewWithTag:kLockViewTag];
    UIView *voiceView=[self.view viewWithTag:kVoiceViewTag];
    brightnessView.hidden=YES;
    lockView.hidden=YES;
    voiceView.hidden=YES;
    
}
#pragma mark 发送按钮
- (void)clickSendBtn:(id)sender
{
    //将评论视图隐藏
    UIView *commentView=[self.view viewWithTag:kCommentViewTag];
    commentView.hidden=YES;
    UITextField *commentField=(UITextField *)[self.view viewWithTag:kCommentFieldTag];
    [commentField resignFirstResponder];
}
#pragma mark - Actions

- (void)clickPlayBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
    UIImage *paueImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    if ([_delegate respondsToSelector:@selector(isPlaying)] == YES) {
        if ([_delegate isPlaying] == NO && [_delegate respondsToSelector:@selector(play)] == YES) {
            [_delegate play];
            [btn setImage:paueImg forState:UIControlStateNormal];
        }
        else if ([_delegate isPlaying] == YES && [_delegate respondsToSelector:@selector(pause)] == YES) {
            [_delegate pause];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
    }
}

- (void)clickHighlightBtn:(id)sender {
    UIButton *qualityBtn = (UIButton *)sender;
    qualityBtn.layer.borderColor = [[ThemeManager sharedInstance] themeColor].CGColor;
}

- (void)clickNormalBtn:(id)sender {
    UIButton *qualityBtn = (UIButton *)sender;
    qualityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)showColor:(id)sender {
    UIButton *qualityBtn = (UIButton *)sender;
    qualityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)clickQualityBtn:(id)sender
{
    UIButton *qualityBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    qualityBtn.layer.borderColor = tintColor.CGColor;
    [qualityBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    if (qualityView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            qualityView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [qualityView removeFromSuperview];
        }];
        return ;
    }
    if (scaleView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            scaleView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [scaleView removeFromSuperview];
        }];
    }
    CGPoint btnLocation = [qualityBtn.superview convertPoint:qualityBtn.frame.origin toView:self.view];
    CGRect rect = CGRectMake(btnLocation.x - 5, btnLocation.y - 120, qualityBtn.frame.size.width + 10, 115);
    qualityView = [[UIView alloc] initWithFrame:rect];
    qualityView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:qualityView];
    qualityView.tag = kQualityViewTag;
    
    UIView *qualityBgView = [[UIView alloc] initWithFrame:qualityView.bounds];
    qualityBgView.backgroundColor = [UIColor blackColor];
    qualityBgView.alpha = 0.6;
    qualityBgView.layer.masksToBounds = YES;
    qualityBgView.layer.cornerRadius = 3;
    [qualityView addSubview:qualityBgView];
    NSArray *arrTitles = @[@"流畅", @"高清", @"超清"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arrTitles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(5, 5 + 35 * i, rect.size.width - 10, 30);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.tag = i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(adjustVideoQuality:) forControlEvents:UIControlEventTouchUpInside];
        [qualityView addSubview:btn];
        if (i == _curVideoQuality) {
            UIColor *themeColor = [[ThemeManager sharedInstance] themeColor];
            [btn setTitleColor:themeColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)adjustVideoQuality:(UIButton *)adjustQualityBtn {
    UIButton *showQualityViewBtn = (UIButton *)[self.view viewWithTag:kQualityBtnTag];
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    adjustQualityBtn.layer.borderColor = tintColor.CGColor;
    [adjustQualityBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:adjustQualityBtn afterDelay:0.1];
    KSYVideoQuality videoQuality = kKSYVideoNormal;
    if (adjustQualityBtn.tag == 0) {
        videoQuality = kKSYVideoNormal;
        [showQualityViewBtn setTitle:@"流畅" forState:UIControlStateNormal];
    }
    else if (adjustQualityBtn.tag == 1) {
        videoQuality = kKSYVideoHight;
        [showQualityViewBtn setTitle:@"高清" forState:UIControlStateNormal];
    }
    else if (adjustQualityBtn.tag == 2) {
        videoQuality = kKSYVideoSuper;
        [showQualityViewBtn setTitle:@"超清" forState:UIControlStateNormal];
    }
    _curVideoQuality = videoQuality;
    if ([_delegate respondsToSelector:@selector(setVideoQuality:)] == YES) {
        [_delegate setVideoQuality:videoQuality];
    }
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        qualityView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [qualityView removeFromSuperview];
    }];
}

- (void)progressDidBegin:(id)sender
{
    if ([_delegate respondsToSelector:@selector(progressDidBegin:)]==YES)
    {
        [_delegate progressDidBegin:sender];
    }
}

- (void)progressChanged:(id)sender {

    if ([_delegate respondsToSelector:@selector(progressChanged:)]==YES)
    {
        [_delegate progressChanged:sender];
    }

}

- (void)progressChangeEnd:(id)sender {
    if ([_delegate respondsToSelector:@selector(progressChangeEnd:)]==YES)
    {
        [_delegate progressChangeEnd:sender];
    }}

- (void)brightnessChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [[UIScreen mainScreen] setBrightness:slider.value];
}

- (void)brightnessDidBegin:(id)sender {
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
}

- (void)brightnessChangeEnd:(id)sender {
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
}

- (void)voiceChanged:(id)sender
{
    UISlider *voiceSlider = (UISlider *)sender;
    MPMusicPlayerController *musicPlayer;
    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setVolume:voiceSlider.value];
}
//全屏按钮
- (void)clickFullBtn {
    if ([_delegate respondsToSelector:@selector(clickFullBtn)]==YES)
    {
        [_delegate clickFullBtn];
    }
}
- (void)clickBackBtn:(id)sender
{
////    if (self.view.height<SCREENHEIGHT) {
//        return;
//    }
//    else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
- (void)clickScaleBtn:(id)sender {
    UIButton *scaleBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    scaleBtn.layer.borderColor = tintColor.CGColor;
    [scaleBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    if (scaleView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            scaleView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [scaleView removeFromSuperview];
        }];
        return ;
    }
    if (qualityView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            qualityView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [qualityView removeFromSuperview];
        }];
    }
    CGPoint btnLocation = [scaleBtn.superview convertPoint:scaleBtn.frame.origin toView:self.view];
    CGRect rect = CGRectMake(btnLocation.x - 5, btnLocation.y - 90, scaleBtn.frame.size.width + 10, 90);
    scaleView = [[UIView alloc] initWithFrame:rect];
    scaleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scaleView];
    scaleView.tag = kScaleViewTag;
    
    UIView *scaleBgView = [[UIView alloc] initWithFrame:scaleView.bounds];
    scaleBgView.backgroundColor = [UIColor blackColor];
    scaleBgView.alpha = 0.6;
    scaleBgView.layer.masksToBounds = YES;
    scaleBgView.layer.cornerRadius = 3;
    [scaleView addSubview:scaleBgView];
    NSArray *arrTitles = @[@"16:9", @"4:3"];
    for (NSInteger i = 0; i < arrTitles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arrTitles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(5, 5 + 35 * i, rect.size.width - 10, 30);
        btn.tag = i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(adjustVideoScale:) forControlEvents:UIControlEventTouchUpInside];
        [scaleView addSubview:btn];
        if (i == _curVideoScale) {
            UIColor *themeColor = [[ThemeManager sharedInstance] themeColor];
            [btn setTitleColor:themeColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)adjustVideoScale:(id)sender {
    UIButton *showScaleBtn = (UIButton *)[self.view viewWithTag:kScaleBtnTag];
    UIButton *scaleBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    scaleBtn.layer.borderColor = tintColor.CGColor;
    [scaleBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:scaleBtn afterDelay:0.1];
    
    KSYVideoScale scale = kKSYVideo16W9H;
    if (scaleBtn.tag == 0) {
        scale = kKSYVideo16W9H;
        [showScaleBtn setTitle:@"16:9" forState:UIControlStateNormal];
    }
    else if (scaleBtn.tag == 1) {
        scale = kKSYVideo4W3H;
        [showScaleBtn setTitle:@"4:3" forState:UIControlStateNormal];
    }
    _curVideoScale = scale;
    if ([_delegate respondsToSelector:@selector(setVideoScale:)] == YES) {
        [_delegate setVideoScale:scale];
    }
    
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        scaleView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [scaleView removeFromSuperview];
    }];
}

- (void)clickEpisodeBtn:(id)sender {
    UIButton *episodeBtn = (UIButton *)sender;
    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    episodeBtn.layer.borderColor = tintColor.CGColor;
    [episodeBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    NSLog(@"剧集");
    if(!_episodeTableView)
    {
        CGFloat episodeX=self.view.frame.size.width/2;
        //得到toolbarView的大小
        UIView *toolView=[self.view viewWithTag:kToolViewTag];
        CGFloat episodeY=CGRectGetMaxY(toolView.frame);
        CGFloat episodeWidth = episodeX;
        UIView *barView=[self.view viewWithTag:kBarViewtag];
        CGFloat barViewMinY=CGRectGetMinY(barView.frame);
        CGFloat episodeHeight = self.view.frame.size.height-episodeY-(self.view.frame.size.height-barViewMinY);
        CGRect episodeRect = CGRectMake(episodeX, episodeY, episodeWidth, episodeHeight);
        _episodeTableView=[[UITableView alloc]initWithFrame:episodeRect style:UITableViewStylePlain];
        _episodeTableView.tag=kEpisodeTableViewTag;
        [self.view addSubview:_episodeTableView];
        _episodeTableView.backgroundColor = [UIColor clearColor];
        _episodeTableView.delegate=self;
        _episodeTableView.dataSource=self;
    }
    else
    {
        _episodeTableView.hidden =NO;
    }

}

- (void)clickSnapBtn:(id)sender {
//    KSYPlayer *player = [(VideoViewController *)_delegate player];
//    UIImage *snapImage = [player thumbnailImageAtCurrentTime];
//    UIImageWriteToSavedPhotosAlbum(snapImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
#pragma mark 点击设置按钮
-(void)clickSetBtn:(id)sender
{
    UIButton *danmuBtn=(UIButton *)sender;
    UIColor *tintColor=[[ThemeManager sharedInstance] themeColor];
    danmuBtn.layer.borderColor=tintColor.CGColor;
    [danmuBtn setTitleColor:tintColor forState:UIControlStateNormal];
    [self performSelector:@selector(showColor:) withObject:sender afterDelay:0.1];
    //1.获得通过tag获得seView
    //2.setView.hidden＝NO;
    //UIView *setView=(UIView *)()
    [mediaControlView showSetView];
    
    [self hideAllControls];
    
}

- (void)clickLockBtn:(id)sender {
    _isLocked = !_isLocked;
    UIView *barView = [self.view viewWithTag:kBarViewtag];
    UIView *voiceView = [self.view viewWithTag:kVoiceViewTag];
    UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self.view viewWithTag:kToolViewTag];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    UIButton *lockBtn = (UIButton *)sender;
    if (_isLocked == YES) {
        barView.alpha = 0.0;
        voiceView.alpha = 0.0;
        brightnessView.alpha = 0.0;
        toolView.alpha = 0.0;
        qualityView.alpha = 0.0;
        scaleView.alpha = 0.0;
        UIImage *lockCloseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_close_normal"];
        UIImage *lockCloseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_close_hl"];
        [lockBtn setImage:lockCloseImg_n forState:UIControlStateNormal];
        [lockBtn setImage:lockCloseImg_h forState:UIControlStateHighlighted];
    }
    else {
        barView.alpha = 1.0;
        voiceView.alpha = 1.0;
        brightnessView.alpha = 1.0;
        toolView.alpha = 1.0;
        qualityView.alpha = 1.0;
        scaleView.alpha = 1.0;
        UIImage *lockOpenImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_normal"];
        UIImage *lockOpenImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_hl"];
        [lockBtn setImage:lockOpenImg_n forState:UIControlStateNormal];
        [lockBtn setImage:lockOpenImg_h forState:UIControlStateHighlighted];
    }
}

- (void)clickSoundOff:(UITapGestureRecognizer *)tapGesture {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setVolume:0];
    MediaVoiceView *mediaVoiceView = (MediaVoiceView *)[self.view viewWithTag:kMediaVoiceViewTag];
    [mediaVoiceView setIVoice:0];
}

#pragma mark - Snap delegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        
        CGRect noticeRect = CGRectMake(0, 0, 100, 100);
        UIView *noticeView = [[UIView alloc] initWithFrame:noticeRect];
        noticeView.backgroundColor = [UIColor clearColor];
        CGPoint center = self.view.center;
        noticeView.center = CGPointMake(center.y, center.x);
        [self.view addSubview:noticeView];
        
        UIView *noticeBgView = [[UIView alloc] initWithFrame:noticeView.bounds];
        noticeBgView.backgroundColor = [UIColor blackColor];
        noticeBgView.alpha = 0.6f;
        noticeBgView.layer.masksToBounds = YES;
        noticeBgView.layer.cornerRadius = 3;
        [noticeView addSubview:noticeBgView];
        
        // **** mark
        CGRect imgRect = CGRectMake(32, 7, 36, 36);
        UIImageView *completeImgView = [[UIImageView alloc] initWithFrame:imgRect];
        UIImage *snapCompleteImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_complete_normal"];
        completeImgView.image = snapCompleteImg;
        [noticeView addSubview:completeImgView];
        
        CGRect labelRect = CGRectMake(0, 57, 100, 36);
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = @"截图成功";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [noticeView addSubview:label];
        
        // **** dismiss
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
        }];
    }
}

#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(touchesBegan:withEvent:)]==YES) {
        [_delegate touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(touchesMoved:withEvent:)]==YES) {
        [_delegate touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(touchesEnded:withEvent:)]==YES) {
        [_delegate touchesEnded:touches withEvent:event];
    }
}

- (void)seekCompletedWithPosition:(CGFloat)position {
    UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kProgressSliderTag];
    UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
    progressSlider.value = position;
    if (_isCompleted == YES) {
        _isCompleted = NO;
        UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"play_normal"];
        [btn setImage:playImg forState:UIControlStateNormal];
    }
    else {
        
//        KSYPlayer *player = [(VideoViewController *)_delegate player];
//        if (_isKSYPlayerPling) {
//            [player play];
//        }else{
//            _isKSYPlayerPling = NO;
//            [player pause];
//        }
        _isActive = YES;
        [self refreshControl];
    }
}

#pragma mark - KSYMediaPlayerDelegate

//- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState {
//    
//    if (PlayerState != KSYPlayerStateError) {
//        [self removeError];
//    }
//    KSYPlayer *player = [(VideoViewController *)_delegate player];
//    if (PlayerState == KSYPlayerStateInitialized) {
//        _isPrepared = NO;
//        [self showLoading];
//    }else if (PlayerState == KSYPlayerStatePrepared){
//        [self performSelectorOnMainThread:@selector(removeError) withObject:nil waitUntilDone:NO];
//        [self performSelectorOnMainThread:@selector(removeLoading) withObject:nil waitUntilDone:NO];
//    }
//    UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
//    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
//    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
//    UIImage *playImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
//    UIImage *playImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_hl"];
//    if (PlayerState == KSYPlayerStatePlaying) {
//        [btn setImage:pauseImg_n forState:UIControlStateNormal];
//        [btn setImage:pauseImg_h forState:UIControlStateHighlighted];
//    }else if (PlayerState == KSYPlayerStatePaused || player.state == KSYPlayerStateStopped || player.state == KSYPlayerStateCompleted) {
//        [btn setImage:playImg_n forState:UIControlStateNormal];
//        [btn setImage:playImg_h forState:UIControlStateHighlighted];
//    }
//    if (PlayerState == KSYPlayerStatePrepared) {
//        _isPrepared = YES;
//    }
//}
//
//
//- (void)mediaPlayerCompleted:(KSYPlayer *)player {
//    NSLog(@"播放结束");
//    _isEnd = YES;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
//    
//    _isCompleted = YES;
//    //    [_delegate seekProgress:0.0];
//    if ([(VideoViewController *)_delegate isCycleplay] == YES) {
//        if (_errorView) {
//            _errorView.hidden = YES;
//        }
//        [_delegate play];
//        NSLog(@"重新播放");
//    }
//    
//    // **** 结果
//    [_timer invalidate];
//}
//
//- (void)mediaPlayerWithError:(NSError *)error {
//    NSLog(@"KSYPlayer play error: %@", error);
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
//    
//    _isEnd = YES;
//    [self showError];
//    [self removeLoading];
//}
//
//- (void)mediaPlayerBuffing:(KSYBufferingState)bufferingState {
//    if (bufferingState == KSYPlayerBufferingStart) {
//        [self showLoading];
//    }
//    else {
//        [self performSelectorOnMainThread:@selector(removeLoading) withObject:nil waitUntilDone:NO];
//    }
//}
//
//- (void)mediaPlayerSeekCompleted:(KSYPlayer *)player {
//    CGFloat position = player.currentPlaybackTime;
//    [self seekCompletedWithPosition:position];
//}
//- (void)mediaPlayerStateChanged:(KSYPlayerState)PlayerState {
//    
//    if (PlayerState != KSYPlayerStateError) {
//        [self removeError];
//    }
//    KSYPlayer *player = [(VideoViewController *)_delegate player];
//    if (PlayerState == KSYPlayerStateInitialized) {
//        _isPrepared = NO;
//        [self showLoading];
//    }else if (PlayerState == KSYPlayerStatePrepared){
//        [self performSelectorOnMainThread:@selector(removeError) withObject:nil waitUntilDone:NO];
//        [self performSelectorOnMainThread:@selector(removeLoading) withObject:nil waitUntilDone:NO];
//    }
//    UIButton *btn = (UIButton *)[self.view viewWithTag:kBarPlayBtnTag];
//    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
//    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
//    UIImage *playImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
//    UIImage *playImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"play_hl"];
//    if (PlayerState == KSYPlayerStatePlaying) {
//        [btn setImage:pauseImg_n forState:UIControlStateNormal];
//        [btn setImage:pauseImg_h forState:UIControlStateHighlighted];
//    }else if (PlayerState == KSYPlayerStatePaused || player.state == KSYPlayerStateStopped || player.state == KSYPlayerStateCompleted) {
//        [btn setImage:playImg_n forState:UIControlStateNormal];
//        [btn setImage:playImg_h forState:UIControlStateHighlighted];
//    }
//    if (PlayerState == KSYPlayerStatePrepared) {
//        _isPrepared = YES;
//    }
//}


//- (void)mediaPlayerCompleted:(KSYPlayer *)player {
//    NSLog(@"播放结束");
//    _isEnd = YES;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
//    
//    _isCompleted = YES;
//    //    [_delegate seekProgress:0.0];
//    if ([(VideoViewController *)_delegate isCycleplay] == YES) {
//        if (_errorView) {
//            _errorView.hidden = YES;
//        }
//        [_delegate play];
//        NSLog(@"重新播放");
//    }
//    
//    // **** 结果
//    [_timer invalidate];
//}

- (void)mediaPlayerWithError:(NSError *)error {
    NSLog(@"KSYPlayer play error: %@", error);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
    
    _isEnd = YES;
    [self showError];
    [self removeLoading];
}

//- (void)mediaPlayerBuffing:(KSYBufferingState)bufferingState {
//    if (bufferingState == KSYPlayerBufferingStart) {
//        [self showLoading];
//    }
//    else {
//        [self performSelectorOnMainThread:@selector(removeLoading) withObject:nil waitUntilDone:NO];
//    }
//}

//- (void)mediaPlayerSeekCompleted:(KSYPlayer *)player {
//    CGFloat position = player.currentPlaybackTime;
//    [self seekCompletedWithPosition:position];
//}

#pragma mark - Helper

- (void)showAllControls {
    UIView *barView = [self.view viewWithTag:kBarViewtag];
    UIView *voiceView = [self.view viewWithTag:kVoiceViewTag];
    UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self.view viewWithTag:kToolViewTag];
    UIView *lockView = (UIButton *)[self.view viewWithTag:kLockViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        if (_isLocked == NO) {
            barView.alpha = 1.0;
            voiceView.alpha = 1.0;
            brightnessView.alpha = 1.0;
            toolView.alpha = 1.0;
        }
        lockView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _isActive = YES;
        [self refreshControl];
    }];
}

- (void)hideAllControls {
    UIView *barView = [self.view viewWithTag:kBarViewtag];
    UIView *voiceView = [self.view viewWithTag:kVoiceViewTag];
    UIView *brightnessView = [self.view viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self.view viewWithTag:kToolViewTag];
    UIView *qualityView = [self.view viewWithTag:kQualityViewTag];
    UIView *scaleView = [self.view viewWithTag:kScaleViewTag];
    UIView *lockView = [self.view viewWithTag:kLockViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        if (_isLocked == NO) {
            barView.alpha = 0.0;
            voiceView.alpha = 0.0;
            brightnessView.alpha = 0.0;
            toolView.alpha = 0.0;
            qualityView.alpha = 0.0;
            scaleView.alpha = 0.0;
        }
        lockView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [qualityView removeFromSuperview];
        [scaleView removeFromSuperview];
        _isActive = NO;
    }];
}

- (void)showORhideProgressView:(NSNumber *)bShowORHide {
    UIView *progressView = [self.view viewWithTag:kProgressViewTag];
    progressView.hidden = bShowORHide.boolValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideProgressView) object:nil];
    if (!bShowORHide.boolValue) {
        [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:1];
    }
}

- (void)hideProgressView {
    UIView *progressView = [self.view viewWithTag:kProgressViewTag];
    progressView.hidden = YES;
}

- (void)showNotice:(NSString *)strNotice {
    static BOOL isShowing = NO;
    if (isShowing == NO) {
        CGRect noticeRect = CGRectMake(0, 0, 150, 30);
        UIView *noticeView = [[UIView alloc] initWithFrame:noticeRect];
        noticeView.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:noticeView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 5;
        bgView.alpha = 0.6;
        [noticeView addSubview:bgView];
        
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:noticeView.bounds];
        noticeLabel.text = strNotice;
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.textColor = [UIColor whiteColor];
        [noticeView addSubview:noticeLabel];
        [self.view addSubview:noticeView];
        
        noticeView.center = self.view.center;
        if (self.view.frame.size.height == [[UIScreen mainScreen] bounds].size.height) {
            noticeView.center = CGPointMake(self.view.center.y, self.view.center.x);
        }
        
        [UIView animateWithDuration:1.0 animations:^{
            noticeView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [noticeView removeFromSuperview];
            isShowing = NO;
        }];
    }
}

#pragma mark - Player state

- (void)reSetLoadingViewFrame
{
    if (!_loadingView.hidden) {
        _loadingView.frame = self.view.bounds;
        UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[_loadingView viewWithTag:kLoadIndicatorViewTag];
        indicatorView.center = CGPointMake(_loadingView.center.x, _loadingView.center.y - 10);
        UILabel *indicatorLabel = (UILabel *)[_loadingView viewWithTag:kLoadIndicatorLabelTag];
        indicatorLabel.center = CGPointMake(_loadingView.center.x, _loadingView.center.y + 20);
    }
    if (!_errorView.hidden) {
        _errorView.frame = self.view.bounds;
        UILabel *indicatorLabel = (UILabel *)[_errorView viewWithTag:kErrorLabelTag];
        indicatorLabel.center = CGPointMake(_errorView.center.x, _errorView.center.y);
    }
}

- (void)showLoading {
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_loadingView];
        [self.view sendSubviewToBack:_loadingView];
        
        // **** activity
        CGSize size = self.view.frame.size;
        if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
            CGFloat temp = size.width;
            size.width = size.height;
            size.height = temp;
        }
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.tag = kLoadIndicatorViewTag;
        _indicatorView.center = CGPointMake(_loadingView.center.x, _loadingView.center.y - 10);
        [_indicatorView startAnimating];
        [_loadingView addSubview:_indicatorView];
        
        CGRect labelRect = CGRectMake(0, 0, 100, 30);
        _indicatorLabel = [[UILabel alloc] initWithFrame:labelRect];
        _indicatorLabel.tag = kLoadIndicatorLabelTag;
        _indicatorLabel.text = @"加载中...";
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.textColor = [UIColor whiteColor];
        [_loadingView addSubview:_indicatorLabel];
    }
    _indicatorLabel.center = CGPointMake(_loadingView.center.x, _loadingView.center.y + 20);
    _loadingView.hidden = NO;
    [self reSetLoadingViewFrame];
}

- (void)removeLoading {
    _loadingView.hidden = YES;
}

- (void)showError {
    if (_errorView == nil) {
        _errorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _errorView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_errorView];
        [self.view sendSubviewToBack:_errorView]; // **** 可以让视图返回
        
        // **** indicator
        CGSize size = self.view.frame.size;
        if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
            CGFloat temp = size.width;
            size.width = size.height;
            size.height = temp;
        }
        CGRect labelRect = CGRectMake(size.width / 2 - 50, size.height / 2 - 45, 100, 50);
        UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:labelRect];
        indicatorLabel.tag = kErrorLabelTag;
        indicatorLabel.text = @":( 视频出错了，请重试！";
        indicatorLabel.textColor = [UIColor whiteColor];
        [_errorView addSubview:indicatorLabel];
    }
    _errorView.hidden = NO;
    [self reSetLoadingViewFrame];
}

- (void)removeError{
    _errorView.hidden = YES;
}

int count = 0;

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (float) cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

@end
