//
//  KSYProgressToolBar.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/17.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYProgressToolBar.h"
#import "UIView+BFExtension.h"
#import "ThemeManager.h"
@interface KSYProgressToolBar ()

@property (strong, nonatomic) UIButton  *controCommentButton;
@property (strong, nonatomic) UIButton  *shareButton;
@property (strong, nonatomic) UIButton  *playControlButton;
@property (strong, nonatomic) UISlider  *slider;
@property (strong, nonatomic) UILabel   *timeLabel;
@end

@implementation KSYProgressToolBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.controCommentButton];
        [self addSubview:self.shareButton];
        [self addSubview:self.playControlButton];
        [self addSubview:self.slider];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.controCommentButton.frame = CGRectMake(10, 5, 30, 30);
    self.playControlButton.frame = CGRectMake(self.controCommentButton.right + 8, 5, 30, 30);

    self.slider.frame = CGRectMake(_playControlButton.right + 6, 5, self.frame.size.width - 120 - 36, 30);
    self.shareButton.frame = CGRectMake(_slider.right + 10, 5, 30, 30);
    self.timeLabel.frame = CGRectMake(self.slider.left, self.slider.bottom - 10, self.slider.frame.size.width - 8, 20);
}
- (UIButton *)controCommentButton
{
    if (!_controCommentButton) {
        _controCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _controCommentButton.backgroundColor = [UIColor purpleColor];
    }
    return _controCommentButton;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = [UIColor greenColor];
    }
    return _shareButton;
}

- (UIButton *)playControlButton
{
    if (!_playControlButton) {
        _playControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playControlButton.backgroundColor = [UIColor orangeColor];
        [_playControlButton addTarget:self action:@selector(playControlButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playControlButton;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [UISlider new];
        [_slider addTarget:self action:@selector(progressDidBegin:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(progressChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        _slider.value = 0.0;

        _slider.maximumTrackTintColor = [UIColor whiteColor];
        [[ThemeManager sharedInstance] changeTheme:@"red"];

        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
        [_slider setThumbImage:dotImg forState:UIControlStateNormal];

    }
    
    return _slider;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}
- (void)updataSliderWithPosition:(NSInteger)position duration:(NSInteger)duration
{
    self.slider.value = position;
    self.slider.maximumValue = duration;
    int iDuraMin  = (int)(duration / 60);
    int iDuraSec  = (int)(duration % 3600 % 60);
    
    int iPosMin  = (int)(position / 60);
    int iPosSec  = (int)(position % 3600 % 60);

    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d / %02d:%02d ",iPosMin,iPosSec, iDuraMin, iDuraSec];

}

- (void)playControlButtonEvent:(UIButton *)button
{
    button.selected = !button.selected;

    if (self.playControlEventBlock) {
        self.playControlEventBlock(button.selected);
    }
    if (!button.selected) {
        _playControlButton.backgroundColor = [UIColor orangeColor];

    }else{
        _playControlButton.backgroundColor = [UIColor magentaColor];

    }
}

- (void)playerStop
{
    self.playControlButton.selected = YES;
    _playControlButton.backgroundColor = [UIColor magentaColor];

}
- (void)progressDidBegin:(UISlider *)slider
{
    
    if (self.playControlEventBlock) {
        self.playControlEventBlock(YES);
    }
}
- (void)progressChanged:(UISlider *)slider
{
    if (self.seekToBlock) {
        self.seekToBlock(slider.value);
    }
}
- (void)progressChangeEnd:(UISlider *)slider
{
    if (self.playControlEventBlock) {
        self.playControlEventBlock(NO);
    }
}
@end
