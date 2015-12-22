//
//  MediaControlView.m
//  KSYPlayerDemo
//
//  Created by Blues on 15/3/24.
//  Copyright (c) 2015年 KSY. All rights reserved.
//
#define TEXTCOLOR1 ([UIColor colorWithRed:207.0/255.0 green:206.0/255.0 blue:203.0/255.0 alpha:1.0])
#define TEXTCOLOR2 ([UIColor colorWithRed:237.0/255.0 green:236.0/255.0 blue:234.0/255.0 alpha:1.0])
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define kTopBarHeight 40
#define kBottomBarHeight 58
#define kCoverBarHeight 140
#define kCoverBarLeftMargin 20
#define kCoverBarRightMargin 20
#define kCoverBarTopMargin 48
#define kCoverBarBottomMargin 42
#define kCoverLockViewLeftMargin 68
#define kCoverLockViewBgWidth 40
#define kCoverLockWidth 30
#define kCoverBarWidth 25
#define kProgressViewWidth 150
#define kLandscapeSpacing 10
#define kVertialSpacing 20
#define kBigFont 18
#define kSmallFont 16

#import "MediaControlView.h"
#import "MediaControlDefine.h"
#import "MediaControlViewController.h"
#import "MediaVoiceView.h"
#import "KSYBarView.h"
#import "UIView+BFExtension.h"

@implementation MediaControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        CGSize size = frame.size;
        UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
        
        // **** UI elements
        //按钮视图的大小 重置
        CGRect barRect = CGRectMake(0, size.height-kBottomBarHeight, size.width, kBottomBarHeight);
        KSYBarView *barView = [[KSYBarView alloc] initWithFrame:barRect];
        barView.backgroundColor = [UIColor clearColor];
        barView.tag = kBarViewtag;
        [self addSubview:barView];
        
        //按钮背景视图
        UIView *barBgView = [[UIView alloc] initWithFrame:barView.bounds];
        barBgView.backgroundColor = [UIColor blackColor];
        barBgView.alpha = 0.6f;
        barBgView.tag = kBarBgViewTag;
        [barView addSubview:barBgView];
        
        //开始按钮
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.alpha = 0.6;
        UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
        UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
        [playBtn setImage:pauseImg_n forState:UIControlStateNormal];
        [playBtn setImage:pauseImg_h forState:UIControlStateHighlighted];
        playBtn.frame = CGRectMake(10, 5, 53, 53);
        playBtn.tag = kBarPlayBtnTag;
        [playBtn addTarget:_controller action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:playBtn];
        
        //播放时间
        CGRect startLabelRect = CGRectMake(45, 25, 55, 15);
        UILabel *startLabel = [[UILabel alloc] initWithFrame:startLabelRect];
        startLabel.text = @"00:00";
        startLabel.textAlignment = NSTextAlignmentRight;
        startLabel.font = [UIFont boldSystemFontOfSize:13];
        startLabel.textColor = tintColor;
        startLabel.tag = kProgressCurLabelTag;
        [barView addSubview:startLabel];
        
        //滚动条
        CGRect progressSliderRect = CGRectMake(0, 0, self.width, 10);
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        UIImage *minImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"slider_color"];
        UISlider *progressSlider = [[UISlider alloc] initWithFrame:progressSliderRect];
        [progressSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
        progressSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
        [progressSlider addTarget:_controller action:@selector(progressDidBegin:) forControlEvents:UIControlEventTouchDown];
        [progressSlider addTarget:_controller action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
        [progressSlider addTarget:_controller action:@selector(progressChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        progressSlider.value = 0.0;
        progressSlider.tag = kProgressSliderTag;
        [barView addSubview:progressSlider];
        
        //视频总时间标签
        CGRect endLabelRect = CGRectMake(45 + 55, 25, 55, 15);
        UILabel *endLabel = [[UILabel alloc] initWithFrame:endLabelRect];
        endLabel.alpha = 0.6;
        endLabel.text = @"/00:00";
        endLabel.font = [UIFont boldSystemFontOfSize:13];
        endLabel.textColor = [UIColor whiteColor];
        endLabel.tag = kProgressMaxLabelTag;
        [barView addSubview:endLabel];
        
        
        //添加弹幕按钮
        UIButton *danmuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        danmuBtn.alpha = 0.6f;
        danmuBtn.hidden = YES;
        danmuBtn.frame = CGRectMake(self.width - 280, 20, 70, 25);
        danmuBtn.tag = kDanmuBtnTag;
        danmuBtn.layer.masksToBounds = YES;
        danmuBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        danmuBtn.layer.borderWidth = 0.5;
        danmuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [danmuBtn setTitle:@"弹幕开" forState:UIControlStateNormal];
        [danmuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [danmuBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [danmuBtn addTarget:_controller action:@selector(clickDanmuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:danmuBtn];
        
        
        //添加评论按钮
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.alpha = 0.6f;
        commentBtn.hidden = YES;
        commentBtn.frame = CGRectMake(self.width - 350, 100, 50, 25);
        commentBtn.tag = kCommentBtnTag;
        commentBtn.layer.masksToBounds = YES;
        commentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        commentBtn.layer.borderWidth = 0.5;
        commentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commentBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [commentBtn addTarget:_controller action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:commentBtn];
        
        //添加评论文本框
        UITextField *commentField = [UITextField new];
        commentField.alpha = 0.6f;
        commentField.hidden = YES;
        commentField.tag = kCommentFieldTag;
        commentField.layer.masksToBounds = YES;
        commentField.layer.borderColor = [UIColor whiteColor].CGColor;
        commentField.layer.borderWidth = 0.5;
        
        
        //创建一个文本框视图(文本框 ＋ 放松按钮)
        UIView *commentView=[[UIView alloc]initWithFrame:CGRectMake(10, 300, 40, 40)];
        commentView.tag=kCommentViewTag;
        [commentView addSubview:commentField];
        [self addSubview:commentView];
        //创建一个放松按钮
        UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.tag=kSendBtnTag;
        sendBtn.frame=CGRectMake(10, 10, 10, 10);
        [commentView addSubview:sendBtn];
        
        
        
        
        //视频清晰度选择按钮
        UIButton *qualityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qualityBtn.alpha = 0.6f;
        qualityBtn.hidden = YES;
        qualityBtn.frame = CGRectMake(size.width - 210, 20, 50, 25);
        qualityBtn.tag = kQualityBtnTag;
        qualityBtn.layer.masksToBounds = YES;
        qualityBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        qualityBtn.layer.borderWidth = 0.5;
        qualityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [qualityBtn setTitle:@"流畅" forState:UIControlStateNormal];
        [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qualityBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [qualityBtn addTarget:_controller action:@selector(clickQualityBtn:) forControlEvents:UIControlEventTouchUpInside];
        [qualityBtn addTarget:_controller action:@selector(clickNormalBtn:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
        [qualityBtn addTarget:_controller action:@selector(clickHighlightBtn:) forControlEvents:UIControlEventTouchDown];
        [barView addSubview:qualityBtn];
        
        //视屏宽高比例选择按钮
        UIButton *scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scaleBtn.alpha = 0.6;
        scaleBtn.hidden = YES;
        scaleBtn.frame = CGRectMake(size.width - 140, 25, 50, 25);
        scaleBtn.tag = kScaleBtnTag;
        scaleBtn.layer.masksToBounds = YES;
        scaleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        scaleBtn.layer.borderWidth = 0.5;
        scaleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [scaleBtn setTitle:@"16:9" forState:UIControlStateNormal];
        [scaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scaleBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [scaleBtn addTarget:_controller action:@selector(clickScaleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [scaleBtn addTarget:_controller action:@selector(clickNormalBtn:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
        [scaleBtn addTarget:_controller action:@selector(clickHighlightBtn:) forControlEvents:UIControlEventTouchDown];
        [barView addSubview:scaleBtn];
        
        //选集按钮
        UIButton *episodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        episodeBtn.alpha = 0.6;
        episodeBtn.hidden = YES;
        episodeBtn.frame = CGRectMake(self.width - 70, 25, 50, 25);
        episodeBtn.tag = kEpisodeBtnTag;
        episodeBtn.layer.masksToBounds = YES;
        episodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        episodeBtn.layer.borderWidth = 0.5;
        episodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [episodeBtn setTitle:@"剧集" forState:UIControlStateNormal];
        [episodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [episodeBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
        [episodeBtn addTarget:_controller action:@selector(clickEpisodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [episodeBtn addTarget:_controller action:@selector(clickNormalBtn:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
        [episodeBtn addTarget:_controller action:@selector(clickHighlightBtn:) forControlEvents:UIControlEventTouchDown];
        [barView addSubview:episodeBtn];
        
        //全屏按钮
        CGRect fullBtnRect = CGRectMake(size.width - 40, 20, 25, 25);
        UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fullBtn.alpha = 0.6;
        UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
        [fullBtn setImage:fullImg forState:UIControlStateNormal];
        fullBtn.frame = fullBtnRect;
        fullBtn.tag = kFullScreenBtnTag;
        [fullBtn addTarget:_controller action:@selector(clickFullBtn) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:fullBtn];
        
        // **** progress view
        //进度指示
        CGRect progressRect = CGRectMake((size.width - kProgressViewWidth) / 2, (size.height - 50) / 2, kProgressViewWidth, 50);
        UIView *progressView = [[UIView alloc] initWithFrame:progressRect];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.tag = kProgressViewTag;
        progressView.hidden = YES;
        [self addSubview:progressView];
        
        //进度指示背景视图
        UIView *progressBgView = [[UIView alloc] initWithFrame:progressView.bounds];
        progressBgView.backgroundColor = [UIColor blackColor];
        progressBgView.layer.masksToBounds = YES;
        progressBgView.layer.cornerRadius = 5;
        progressBgView.alpha = 0.7;
        [progressView addSubview:progressBgView];
        
        //当前进度标签
        CGRect curProgressLabelRect = CGRectMake(0, 0, progressRect.size.width, 50);
        UILabel *curProgressLabel = [[UILabel alloc] initWithFrame:curProgressLabelRect];
        curProgressLabel.alpha = 0.6f;
        curProgressLabel.tag = kCurProgressLabelTag;
        curProgressLabel.text = @"00:00";
        curProgressLabel.font = [UIFont boldSystemFontOfSize:20];
        curProgressLabel.textAlignment = NSTextAlignmentCenter;
        curProgressLabel.textColor = [UIColor whiteColor];
        [progressView addSubview:curProgressLabel];
        
        //快进图片
        CGRect wardImgViewRect = CGRectMake(10, 15, 20, 20);
        UIImageView *wardImgView = [[UIImageView alloc] initWithFrame:wardImgViewRect];
        wardImgView.alpha = 0.6f;
        UIImage *forwardImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_forward_normal"];
        wardImgView.image = forwardImg;
        wardImgView.tag =kWardMarkImgViewTag;
        [progressView addSubview:wardImgView];
        
        // **** brightness view
        //亮度条
        CGRect brightnessRect = CGRectMake(kCoverBarLeftMargin, size.height / 4, kCoverBarWidth, size.height / 2);
        UIView *brightnessView = [[UIView alloc] initWithFrame:brightnessRect];
        brightnessView.backgroundColor = [UIColor clearColor];
        brightnessView.layer.masksToBounds = YES;
        brightnessView.layer.cornerRadius = 3;
        brightnessView.tag = kBrightnessViewTag;
        brightnessView.hidden = YES; // **** at first in portrait orientation, it's hidden
        [self addSubview:brightnessView];
        
        //亮度条背景视图
        UIView *brightnessBgView = [[UIView alloc] initWithFrame:brightnessView.bounds];
        brightnessBgView.backgroundColor = [UIColor blackColor];
        brightnessBgView.alpha = 0.6f;
        [brightnessView addSubview:brightnessBgView];
        
        //高亮模式图片
        CGRect brightnessImgViewRect1 = CGRectMake(3, 3, kCoverBarWidth - 6, kCoverBarWidth - 6);
        UIImageView *brightnessImgView1 = [[UIImageView alloc] initWithFrame:brightnessImgViewRect1];
        UIImage *brightnessImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"brightness"];
        brightnessImgView1.image = brightnessImg;
        [brightnessView addSubview:brightnessImgView1];
        
        //亮度条
        CGFloat sliderWidth = brightnessRect.size.height - 45;
        CGFloat sliderHeight = 15;
        CGFloat X = -sliderWidth / 2 + brightnessRect.size.width / 2;
        CGFloat Y = brightnessRect.size.height / 2 - sliderHeight / 2 + 4;
        CGRect brightnessSliderRect = CGRectMake(X, Y, sliderWidth, sliderHeight);
        UISlider *brightnessSlider = [[UISlider alloc] initWithFrame:brightnessSliderRect];
        [brightnessSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
        brightnessSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [brightnessSlider setThumbImage:dotImg forState:UIControlStateNormal];
        brightnessSlider.value = [[UIScreen mainScreen] brightness];
        brightnessSlider.tag = kBrightnessSliderTag;
        [brightnessSlider addTarget:_controller action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
        [brightnessSlider addTarget:_controller action:@selector(brightnessDidBegin:) forControlEvents:UIControlEventTouchDown];
        [brightnessSlider addTarget:_controller action:@selector(brightnessChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        [brightnessView addSubview:brightnessSlider];
        brightnessSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        
        //低亮模式图片
        CGFloat low_brightness = kCoverBarWidth - 10;
        CGRect brightnessImgViewRect2 = CGRectMake(5, brightnessRect.size.height - low_brightness - 3, low_brightness, low_brightness);
        UIImageView *brightnessImgView2 = [[UIImageView alloc] initWithFrame:brightnessImgViewRect2];
        brightnessImgView2.image = brightnessImg;
        [brightnessView addSubview:brightnessImgView2];
        
        // **** video lock
        //锁屏按钮大小
        CGRect lockViewRect = CGRectMake(kCoverLockViewLeftMargin, (size.height - size.height / 6) / 2, size.height / 6, size.height / 6);
        UIView *lockView = [[UIView alloc] initWithFrame:lockViewRect];
        lockView.tag = kLockViewTag;
        lockView.hidden = YES; // **** hidden at first
        lockView.backgroundColor = [UIColor clearColor];
        [self addSubview:lockView];
        
        //锁屏背景视图
        UIView *lockBgView = [[UIView alloc] initWithFrame:lockView.bounds];
        lockBgView.backgroundColor = [UIColor blackColor];
        lockBgView.layer.masksToBounds = YES;
        lockBgView.layer.cornerRadius = lockViewRect.size.width / 2;
        lockBgView.alpha = 0.6f;
        [lockView addSubview:lockBgView];
        
        //锁屏按钮
        UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lockBtn.alpha = 0.6f;
        lockBtn.frame = CGRectMake(10, 10, lockViewRect.size.width - 20, lockViewRect.size.width - 20);
        UIImage *lockOpenImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_normal"];
        UIImage *lockOpenImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_lock_open_hl"];
        [lockBtn setImage:lockOpenImg_n forState:UIControlStateNormal];
        [lockBtn setImage:lockOpenImg_h forState:UIControlStateHighlighted];
        [lockBtn addTarget:_controller action:@selector(clickLockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [lockView addSubview:lockBtn];
        
        // **** voice view 动手去做
        // 声音视图
        CGRect voiceRect = CGRectMake(size.width - kCoverBarWidth - kCoverBarRightMargin, size.height / 4, kCoverBarWidth, size.height / 2);
        UIView *voiceView = [[UIView alloc] initWithFrame:voiceRect];
        voiceView.backgroundColor = [UIColor clearColor];
        voiceView.layer.masksToBounds = YES;
        voiceView.layer.cornerRadius = 3;
        voiceView.tag = kVoiceViewTag;
        voiceView.hidden = YES; // **** at first in portrait orientation, it's hidden
        [self addSubview:voiceView];
        
        //声音背景视图
        UIView *voiceBgView = [[UIView alloc] initWithFrame:voiceView.bounds];
        voiceBgView.backgroundColor = [UIColor blackColor];
        voiceBgView.alpha = 0.6f;
        [voiceView addSubview:voiceBgView];
        
        //静音按钮
        CGFloat voiceImgWidth = kCoverBarWidth - 8;
        UIImage *voiceMinImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"voice_min"];
        CGRect voiceImgViewRect1 = CGRectMake(4, brightnessRect.size.height - voiceImgWidth - 4, voiceImgWidth, voiceImgWidth);
        UIButton *voiceMinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [voiceMinBtn setImage:voiceMinImg forState:UIControlStateNormal];
        voiceMinBtn.frame = voiceImgViewRect1;
        [voiceMinBtn addTarget:_controller action:@selector(clickSoundOff:) forControlEvents:UIControlEventTouchUpInside];
        [voiceView addSubview:voiceMinBtn];
        
        //声音条
        CGRect mediaVoiceRect = CGRectMake(4, 25, kCoverBarWidth - 10, voiceRect.size.height - 25 * 2);
        MediaVoiceView *mediaVoiceView = [[MediaVoiceView alloc] initWithFrame:mediaVoiceRect];
        mediaVoiceView.tag = kMediaVoiceViewTag;
        [mediaVoiceView setFillColor:[[ThemeManager sharedInstance] themeColor]];
//        [mediaVoiceView setIVoice:[MPMusicPlayerController applicationMusicPlayer].volume];
        [voiceView addSubview:mediaVoiceView];
        
        //最大声音视图
        CGRect voiceImgViewRect2 = voiceImgViewRect1;//CGRectMake(2, 0, 20, 20);
        voiceImgViewRect2.origin.y = 4;
        UIImageView *voiceImgView2 = [[UIImageView alloc] initWithFrame:voiceImgViewRect2];
        UIImage *voiceMaxImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"voice_max"];
        voiceImgView2.image = voiceMaxImg;
        [voiceView addSubview:voiceImgView2];
        
        // **** tool view
        //工具栏视图
        CGRect toolViewRect = CGRectMake(0, 0, size.width, kTopBarHeight);
        KSYBarView *toolView = [[KSYBarView alloc] initWithFrame:toolViewRect];
        toolView.backgroundColor = [UIColor clearColor];
        toolView.tag = kToolViewTag;
        [self addSubview:toolView];
        
        //工具栏背景视图
        UIView *bgToolView = [[UIView alloc] initWithFrame:toolView.bounds];
        bgToolView.backgroundColor = [UIColor blackColor];
        bgToolView.tag = kToolBgViewTag;
        bgToolView.alpha = 0.6;
        [toolView addSubview:bgToolView];
        
        
        //返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10, (kTopBarHeight - 22) / 2, 80, 22);
        UIImage *backImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_back_normal"];
        UIImage *backImg_hl = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_back_hl"];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        [backBtn setImage:backImg_hl forState:UIControlStateHighlighted];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 55);
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(9, -38, 10, 0);
        [backBtn addTarget:_controller action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:backBtn];
        
        //抓图按钮
        CGRect snapBtnRect = CGRectMake(size.width - 40, (kTopBarHeight - 30) / 2, 30, 30);
        UIButton *snapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        snapBtn.alpha = 0.6;
        snapBtn.hidden= NO;
        snapBtn.frame = snapBtnRect;
        snapBtn.tag = kSnapBtnTag;
        UIImage *screenshotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_snapshot_normal"];
        UIImage *screenshotImg_hl = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_snapshot_hl"];
        [snapBtn setImage:screenshotImg forState:UIControlStateNormal];
        [snapBtn setImage:screenshotImg_hl forState:UIControlStateHighlighted];
        [snapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [snapBtn addTarget:_controller action:@selector(clickSnapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:snapBtn];
        
        
        //添加高级设置按钮
        UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮的透明度
        setBtn.alpha = 0.6f;
        //设置是否隐藏
        setBtn.hidden=YES;
        //设置设置按钮的大小
        setBtn.frame = CGRectMake(size.width-70, (kTopBarHeight - 30) / 2, 50, 25);//size.width - 40, (kTopBarHeight - 30) / 2, 30, 30
        //设置设置按钮的tag值 少想多做
        setBtn.tag = kSetBtnTag;
        //是否设置圆角
        setBtn.layer.masksToBounds=YES;
        //设置边框颜色
        setBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        //设置边框的宽度
        setBtn.layer.borderWidth=0.5;
        //设置按钮标题字体大小
        setBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        //设置设置按钮的标题
        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
        //设置设置按钮的标题的颜色
        [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置设置按钮高亮颜色
        [setBtn setTitleColor:tintColor forState:UIControlStateHighlighted];
        //设置按钮响应事件
        [setBtn addTarget:_controller action:@selector(clickSetBtn:) forControlEvents:UIControlEventTouchUpInside];
        //添加设置按钮
        [toolView addSubview:setBtn];
        
        //添加弹幕视图
        
        // **** cpu, memory
        UILabel *cpuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 20)];
        cpuLabel.backgroundColor = [UIColor clearColor];
        cpuLabel.textColor = [UIColor whiteColor];
        cpuLabel.tag = kCPULabel;
        [self addSubview:cpuLabel];
        
        UILabel *memLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 480, 20)];
        memLabel.backgroundColor = [UIColor clearColor];
        memLabel.textColor = [UIColor whiteColor];
        memLabel.tag = kMemLabel;
        [self addSubview:memLabel];
        
        
        //****   添加设置视图
        //设置大小
        CGFloat setViewX=[UIScreen mainScreen].bounds.size.height/2;
        CGFloat setViewY=[UIScreen mainScreen].bounds.size.width;
        CGRect setViewRect=CGRectMake(setViewX, 0, setViewX, setViewY);
        //创建视图
        UIView *setView=[[UIView alloc]initWithFrame:setViewRect];
        //清楚背景颜色
        setView.backgroundColor=[UIColor clearColor];
        //设置tag
        setView.tag=kSetViewTag;
        //是否隐藏
        setView.hidden=YES;
        //添加到当前视图之上
        [self addSubview:setView];
        
        //设置背景图
        UIView *setBgView=[[UIView alloc]initWithFrame:setView.bounds];
        setBgView.backgroundColor=[UIColor blackColor];
        //设置透明度
        setBgView.alpha=0.6f;
        //添加到setView之上
        [setView addSubview:setBgView];
        
        //添加标签
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        titleLabel.tag=kTitleLabelTag;
        titleLabel.text=@"字幕设置";
        titleLabel.textColor=TEXTCOLOR2;
        titleLabel.font=[UIFont systemFontOfSize:kBigFont];
        [setView addSubview:titleLabel];
        
        //添加字号大小标签
        UILabel *fontLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+kVertialSpacing-5, 80, 20)];
        fontLabel.tag=kFontLabelTag;
        [setView addSubview:fontLabel];
        fontLabel.text=@"字号大小";
        fontLabel.textColor =TEXTCOLOR1;
        
        //添加分段控制器
        CGFloat fontSizeSCX=CGRectGetMaxX(fontLabel.frame)+kLandscapeSpacing;
        CGFloat fontSizeSCY=CGRectGetMidY(fontLabel.frame)-15;
        NSArray *array=[NSArray arrayWithObjects:@"小",@"中",@"大", nil];
        UISegmentedControl *fontSizeSC=[[UISegmentedControl alloc]initWithItems:array];
        fontSizeSC.frame=CGRectMake(fontSizeSCX, fontSizeSCY, CGRectGetWidth(setView.frame)-fontSizeSCX-kLandscapeSpacing, 30);
        fontSizeSC.tag=kFontSizeSCTag;
        [setView addSubview:fontSizeSC];
        fontSizeSC.selectedSegmentIndex=0;
        
        //添加字号大小标签
        UILabel *speedLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(fontLabel.frame)+kVertialSpacing, 80, 20)];
        speedLabel.tag=kSpeedLabelTag;
        [setView addSubview:speedLabel];
        speedLabel.text=@"移动速度";
        speedLabel.textColor=TEXTCOLOR1;
        
        //添加分段控制器
        CGFloat speedSCX=CGRectGetMaxX(speedLabel.frame)+kLandscapeSpacing;
        CGFloat speedSCY=CGRectGetMidY(speedLabel.frame)-15;
        UISegmentedControl *speedSC=[[UISegmentedControl alloc]initWithItems:array];
        speedSC.tag=kSpeedSCTag;
        speedSC.frame=CGRectMake(speedSCX, speedSCY, CGRectGetWidth(setView.frame)-fontSizeSCX-kLandscapeSpacing, 30);
        [setView addSubview:speedSC];
        speedSC.selectedSegmentIndex=0;
        
        //添加字号大小标签
        UILabel *alphaLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(speedLabel.frame)+kVertialSpacing, 80, 20)];
        alphaLabel.tag=kAlphaLabelTag;
        [setView addSubview:alphaLabel];
        alphaLabel.text=@"透明度";
        alphaLabel.textColor=TEXTCOLOR1;
        
        //添加分段控制器
        CGFloat alphaSCX=CGRectGetMaxX(alphaLabel.frame)+kLandscapeSpacing;
        CGFloat alphaSCY=CGRectGetMidY(alphaLabel.frame)-15;
        UISegmentedControl *alphaSC=[[UISegmentedControl alloc]initWithItems:array];
        alphaSC.tag=kAlphaSCTag;
        alphaSC.frame=CGRectMake(alphaSCX, alphaSCY, CGRectGetWidth(setView.frame)-fontSizeSCX-kLandscapeSpacing, 30);
        [setView addSubview:alphaSC];
        alphaSC.selectedSegmentIndex=0;
        
        
        //添加分割线
        UILabel *underLine=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(alphaLabel.frame)+kVertialSpacing, CGRectGetWidth(setView.frame)-20, 1)];
        underLine.tag=kUnderLineTag;
        [setView addSubview:underLine];
        underLine.backgroundColor=TEXTCOLOR1;
        
        //添加播放设置标签
        UILabel *playSetLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(underLine.frame)+kVertialSpacing-2, 80, 20)];
        [setView addSubview:playSetLabel];
        playSetLabel.tag=kPlaySetLabelTag;
        playSetLabel.text=@"播放设置";
        playSetLabel.font=[UIFont systemFontOfSize:kBigFont];
        playSetLabel.textColor=TEXTCOLOR2;
        
        //添加音量设置标签
        UILabel *voiceSetLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(playSetLabel.frame)+kVertialSpacing-10, 80, 20)];
        voiceSetLabel.tag=kVoiceSetLabelTag;
        [setView addSubview:voiceSetLabel];
        voiceSetLabel.text=@"音量设置";
        voiceSetLabel.textColor=TEXTCOLOR1;
        
        //静音
        CGFloat lowVoiceImgWidth = kCoverBarWidth - 8;
        UIImage *lowVoiceImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"voice_min"];
        CGRect lowVoiceImgViewRect = CGRectMake(10, CGRectGetMaxY(voiceSetLabel.frame)+kVertialSpacing-10, lowVoiceImgWidth, lowVoiceImgWidth);
        UIImageView *lowVoiceImageView = [[UIImageView alloc]initWithImage:lowVoiceImg];
        lowVoiceImageView.frame=lowVoiceImgViewRect;
        lowVoiceImageView.contentMode=UIViewContentModeScaleAspectFit;
        //        lowVoiceLabel.tag
        [setView addSubview:lowVoiceImageView];
        
        
        //高音
        CGFloat highVoiceImgWidth = kCoverBarWidth - 8;
        UIImage *highVoiceImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"voice_max"];
        CGRect highVoiceImgViewRect = CGRectMake(CGRectGetWidth(setView.frame)-10-highVoiceImgWidth, CGRectGetMinY(lowVoiceImageView.frame), highVoiceImgWidth, highVoiceImgWidth);
        UIImageView *highVoiceImageView = [[UIImageView alloc]initWithImage:highVoiceImg];
        highVoiceImageView.contentMode=UIViewContentModeScaleAspectFit;
        highVoiceImageView.frame=highVoiceImgViewRect;
        highVoiceImageView.contentMode=UIViewContentModeScaleAspectFit;
        //        lowVoiceLabel.tag
        [setView addSubview:highVoiceImageView];
        
        //添加音量进度条
        //        CGFloat brightnessX=CGRectGetMaxX(lowBrightnessImgView.frame)+10;
        //        CGFloat brightnessY=CGRectGetMidY(lowBrightnessImgView.frame)-5;
        //        CGFloat brightnessHeight=10;
        //        CGFloat brightnessWidth=CGRectGetWidth(setView.frame)-brightnessX-(CGRectGetWidth(setView.frame)-CGRectGetMinX(highBrightnessImgView.frame));
        //        CGRect brightnessRect1=CGRectMake(brightnessX, brightnessY, brightnessWidth, brightnessHeight);
        //        UISlider *brightnessSilder1=[[UISlider alloc]initWithFrame:brightnessRect1];
        //        [setView addSubview:brightnessSilder1];
        CGFloat voiceSliderX = CGRectGetMaxX(lowVoiceImageView.frame)+10;
        CGFloat voiceSliderY =CGRectGetMidY(lowVoiceImageView.frame)-5;
        CGFloat voiceSliderWidth =CGRectGetWidth(setView.frame)-voiceSliderX-(CGRectGetWidth(setView.frame)-CGRectGetMinX(highVoiceImageView.frame));
        CGFloat voiceSliderHeight = 10;
        
        CGRect voiceSliderRect = CGRectMake(voiceSliderX, voiceSliderY, voiceSliderWidth, voiceSliderHeight);
        UISlider *voiceSlider = [[UISlider alloc] initWithFrame:voiceSliderRect];
        [setView addSubview:voiceSlider];
        [voiceSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
        voiceSlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [voiceSlider setThumbImage:dotImg forState:UIControlStateNormal];
//        voiceSlider.value = [MPMusicPlayerController applicationMusicPlayer].volume;
        voiceSlider.tag = kVoiceSliderTag;
        //        [voiceSlider addTarget:_controller action:@selector(voiceChanged:) forControlEvents:UIControlEventValueChanged];
        //        [voiceSlider addTarget:_controller action:@selector(voiceDidBegin:) forControlEvents:UIControlEventTouchDown];
        //        [voiceSlider addTarget:_controller action:@selector(voiceChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        
        
        
        //添加亮度设置
        UILabel *brightnessLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lowVoiceImageView.frame)+kLandscapeSpacing-10, 80, 20)];
        [setView addSubview:brightnessLabel];
        brightnessLabel.text=@"亮度设置";
        brightnessLabel.textColor=TEXTCOLOR1;
        brightnessLabel.font=[UIFont systemFontOfSize:kSmallFont];
        
        
        //低亮模式
        CGFloat lowbrightnessWidth = kCoverBarWidth - 10;
        CGRect lowBrightnessImgViewRect = CGRectMake(10, CGRectGetMaxY(brightnessLabel.frame)+kVertialSpacing-10, lowbrightnessWidth, lowbrightnessWidth);
        UIImageView *lowBrightnessImgView = [[UIImageView alloc] initWithFrame:lowBrightnessImgViewRect];
        lowBrightnessImgView.contentMode=UIViewContentModeScaleAspectFit;
        UIImage *brightnessImage = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"brightness"];
        lowBrightnessImgView.image=brightnessImage;
        [setView addSubview:lowBrightnessImgView];
        
        
        //高亮模式
        CGRect highbrightnessImgViewRect = CGRectMake(CGRectGetWidth(setView.frame)-6-kCoverBarWidth , CGRectGetMidY(lowBrightnessImgView.frame)-((kCoverBarWidth - 6)/2), kCoverBarWidth - 6, kCoverBarWidth - 6);
        UIImageView *highBrightnessImgView = [[UIImageView alloc] initWithFrame:highbrightnessImgViewRect];
        highBrightnessImgView.contentMode=UIViewContentModeScaleAspectFit;
        highBrightnessImgView.image = brightnessImg;
        [setView addSubview:highBrightnessImgView];
        
        //添加亮度条
        CGFloat brightnessX=CGRectGetMaxX(lowBrightnessImgView.frame)+10;
        CGFloat brightnessY=CGRectGetMidY(lowBrightnessImgView.frame)-5;
        CGFloat brightnessHeight=10;
        CGFloat brightnessWidth=CGRectGetWidth(setView.frame)-brightnessX-(CGRectGetWidth(setView.frame)-CGRectGetMinX(highBrightnessImgView.frame));
        CGRect brightnessRect1=CGRectMake(brightnessX, brightnessY, brightnessWidth, brightnessHeight);
        UISlider *brightnessSilder1=[[UISlider alloc]initWithFrame:brightnessRect1];
        [setView addSubview:brightnessSilder1];
        
        [brightnessSilder1 setMinimumTrackImage:minImg forState:UIControlStateNormal];
        brightnessSilder1.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [brightnessSilder1 setThumbImage:dotImg forState:UIControlStateNormal];
        brightnessSilder1.value = [UIScreen mainScreen].brightness;
        brightnessSilder1.tag = kVoiceSliderTag;
        [brightnessSilder1 addTarget:_controller action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
        [brightnessSilder1 addTarget:_controller action:@selector(brightnessDidBegin:) forControlEvents:UIControlEventTouchDown];
        [brightnessSilder1 addTarget:_controller action:@selector(brightnessChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
    }
    return self;
}

#pragma mark 更新视图布局 在横竖屏之间切换
- (void)updateSubviewsLocation {
    UIView *voiceBarView = [self viewWithTag:kVoiceViewTag];
    UIView *brightnessBarView = [self viewWithTag:kBrightnessViewTag];
    UIView *toolView = [self viewWithTag:kToolViewTag];
    UIView *lockView = [self viewWithTag:kLockViewTag];
    UIView *commentView=[self viewWithTag:kCommentViewTag];
    UIView *backgroundView=[self viewWithTag:kBackgroundViewTag];
    NSLog(NSStringFromCGRect(self.frame));
    CGSize size = self.frame.size;//当前播放器视图的大小
    [self updateProgressView];
    [self updateBarView];
    [self updateToolView];
    [self updateLockBtn];
    [self updateInfoLabel];
    
    //获得当前设备的方向
    if (self.height < [[UIScreen mainScreen] bounds].size.height){//证明此时是竖屏
        voiceBarView.hidden = YES;
        brightnessBarView.hidden = YES;
        lockView.hidden = YES;
        commentView.hidden=YES;
        backgroundView.hidden=NO;
    }
    else {
        
        brightnessBarView.center = CGPointMake(kCoverBarLeftMargin + kCoverBarWidth / 2,self.height/2);
        voiceBarView.center = CGPointMake((self.width - kCoverBarRightMargin - kCoverBarWidth / 2), self.height/2);
        voiceBarView.hidden = NO;
        brightnessBarView.hidden = NO;
        toolView.hidden = NO;
        lockView.hidden = NO;
        backgroundView.hidden=YES;
        //最主要的视图有四个
        //1、工具视图
        //2、亮度视图
        //3、声音视图
        //4、锁屏视图（按钮）
    }
}
#pragma mark 更新锁屏按钮
- (void)updateLockBtn {
    //获得锁屏按钮
    UIButton *lockBtn = (UIButton *)[self viewWithTag:kLockViewTag];
    //重置锁屏按钮的大小
    lockBtn.frame = CGRectMake(kCoverLockViewLeftMargin, (self.height - self.height / 6) / 2, self.height / 6, self.height / 6);//CGRectMake(size.width / 2 - 150, (size.height - 50) / 2, 40, 40);
}
#pragma mark 更新进度条
- (void)updateProgressView {
    UIView *progressView = [self viewWithTag:kProgressViewTag];
    CGRect progressRect = CGRectMake((self.width - 150) / 2, (self.height - 50) / 2, 150, 50);
    progressView.frame = progressRect;
}

#pragma mark 按钮视图
- (void)updateBarView {
    BOOL isLandscape = YES;//水平标志
    
    
    UIView *barView = [self viewWithTag:kBarViewtag];
    UIView *barBgView = [self viewWithTag:kBarBgViewTag];
    UIButton *fullBtn = (UIButton *)[self viewWithTag:kFullScreenBtnTag];
    UISlider *slider = (UISlider *)[self viewWithTag:kProgressSliderTag];
    UILabel *startLabel = (UILabel *)[self viewWithTag:kProgressCurLabelTag];
    UILabel *endLabel = (UILabel *)[self viewWithTag:kProgressMaxLabelTag];
    UIButton *commentBtn=(UIButton *)[self viewWithTag:kCommentBtnTag];
    UITextField *commentField=(UITextField *)[self viewWithTag:kCommentFieldTag];
    UIButton *danmuBtn=(UIButton *)[self viewWithTag:kDanmuBtnTag];
    UIButton *qualityBtn = (UIButton *)[self viewWithTag:kQualityBtnTag];
    UIButton *scaleBtn = (UIButton *)[self viewWithTag:kScaleBtnTag];
    UIButton *episodeBtn = (UIButton *)[self viewWithTag:kEpisodeBtnTag];
    CGRect barRect = CGRectMake(0, self.height - kBottomBarHeight, self.width, kBottomBarHeight);
    CGRect fullRect = CGRectMake(self.width - 40, 20, 25, 25);
    CGRect sliderRect = CGRectMake(0, -2, self.width, 10);
    CGRect startLabelRect = CGRectMake(45, 25, 55, 15);
    CGRect endLabelRect = CGRectMake(45 + 55, 25, 55, 15);
    CGRect commentFieldRect= CGRectMake(self.width - 420, 20, 100, 25);
    CGRect commentBtnRect=CGRectMake(self.width - 340, 20, 50, 25);
    CGRect danmuBtnRect=CGRectMake(self.width - 280, 20, 50, 25);
    CGRect qualityBtnRect = CGRectMake(self.width - 220, 20, 50, 25);
    CGRect scaleBtnRect = CGRectMake(self.width - 160, 20, 50, 25);
    CGRect episodeBtnRect = CGRectMake(self.width - 100, 20, 50, 25);
    
    if (self.height < [[UIScreen mainScreen] bounds].size.height){//证明此时是竖屏
        isLandscape = NO;
    }
    
    
    if (isLandscape == YES) {
        fullBtn.hidden = NO;
        qualityBtn.hidden = NO;
        scaleBtn.hidden = NO;
        episodeBtn.hidden = NO;
        danmuBtn.hidden=NO;
        commentBtn.hidden=NO;
        commentField.hidden=NO;
        
    }
    else {
        fullBtn.hidden = NO;
        qualityBtn.hidden = YES;
        scaleBtn.hidden = YES;
        episodeBtn.hidden = YES;
        danmuBtn.hidden = YES;
        commentBtn.hidden=YES;
    }
    barView.frame = barRect;
    fullBtn.frame = fullRect;
    slider.frame = sliderRect;
    startLabel.frame = startLabelRect;
    endLabel.frame = endLabelRect;
    danmuBtn.frame= danmuBtnRect;
    commentBtn.frame= commentBtnRect;
    commentField.frame= commentFieldRect;
    
    qualityBtn.frame = qualityBtnRect;
    scaleBtn.frame = scaleBtnRect;
    episodeBtn.frame = episodeBtnRect;
    barBgView.frame = barView.bounds;
    UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
    [fullBtn setImage:fullImg forState:UIControlStateNormal];
    [scaleBtn setTitle:@"16:9" forState:UIControlStateNormal];
}
#pragma mark 更新工具视图
- (void)updateToolView {
    
    UIView *toolView = [self viewWithTag:kToolViewTag];
    UIView *bgToolView = [toolView viewWithTag:kToolBgViewTag];
    UIButton *snapBtn = (UIButton *)[toolView viewWithTag:kSnapBtnTag];
    snapBtn.hidden=NO;
    CGRect toolRect = CGRectMake(0, 0, self.width, kTopBarHeight);
    toolView.frame = toolRect;
    bgToolView.frame = toolView.bounds;
    UIButton *setBtn=(UIButton *)[self viewWithTag:kSetBtnTag];
    if (self.height < [[UIScreen mainScreen] bounds].size.height)//证明此时是竖屏
    {
        setBtn.hidden=YES;
        CGRect snapBtnRect = CGRectMake(self.width - 35, (kTopBarHeight - 30) / 2, 30, 30);
        snapBtn.frame = snapBtnRect;
    }
    else
    {
        setBtn.hidden=NO;
        CGRect setBtnRect=CGRectMake(self.width-60,((kTopBarHeight - 30) / 2)+2, 50, 25);
        setBtn.frame= setBtnRect;
        CGRect snapBtnRect = CGRectMake(self.width - 100, (kTopBarHeight - 30) / 2, 30, 30);
        snapBtn.frame = snapBtnRect;
    }
    
}
#pragma mark 显示设置视图
- (void)showSetView
{
    //1.得到设置视图
    UIView *setView=[self viewWithTag:kSetViewTag];
    //2.设置视图的大小
    CGFloat setViewX=self.size.width/2;
    setView.frame=CGRectMake(setViewX, 0, 284, 500);
    setView.hidden=NO;
}
#pragma mark 更新信息标签
- (void)updateInfoLabel {
    CGSize size = self.frame.size;
    
    if ((NSInteger)size.height == (NSInteger)[[UIScreen mainScreen] bounds].size.height) {
        CGFloat temp = size.width;
        size.width = size.height;
        size.height = temp;
    }
    
    UILabel *cpuLabel = (UILabel *)[self viewWithTag:kCPULabel];
    UILabel *memLabel = (UILabel *)[self viewWithTag:kMemLabel];
    cpuLabel.frame = CGRectMake(0, 0, 480, 20);
    memLabel.frame = CGRectMake(0, 30, 480, 20);
}


@end
