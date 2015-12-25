//
//  KSYBottomView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//  

#import "KSYBottomView.h"


@implementation KSYBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self addSubViews];
    }
    return self;
}
#pragma mark 添加底部视图
- (void)addSubViews
{
    self.backgroundColor=[UIColor clearColor];
    self.alpha=0.6;
    
    //播放按钮 播放时间 进度条 总时间
    UIButton *kShortPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kShortPlayBtn.alpha = 0.6;
    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
    [kShortPlayBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [kShortPlayBtn setImage:pauseImg_n forState:UIControlStateNormal];
    [kShortPlayBtn setImage:pauseImg_h forState:UIControlStateHighlighted];
    kShortPlayBtn.frame = CGRectMake(10, 5, 30, 30);
    [kShortPlayBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:kShortPlayBtn];
    kShortPlayBtn.tag=kShortPlayBtnTag;

    

    //播放时间
    UILabel *kCurrentLabel=[[UILabel alloc]initWithFrame:CGRectMake(kShortPlayBtn.right+10, kShortPlayBtn.center.y-15, 60, 30)];
    [self addSubview:kCurrentLabel];
    kCurrentLabel.textColor=[UIColor whiteColor];
    kCurrentLabel.text=@"00:00";
    kCurrentLabel.textColor=[UIColor whiteColor];
    kCurrentLabel.textAlignment = NSTextAlignmentRight;
    kCurrentLabel.tag=kCurrentLabelTag;
    kCurrentLabel.font = [UIFont boldSystemFontOfSize:13];
//    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
//    kCurrentLabel.textColor = tintColor;
    
    
    //进度条
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    UIImage *minImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"slider_color"];
    UISlider *kPlaySlider=[[UISlider alloc]initWithFrame:CGRectMake(kCurrentLabel.right+10, kCurrentLabel.center.y-5, self.width-kCurrentLabel.right-10-80, 10)];
    [kPlaySlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
    kPlaySlider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    [kPlaySlider setThumbImage:dotImg forState:UIControlStateNormal];
    [kPlaySlider addTarget:self action:@selector(progressDidBegin:) forControlEvents:UIControlEventTouchDown];
    [kPlaySlider addTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
    [kPlaySlider addTarget:self action:@selector(progressChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
    kPlaySlider.value = 0.0;
    kPlaySlider.tag = kPlaySliderTag;
    [self addSubview:kPlaySlider];
    
    //总时间
    UILabel *kTotalLabel=[[UILabel alloc]initWithFrame:CGRectMake(kPlaySlider.right+10, kShortPlayBtn.center.y-15, 60, 30)];
    kTotalLabel.tag=kTotalLabelTag;
    [self addSubview:kTotalLabel];
    kTotalLabel.text=@"00:00";
    kTotalLabel.textColor=[UIColor whiteColor];
    kTotalLabel.alpha = 0.6;
    kTotalLabel.font = [UIFont boldSystemFontOfSize:13];
    
    //全屏按钮
    
}

- (void)progressDidBegin:(UISlider *)slider
{
    if (self.progressDidBegin)
    {
        self.progressDidBegin(slider);
    }
}

- (void)progressChanged:(UISlider *)slider {
    
    if (self.progressChanged)
    {
        self.progressChanged(slider);
    }
    
}

- (void)progressChangeEnd:(UISlider *)slider {
    if(self.progressChangeEnd)
    {
        self.progressChangeEnd(slider);
    }
}
- (void)playBtnClick:(UIButton *)btn
{
    if (self.BtnClick) {
        self.BtnClick(btn);
    }
}



@end
