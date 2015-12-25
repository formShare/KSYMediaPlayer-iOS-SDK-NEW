//
//  KSYBottomView2.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYBottomView2.h"

@implementation KSYBottomView2

//初始化(申请内存、赋初始值)
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma 添加子视图
- (void)initSubViews
{
    //设置背景色
    self.backgroundColor=[UIColor blackColor];
    self.alpha=0.6;
    
    
    //播放暂停按钮
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame=CGRectMake(10, 5, 30, 30);
    [self addSubview:playBtn];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加用户头像
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(playBtn.right+10, 5, 30, 30)];
    [self addSubview:imageView];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.image=[UIImage imageNamed:@"userName.png"];
    
    //添加标签
    UILabel *fansCount=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 5, 30, 30)];
    [fansCount sizeToFit];//编译的作用
    
}
#pragma mark 按钮响应事件
- (void)playBtnClick
{
    if (self.clickPlayBtn) {
        self.clickPlayBtn();
    }
}
@end
