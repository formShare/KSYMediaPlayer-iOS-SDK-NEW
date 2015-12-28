//
//  KSYShortVideoPlayVC.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYShortVideoPlayVC.h"
#import "Model1.h"
#import "KSY1TableViewCell.h"
#import "Model2.h"
#import "KSY2TableViewCell.h"
#import "Model3.h"
#import "KSY3TableViewCell.h"
#import "ThemeManager.h"
#import "MediaControlViewController.h"
#import "KSYShortVideoPlayView.h"

@interface KSYShortVideoPlayVC ()
{
    KSYShortVideoPlayView *ksyShortVideoplayView;
    //播放器状态
    BOOL isAutoPlay;        //是否自动播放
    BOOL isPlaying;         //是否正在播放
    BOOL isPreperded;       //是否准备播放
    BOOL isCompleted;       //是否播放完毕
    BOOL isCyclePlay;       //是否自动播放
    BOOL isActive;          //是否
    BOOL isEnd;             //是否结束
    BOOL isRtmp;            //是否是rtmp直播
    BOOL pauseInBackground; //是否进入后台
    BOOL isKSYPlayerPling;
    NSMutableArray *_models;
    NSMutableArray *_modelsCells;
}
@property (nonatomic, strong) KSYBasePlayView *phoneLivePlayVC;
@property (nonatomic, strong) UIView * kShortBackgroundView;
@property (nonatomic, strong) UISegmentedControl * kShortSegmentedCTL;
@property (nonatomic, strong) UITableView * kShortTableView;
@property (nonatomic, strong) UIView * kShortTopView;
@property (nonatomic, strong) UIView * kShortBottomView;
@property (nonatomic, strong) UIView * kShortLodingView;
@property (nonatomic, strong) UIView * kShortErrorView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat curPosition;
@property (nonatomic, assign) KSYGestureType gestureType;
@end

@implementation KSYShortVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置导航栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //2.设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //修改导航栏模式
    [self changeNavigationStayle];
    //初始化视图
    ksyShortVideoplayView=[[KSYShortVideoPlayView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) UrlPathString:[[NSBundle mainBundle]pathForResource:@"a" ofType:@"mp4"]];
    [self.view addSubview:ksyShortVideoplayView];
    
}

#pragma mark 改变导航栏状态
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

#pragma mark 转到另一个控制器
- (void)back
{
    [ksyShortVideoplayView.videoCell.ksyShortView stop];
    [self.navigationController popViewControllerAnimated:YES];
    //修改状态栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
}
- (void)menu
{
    
}

@end
