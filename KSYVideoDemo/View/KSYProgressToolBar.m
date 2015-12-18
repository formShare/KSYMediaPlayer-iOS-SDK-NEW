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
    }
    return _playControlButton;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [UISlider new];
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        [[ThemeManager sharedInstance] changeTheme:@"red"];

        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
        [_slider setThumbImage:dotImg forState:UIControlStateNormal];

    }
    
    return _slider;
}
@end
