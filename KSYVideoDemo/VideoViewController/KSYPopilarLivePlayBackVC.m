//
//  KSYPopilarLivePlayBackVC.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPopilarLivePlayBackVC.h"
#import "KSYVideoPlayerView.h"

@interface KSYPopilarLivePlayBackVC ()
{
    KSYVideoPlayerView *ksyPoularbackView;
}
@end

@implementation KSYPopilarLivePlayBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置导航栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //2.设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //修改导航栏模式
    [self changeNavigationStayle];
    //初始化视图
    ksyPoularbackView=[[KSYVideoPlayerView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) urlString:[NSString stringWithFormat: @"http://121.42.58.232:8980/hls_test/1.m3u8"] playState:KSYPopularPlayBack];
    WeakSelf(KSYPopilarLivePlayBackVC);
    ksyPoularbackView.changeNavigationBarColor=^(){
        [weakSelf changeNavigationBarCLO];
        
    };
    [self.view addSubview:ksyPoularbackView];
    
}
- (void)changeNavigationBarCLO
{
    self.navigationController.navigationBar.alpha=0.0;
    //修改导航栏左侧Item
    
}
- (void)changeNavigationStayle
{
    //设置返回按钮
    UIButton *ksyBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ksyBackBtn.frame=CGRectMake(5, 5, 40, 30);
    [ksyBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [ksyBackBtn setTitleColor:KSYCOLER(52, 211, 220) forState:UIControlStateNormal];
    ksyBackBtn.titleLabel.font=[UIFont systemFontOfSize:WORDFONT16];
    [ksyBackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:ksyBackBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    //添加标题标签
    UILabel *ksyTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    ksyTitleLabel.text=@"视频标题";
    ksyTitleLabel.textColor=[UIColor whiteColor];
    ksyTitleLabel.textAlignment=NSTextAlignmentCenter;
    ksyTitleLabel.font=[UIFont systemFontOfSize:WORDFONT18];
    ksyTitleLabel.center=self.navigationItem.titleView.center;
    self.navigationItem.titleView = ksyTitleLabel;
    
    
    //添加选项按钮
    UIButton *ksyMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ksyMenuBtn.frame=CGRectMake(self.view.right-45, 5, 40, 30);
    [ksyMenuBtn setTitle:@"选项" forState:UIControlStateNormal];
    [ksyMenuBtn setTitleColor:KSYCOLER(52, 211, 220) forState:UIControlStateNormal];
    ksyMenuBtn.titleLabel.font=[UIFont systemFontOfSize:WORDFONT16];
    [ksyMenuBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:ksyMenuBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
- (void)back
{
    [ksyPoularbackView.player stop];
    [self.navigationController popViewControllerAnimated:YES];
    //修改状态栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
}
- (void)menu
{
    
}

@end
