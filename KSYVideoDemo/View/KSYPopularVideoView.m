//
//  KSYPopularVideoView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPopularVideoView.h"

@implementation KSYPopularVideoView

- (instancetype)initWithFrame:(CGRect)frame UrlWithString:(NSString *)urlString playState:(KSYPopularLivePlayState)playState;
{

    self = [super initWithFrame:frame];//初始化父视图的(frame、url)
    if (self) {
        WeakSelf(KSYPopularVideoView);
        self.ksyVideoPlayerView=[[KSYVideoPlayerView alloc]initWithFrame: CGRectMake(0, 0, self.width, self.height/2) UrlFromString:urlString playState:playState];
        self.ksyVideoPlayerView.lockScreen=^(BOOL isLocked){
            [weakSelf lockTheScreen:isLocked];
        };
        self.ksyVideoPlayerView.clickFullBtn=^(){
            [weakSelf FullScreen];
        };
        self.ksyVideoPlayerView.clicUnkFullBtn=^(){
            [weakSelf unFullScreen];
        };
        [self addSubview:self.ksyVideoPlayerView];
        [self addDetailView];
        [self addCommtenView];
        [self registerObservers];
    }
    return self;

}


#pragma mark 退出全屏模式
- (void)changeDeviceOrientation:(UIInterfaceOrientation)toOrientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = toOrientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)FullScreen{
    [self changeDeviceOrientation:UIInterfaceOrientationLandscapeRight];
    [self lunchFull];
}
- (void)unFullScreen{
    [self changeDeviceOrientation:UIInterfaceOrientationPortrait];
    [self unLunchFull];
}
- (void)lunchFull{
    self.frame=[UIScreen mainScreen].bounds;
    self.ksyVideoPlayerView.frame=self.frame;
    [self.ksyVideoPlayerView lunchFullScreen];
    self.detailView.hidden=YES;
    self.commtenView.hidden=YES;
}
- (void)unLunchFull{

    if (self.ksyVideoPlayerView.isLock) {
        return;
    }
    CGRect frame=[UIScreen mainScreen].bounds;
    self.frame=CGRectMake(0, 64, frame.size.width, frame.size.height-64);
    NSLog(NSStringFromCGRect(self.frame));
    self.ksyVideoPlayerView.frame=CGRectMake(0, 0,self.frame.size.width,self.frame.size.height/2);
    NSLog(NSStringFromCGRect(self.ksyVideoPlayerView.frame));
    [self.ksyVideoPlayerView minFullScreen];
    self.detailView.hidden=NO;
    self.commtenView.hidden=NO;
}
- (void)lockTheScreen:(BOOL)islocked{
    if (self.lockWindow) {
        self.lockWindow(islocked);
    }
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
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.commtenView.frame=CGRectMake(0, self.height-40, self.width, 40);
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];
}
#pragma mark 注册通知
- (void)registerObservers
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
#pragma mark 移除通知
- (void)unregisterObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}
- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        UIDeviceOrientation  orientation=[[UIDevice currentDevice] orientation];
        if (orientation == UIDeviceOrientationLandscapeRight) {
            if (!KSYSYS_OS_IOS8) {
                [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
            else {
            }
        }
        else {
            if (!KSYSYS_OS_IOS8) {
                [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
                
            }
            else {
            }
        }
        if (self.changeNavigationBarColor) {
            self.changeNavigationBarColor();
        }

        [self lunchFull];
    }
    else if (orientation == UIDeviceOrientationPortrait)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        [self unLunchFull];
    }
}

@end
