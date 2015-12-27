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
    
//    UIColor *tintColor = [[ThemeManager sharedInstance] themeColor];
    
    //开始按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.alpha = 0.6;
    UIImage *pauseImg_n = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_normal"];
    UIImage *pauseImg_h = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_pause_hl"];
    [playBtn setImage:pauseImg_n forState:UIControlStateNormal];
    [playBtn setImage:pauseImg_h forState:UIControlStateHighlighted];
    playBtn.frame = CGRectMake(10, 5, 30, 30);
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    
    //添加用户头像
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(playBtn.right+10, 5, 30, 30)];
    [self addSubview:imageView];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.image=[UIImage imageNamed:@"userName.png"];
    
    //添加标签
    UILabel *fansCount=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 5, 30, 30)];
    [fansCount sizeToFit];//编译的作用
    fansCount.text=@"2000";
    [self addSubview:fansCount];
    
    //添加文本框
    CGRect commentTextRect=CGRectMake(fansCount.right+10, 5, self.width-fansCount.right-60, 30);
    UITextField *commentText=[[UITextField alloc]initWithFrame:commentTextRect];
    [self addSubview:commentText];
    commentText.placeholder=@"填写评论内容";
    [commentText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [commentText setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    commentText.borderStyle=UITextBorderStyleRoundedRect;
    commentText.delegate=self;
    
    //添加全屏按钮
    CGRect fullBtnRect = CGRectMake(self.width - 40, 5, 30, 30);
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullBtn.alpha = 0.6;
    UIImage *fullImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_fullscreen_normal"];
    [fullBtn setImage:fullImg forState:UIControlStateNormal];
    fullBtn.frame = fullBtnRect;
    [fullBtn addTarget:self action:@selector(FullBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fullBtn];
    
    
}
#pragma mark 按钮响应事件
- (void)playBtnClick:(UIButton *)btn
{
    if (self.clickPlayBtn) {
        self.clickPlayBtn(btn);
    }
}
#pragma mark 全屏按钮响应事件
- (void)FullBtnclick:(UIButton *)btn
{
    if (self.clickFullBtn) {
        self.clickFullBtn(btn);
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.textFildDidBeginEditing) {
        self.textFildDidBeginEditing(textField);
    }
}
@end
