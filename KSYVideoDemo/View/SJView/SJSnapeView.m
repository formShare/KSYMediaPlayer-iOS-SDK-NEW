//
//  SJSnapeView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/23.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "SJSnapeView.h"

@implementation SJSnapeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews
{
    self.backgroundColor = [UIColor clearColor];
    UIView *noticeBgView = [[UIView alloc] initWithFrame:self.bounds];
    noticeBgView.backgroundColor = [UIColor blackColor];
    noticeBgView.alpha = 0.6f;
    noticeBgView.layer.masksToBounds = YES;
    noticeBgView.layer.cornerRadius = 3;
    [self addSubview:noticeBgView];
    
    // **** mark
    CGRect imgRect = CGRectMake(32, 7, 36, 36);
    UIImageView *completeImgView = [[UIImageView alloc] initWithFrame:imgRect];
    UIImage *snapCompleteImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_complete_normal"];
    completeImgView.image = snapCompleteImg;
    [self addSubview:completeImgView];
    
    CGRect labelRect = CGRectMake(0, 57, 100, 36);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.text = @"截图成功";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];

}
@end
