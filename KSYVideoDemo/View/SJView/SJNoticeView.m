//
//  SJNoticeView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/23.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "SJNoticeView.h"

@implementation SJNoticeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 5;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        
        self.noticeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.noticeLabel.textAlignment = NSTextAlignmentCenter;
        self.noticeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.noticeLabel];

    }
    return self;
}


@end
