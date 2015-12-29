//
//  KSYPopularVideoView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPopularVideoView.h"


@implementation KSYPopularVideoView

- (instancetype)initWithFrame:(CGRect)frame UrlFromString:(NSString *)urlString
{
    //重置播放界面的大小
    self = [super initWithFrame:frame urlString:urlString];//初始化父视图的(frame、url)
    if (self) {
        self.player.view.frame=CGRectMake(0, 0, self.width, self.height/2);
        self.indicator.center=self.player.view.center;
        ThemeManager *themeManager = [ThemeManager sharedInstance];
        //    [themeManager changeTheme:@"blue"];
        //    [themeManager changeTheme:@"green"];
        //    [themeManager changeTheme:@"orange"];
        //    [themeManager changeTheme:@"pink"];
        [themeManager changeTheme:@"red"];
        [self addDetailView];
        [self addCommtenView];
    }
    return self;

}
#pragma mark 添加详细视图
- (void)addDetailView
{
    _detailView=[[SJDetailView alloc]initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
    [self addSubview: _detailView];
}
#pragma mark 添加底部评论视图
- (void)addCommtenView
{
    WeakSelf(KSYPopularVideoView);
    _commtenView=[[KSYCommentView alloc]initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
    _commtenView.textFieldDidBeginEditing=^{
        [weakSelf changeTextFrame];
    };
    _commtenView.send=^{
        [weakSelf resetTextFrame];
    };
    [self addSubview:_commtenView];
}
- (void)changeTextFrame
{
    //执行动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGFloat kCommentViewY=self.height/2-40;
        self.commtenView.frame=CGRectMake(0,  kCommentViewY, self.width, 40);
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];
    
}
- (void)resetTextFrame
{
    UITextField *textField=(UITextField *)[self viewWithTag:kCommentFieldTag];
    [textField resignFirstResponder];
    //执行动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.commtenView.frame=CGRectMake(0, self.height-40, self.width, 40);
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];
}

@end
