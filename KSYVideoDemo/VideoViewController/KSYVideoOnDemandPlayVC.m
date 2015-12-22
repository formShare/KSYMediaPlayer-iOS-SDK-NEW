//
//  KSYVideoOnDemandPlayVC.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYVideoOnDemandPlayVC.h"
#import "MediaControlViewController.h"
#import "MediaControlView.h"
#import "KSBarrageView.h"
#import "Model1.h"
#import "KSY1TableViewCell.h"
#import "Model2.h"
#import "KSY2TableViewCell.h"
#import "Model3.h"
#import "KSY3TableViewCell.h"
#import "MediaControlDefine.h"
#import "KSYDefine.h"


@interface KSYVideoOnDemandPlayVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) KSYPlayer *player;
@property (nonatomic) CGRect previousBounds;
@property (nonatomic, strong) UIView *kBackgroundView;//下部视图
@property (nonatomic, strong) UISegmentedControl *kSegmentedCTL;//分段控制器
@property (nonatomic, strong) UITableView *kTableView;//表视图
@end

@implementation KSYVideoOnDemandPlayVC{
    //这个控制器调用AMZPlayer的接口
    MediaControlViewController *_mediaControlViewController;
    BOOL    _isRtmp;     //是否是rtmp直播
    UIView *_demoView;
    UITableView *_tableView;
    NSMutableArray *_models;
    NSMutableArray *_modelsCells;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置导航栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //修改导航栏模式
    [self changeNavigationStayle];
    
    _isCycleplay = NO;
    _beforeOrientation = UIDeviceOrientationPortrait;
    _pauseInBackground = YES;
    _motionInterfaceOrientation = UIInterfaceOrientationMaskLandscape;
    self.view.backgroundColor = [UIColor whiteColor];
    //    NSString *path=[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp4"];
    //    _videoUrl=[NSURL URLWithString:path];
    [self initPlayerWithLowTimelagType:NO];
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

#pragma mark 初始化低延时模式
- (void)initPlayerWithLowTimelagType:(BOOL)isLowTimeType {
    
    
    //实例化播放器 AMZPlayer是在OC层面封装的一个播放起 而MediaPlayer是ffmpeg提供的播放器
    _player = [[KSYPlayer alloc] initWithURL:_videoUrl];
    //使能自动播放
    _player.shouldAutoplay = YES;
    //准备播放
    [_player prepareToPlay];
    //把播放器视图添加到当前界面上
    [self.view addSubview:_player.videoView];
    //设置播放器播放视图的大小
    _player.videoView.frame = CGRectMake(0,64,self.view.width,(self.view.bottom-64)/2);
    self.previousBounds=_player.videoView.bounds;
    //设置视图背景颜色
    _player.videoView.backgroundColor = [UIColor lightGrayColor];
    //初始化控制器（这个控制器用来调用AMZPlayer的接口）
    _mediaControlViewController = [[MediaControlViewController alloc] init];
    _mediaControlViewController.delegate = self;
    _mediaControlViewController.view.frame=CGRectMake(0, 0, _player.videoView.width, _player.videoView.height);
    [_player.videoView addSubview:_mediaControlViewController.view];
    //self.view添加了两个视图：_player.view (播放界面用于KSYMdiaController进行交互)_mediaControllerViewController.view（用于控的改变）
    [_player setScalingMode:MPMovieScalingModeAspectFit];
    //如果是低延时模式
    if (isLowTimeType) {
        [_player playerSetUseLowLatencyWithBenable:1 maxMs:3000 minMs:500];
    }
    //添加通知设备方向改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    //注册其他通知
    [self registerApplicationObservers];
    //添加水平滚动视图
    //    [self addToptabControl];
    [self addBellowPart];
}
#pragma mark 添加下面的内容(就两个字，去做，动手去做)
- (void)addBellowPart
{
    CGFloat backgroundViewX=0;
    CGFloat backgroundViewY=_player.videoView.bottom;
    CGFloat backgroundVieWidth=THESCREENWIDTH;
    CGFloat backgroundViewHeight=_player.videoView.width;
    CGRect backgroundViewRect=CGRectMake(backgroundViewX, backgroundViewY, backgroundVieWidth, backgroundViewHeight);
    //在这里初始化
    self.kBackgroundView=[[UIView alloc]initWithFrame:backgroundViewRect];
    self.kBackgroundView.tag=kBackgroundViewTag;
    self.kBackgroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.kBackgroundView];
    //初始化分段控制器
    NSArray *segmentedArray=[NSArray arrayWithObjects:@"评论",@"详情",@"推荐", nil];
    self.kSegmentedCTL=[[UISegmentedControl alloc]initWithItems:segmentedArray];
    self.kSegmentedCTL.frame=CGRectMake(10, 10, THESCREENWIDTH-20, 30);
    [self.kBackgroundView addSubview:self.kSegmentedCTL];
    [self.kSegmentedCTL addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.kSegmentedCTL.selectedSegmentIndex=0;
    //添加一个分割线
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.kSegmentedCTL.frame)+10, THESCREENWIDTH, 1)];
    lineLabel.backgroundColor=[UIColor blackColor];
    [self.kBackgroundView addSubview:lineLabel];
    //初始化表视图 只要你在做你就在想
    self.kTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame)+10, THESCREENWIDTH, THESCREENHEIGHT/2-60) style:UITableViewStylePlain];
    self.kTableView.userInteractionEnabled=YES;
    [self.kBackgroundView addSubview:self.kTableView];
    self.kTableView.delegate=self;
    self.kTableView.dataSource=self;
    [self segmentChange:self.kSegmentedCTL];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.kSegmentedCTL.selectedSegmentIndex==1)
    {
        return 1;
    }
    return   _models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.kSegmentedCTL.selectedSegmentIndex==0)
    {
        KSY1TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"KSY1TableViewCellIdentify"];
        if (cell==nil)
        {
            cell=[[KSY1TableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"KSY1TableViewCellIdentify"];
            UIView* tempView=[[UIView alloc] initWithFrame:cell.frame];
            tempView.backgroundColor =KSYCOLER(90, 90, 90);
            cell.backgroundView = tempView;  //更换背景色     不能直接设置backgroundColor
            UIView* tempView1=[[UIView alloc] initWithFrame:cell.frame];
            tempView1.backgroundColor = KSYCOLER(100, 100, 100);
            cell.selectedBackgroundView = tempView1;
            
        }
        Model1 *SKYmodel=_models[indexPath.row];
        cell.model1=SKYmodel;
        return cell;
    }
    else if (self.kSegmentedCTL.selectedSegmentIndex==1)
    {
        KSY2TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"KSY2TableViewCellIdentify"];
        if (cell==nil)
        {
            cell=[[KSY2TableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"KSY2TableViewCellIdentify"];
        }
        Model2 *SKYmodel=_models[indexPath.row];
        cell.model2=SKYmodel;//调用set方法
        return cell;
        
    }
    else if (self.kSegmentedCTL.selectedSegmentIndex==2)
    {
        KSY3TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"KSY3TableViewCellIdentify"];
        if (cell==nil)
        {
            cell=[[KSY3TableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"KSY3TableViewCellIdentify"];
        }
        Model3 *SKYmodel=_models[indexPath.row];
        cell.model3=SKYmodel;//调用set方法
        return cell;
        
    }
    else
        return nil;
}
#pragma mark tableViewDelegate 表视图代理方法
#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.kSegmentedCTL.selectedSegmentIndex==0)
    {
        KSY1TableViewCell *cell=_modelsCells[indexPath.row];
        cell.model1=_models[indexPath.row];//这里执行set方法
        return cell.height;
    }
    else if (self.kSegmentedCTL.selectedSegmentIndex==1)
    {
        KSY2TableViewCell *cell=_modelsCells[indexPath.row];
        cell.model2=_models[indexPath.row];//这里执行set方法
        return cell.height;
    }
    else if (self.kSegmentedCTL.selectedSegmentIndex==2)
    {
        KSY3TableViewCell *cell=_modelsCells[indexPath.row];
        cell.model3=_models[indexPath.row];//这里执行set方法
        return cell.height;
        
    }
    else
        
        return 0;
    
}

#pragma mark 分段控件只发生变化，想是你的本能，重要的是做了啥
- (void)segmentChange:(UISegmentedControl *)segment
{
    //如果是评论，加载评论的数据
    if(segment.selectedSegmentIndex==0)
    {
        //每次进来都要重新刷新数据
        [_models removeAllObjects];
        [_modelsCells removeAllObjects];
        NSString *path=[[NSBundle mainBundle] pathForResource:@"Model1" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        _models=[[NSMutableArray alloc]init];
        _modelsCells=[[NSMutableArray alloc]init];
        //利用代码块遍历
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_models addObject:[Model1 modelWithDictionary:obj]];
            KSY1TableViewCell *cell=[[KSY1TableViewCell alloc]init];
            [_modelsCells addObject:cell];
        }];
        [self.kTableView reloadData];
    }
    //如果是详情，获取详情的数据
    else if(segment.selectedSegmentIndex==1)
    {
        //根据路径获得字典
        [_models removeAllObjects];
        [_modelsCells removeAllObjects];
        NSString *path=[[NSBundle mainBundle]pathForResource:@"Model2" ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        [_models addObject:[Model2 modelWithDictionary:dict]];
        KSY2TableViewCell *cell=[[KSY2TableViewCell alloc]init];
        [_modelsCells addObject:cell];
        //这样做复杂啦换一种方法
        
        [self.kTableView reloadData];
        
    }
    //如果是推荐，获取推荐的数据
    else if(segment.selectedSegmentIndex==2)
    {
        [_models removeAllObjects];
        [_modelsCells removeAllObjects];
        NSString *path=[[NSBundle mainBundle] pathForResource:@"Model3" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        _models=[[NSMutableArray alloc]init];
        _modelsCells=[[NSMutableArray alloc]init];
        //利用代码块遍历
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_models addObject:[Model3 modelWithDictionary:obj]];
            KSY3TableViewCell *cell=[[KSY3TableViewCell alloc]init];
            [_modelsCells addObject:cell];
        }];
        [self.kTableView reloadData];
        
    }
}

- (void)registerApplicationObservers
{
    
    //应用开始运行
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //应用将要重新开始
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    //应用进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //应用将要关闭
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}
/**
 *  移除通知
 */
- (void)unregisterApplicationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

/**
 *  应用启动
 */
- (void)applicationDidBecomeActive
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //如果是直播的话
        if (_isRtmp) {
            //取得AMZPlyer播放器单例（单例模式）
            _player.shouldAutoplay = YES;
            //播放器准备播放
            [_player prepareToPlay];
            //设置播放器的播放界面
            _player.videoView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/2);
            _player.videoView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_player.videoView];
            [self.view addSubview:_mediaControlViewController.view];
            //添加水平滚动视图
            //            [self addToptabControl];
            //viewController的视图中有两个视图（1、AMZPlayer的view 2、mediaControllerViewController的view）
            [_player setScalingMode:MPMovieScalingModeAspectFit];
            
            [_player playerSetUseLowLatencyWithBenable:1 maxMs:3000 minMs:500];
            
            
        }else {//如果不是直播
            if (![_player isPlaying]) {
                [self play];
            }
            
        }
        
    });
    
}
/**
 *  应用将要关闭
 */
- (void)applicationWillResignActive
{
    //获得主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //如果应用在后台并且在播放
        if (_pauseInBackground && [_player isPlaying]) {
            //如果是直播
            if (_isRtmp) {
                //播放器关闭
                [_player shutdown];
                //将mediaControllerViewController的视图从当前视图中移除
                [_mediaControlViewController.view removeFromSuperview];
                
            }else {
                [self pause];
            }
        }
    });
    
}
/**
 *  应用已经进入后台
 */
- (void)applicationDidEnterBackground
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_pauseInBackground && [_player isPlaying]) {
            if (_isRtmp) {
                [_player shutdown];
                
            }else {
                [self pause];
            }
            
        }
    });
}
/**
 *  应用将要关闭
 */
- (void)applicationWillTerminate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_pauseInBackground && [_player isPlaying]) {
            if (_isRtmp) {
                [_player shutdown];
                
            }else {
                [self pause];
            }
            
        }
    });
}
/**
 *  设备的方向发生改变（最重要的是你做了啥，做了几遍）其他的都不重要
 *
 *  @param notification 设备的方向
 */
- (void)orientationChanged:(NSNotification *)notification
{
    //获得当前设备的方向
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //如果当前方向是竖直方向
    if (orientation == UIDeviceOrientationPortrait)
    {
        //那么设备方向就变为竖直方向
        self.deviceOrientation = orientation;
        //播放器界面最小化
        [self minimizeVideo];
        UIView *backgroundView=[self.view viewWithTag:kBackgroundViewTag];
        backgroundView.hidden=NO;
    }
    else if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
    {
        //同理
        self.deviceOrientation = orientation;
        [self launchFullScreen];
        UIView *backgroundView=[self.view viewWithTag:kBackgroundViewTag];
        backgroundView.hidden=YES;
    }
}
/**
 *  全屏显示
 */
- (void)launchFullScreen
{
    
    [self launchFullScreenWhileUnAlwaysFullscreen];
    
}
/**
 *  播放界面最小化
 */
- (void)minimizeVideo
{
    [self minimizeVideoWhileUnAlwaysFullScreen];
}

#pragma mark 当全屏按钮被点击后视频变为全屏
- (void)launchFullScreenWhileUnAlwaysFullscreen
{
    //得到设备当前的方向
    UIDeviceOrientation  orientation=[[UIDevice currentDevice] orientation];
    //当设备的方向是横屏时
    if (orientation == UIDeviceOrientationLandscapeRight) {
        //如果不是IOS8时
        if (!KSYSYS_OS_IOS8) {
            //将状态栏改变为水平方向
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
    self.navigationController.navigationBar.hidden=YES;
    //设置播放器视图的中心点
    [_player.videoView setCenter:CGPointMake(self.view.width/2, self.view.height/2)];
    //设置为全屏
    _player.videoView.bounds = CGRectMake(0, 0,self.view.width , self.view.height);
    MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
    mediaControlView.center =_player.videoView.center;
    mediaControlView.bounds =_player.videoView.bounds;
    [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
}
/**
 *  不总是全屏时的全屏
 */
- (void)minimizeVideoWhileUnAlwaysFullScreen{
    
    //导航栏不隐藏
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    _player.videoView.frame = CGRectMake(0,64,self.view.width,(self.view.bottom-64)/2);
    MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
    mediaControlView.frame = _player.videoView.bounds;
    [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
    
}



- (void)getVideoState
{
    //    //NSLog(@"[_player state] = = =%d",[_player state]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (KSYPlayer *)player {
    return _player;
}

#pragma mark - KSYMediaPlayDelegate
#pragma mark KSYMediaPlayer的代理在ViewController中实现
- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)stop {
    [_player stop];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (void)shutdown {
    [_player shutdown];
}

- (void)seekProgress:(CGFloat)position {
    [_player setCurrentPlaybackTime:position];
}

- (void)setVideoQuality:(KSYVideoQuality)videoQuality {
    //NSLog(@"set video quality");
}

- (void)setVideoScale:(KSYVideoScale)videoScale {
    CGRect videoRect = [[UIScreen mainScreen] bounds];
    NSInteger scaleW = 16;
    NSInteger scaleH = 9;
    switch (videoScale) {
        case kKSYVideo16W9H:
            scaleW = 16;
            scaleH = 9;
            break;
        case kKSYVideo4W3H:
            scaleW = 4;
            scaleH = 3;
            break;
        default:
            break;
    }
    if (videoRect.size.height >= videoRect.size.width * scaleW / scaleH) {
        videoRect.origin.x = 0;
        videoRect.origin.y = (videoRect.size.height - videoRect.size.width * scaleW / scaleH) / 2;
        videoRect.size.height = videoRect.size.width * scaleW / scaleH;
    }
    else {
        videoRect.origin.x = (videoRect.size.width - videoRect.size.height * scaleH / scaleW) / 2;
        videoRect.origin.y = 0;
        videoRect.size.width = videoRect.size.height * scaleH / scaleW;
    }
    _player.videoView.frame = videoRect;
}

- (void)setAudioAmplify:(CGFloat)amplify {
    [_player setAudioAmplify:amplify];
}

- (void)setCycleplay:(BOOL)isCycleplay {
    
}


#pragma mark 转到另一个控制器
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UIInterface layout subviews

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return toInterfaceOrientation == UIInterfaceOrientationMaskLandscapeLeft;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeLeft;//只支持这一个方向(正常的方向)
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
- (void)dealloc
{
    [_player shutdown];
    
    [self unregisterApplicationObservers];
}




@end
