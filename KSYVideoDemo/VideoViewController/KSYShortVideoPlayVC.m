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
#import "KSYVideoPlayerView.h"

@interface KSYShortVideoPlayVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    KSYVideoPlayerView *ksyPoularLiveView;
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
    //1.设置导航栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //2.设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //修改导航栏模式
    [self changeNavigationStayle];
    //初始化视图
    ksyPoularLiveView=[[KSYVideoPlayerView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) urlString:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp4"] playState:KSYPopularLivePlay];
    [self.view addSubview:ksyPoularLiveView];

    
    
    
    
//    //修改导航栏模式
//    [self changeNavigationStayle];
//    //初始化播放器
//    [self initPlayerWithLowTimelagType:NO];
//    //添加顶部视图
//    [self addShortTopView];
//    //添加底部视图
//    [self addShortBottomView];
//    //添加水平滚动视图
//    [self addBellowPart];
//    //添加评论
//    [self addCommtentView];
//    //刷新视图
//    [self refreshControl];
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
    
    isEnd = NO;
    isActive = YES;
    isCompleted = NO;
    isCyclePlay=NO;
    pauseInBackground=YES;
    _gestureType= kKSYUnknown;
    _videoPath=[NSString stringWithFormat:@"http://121.42.58.232:8980/hls_test/1.m3u8"];
    _phoneLivePlayVC = [[KSYBasePlayView alloc] initWithFrame:CGRectMake(0,64,self.view.width,(self.view.bottom-64)/2) urlString:_videoPath];
    [self.view addSubview:_phoneLivePlayVC];
    //注册其他通知
    [self registerApplicationObservers];
    
}
#pragma mark 添加顶部视图
- (void)addShortTopView
{
    self.kShortTopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [_phoneLivePlayVC addSubview:self.kShortTopView];
    self.kShortTopView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]];
    self.kShortTopView.hidden=YES;
    //用户名和关注按钮
    UIImageView *kUserImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self.kShortTopView addSubview:kUserImageView];
    kUserImageView.layer.masksToBounds=YES;
    kUserImageView.layer.cornerRadius=15;
    kUserImageView.contentMode=UIViewContentModeScaleAspectFit;//等比例缩放
    kUserImageView.image=[UIImage imageNamed:@"touxiang.png"];
    
    UILabel *kUserName=[[UILabel alloc]initWithFrame:CGRectMake(kUserImageView.right+5, kUserImageView.center.y-10, 80, 20)];
    [self.kShortTopView addSubview:kUserName];
    kUserName.text=@"用户名ID";
    kUserName.textColor=[UIColor whiteColor];
    kUserName.font=[UIFont systemFontOfSize:WORDFONT16];
    
    UIButton *kForcBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.kShortTopView.right-70, 5, 60, 30)];
    [self.kShortTopView addSubview:kForcBtn];
    [kForcBtn setTitle:@"＋关注" forState:UIControlStateNormal];
    [kForcBtn setTitleColor:KSYCOLER(92, 223, 232) forState:UIControlStateNormal];
    //设置边框
    kForcBtn.layer.masksToBounds=YES;
    kForcBtn.layer.cornerRadius=5;
    kForcBtn.layer.borderColor=[KSYCOLER(92, 223, 232)CGColor];
    kForcBtn.layer.borderWidth=1;
    
}
#pragma mark 添加底部视图
- (void)addShortBottomView
{
    self.kShortBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, _phoneLivePlayVC.height-40, _phoneLivePlayVC.width, 40)];
    [_phoneLivePlayVC addSubview:self.kShortBottomView];
    self.kShortBottomView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]];
    self.kShortBottomView.hidden=YES;
    //播放按钮 播放时间 进度条 总时间
    UIButton *kShortPlayBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self.kShortBottomView addSubview:kShortPlayBtn];
    kShortPlayBtn.tag=kShortPlayBtnTag;
    [kShortPlayBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [kShortPlayBtn addTarget:self action:@selector(theplay) forControlEvents:UIControlEventTouchUpInside];
    
    //播放时间
    UILabel *kCurrentLabel=[[UILabel alloc]initWithFrame:CGRectMake(kShortPlayBtn.right+10, kShortPlayBtn.center.y-15, 60, 30)];
    [self.kShortBottomView addSubview:kCurrentLabel];
    kCurrentLabel.textColor=[UIColor whiteColor];
    kCurrentLabel.text=@"00:00";
    kCurrentLabel.tag=kCurrentLabelTag;
    
    //进度条
    UISlider *kPlaySlider=[[UISlider alloc]initWithFrame:CGRectMake(kCurrentLabel.right+10, kCurrentLabel.center.y-5, self.kShortBottomView.width-kCurrentLabel.right-10-80, 10)];
    [self.kShortBottomView addSubview:kPlaySlider];
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    UIImage *minImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"slider_color"];
    [kPlaySlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
    [kPlaySlider setThumbImage:dotImg forState:UIControlStateNormal];
    [kPlaySlider addTarget:self action:@selector(progressDidBegin:) forControlEvents:UIControlEventTouchDown];
    [kPlaySlider addTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
    [kPlaySlider addTarget:self action:@selector(progressChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
    kPlaySlider.value = 0.0;
    kPlaySlider.tag = kPlaySliderTag;
    [self.kShortBottomView addSubview:kPlaySlider];
    
    //总时间
    UILabel *kTotalLabel=[[UILabel alloc]initWithFrame:CGRectMake(kPlaySlider.right+10, kShortPlayBtn.center.y-15, 60, 30)];
    kTotalLabel.tag=kTotalLabelTag;
    [self.kShortBottomView addSubview:kTotalLabel];
    kTotalLabel.text=@"00:00";
    kTotalLabel.textColor=[UIColor whiteColor];
}
#pragma mark 添加评论视图
- (void)addCommtentView
{
    UIView *kCommentView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom-40, self.view.width, 40)];
    kCommentView.tag=kCommentViewTag;
    [self.view addSubview:kCommentView];
    kCommentView.backgroundColor=KSYCOLER(34, 34, 34);
    
    UITextField *kTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kCommentView.width-10-50, 30)];
    kTextField.tag=kTextFieldTag;
    [kCommentView addSubview:kTextField];
    kTextField.backgroundColor=KSYCOLER(100, 100, 100);
    kTextField.placeholder=@"填写评论内容";
    kTextField.delegate=self;
    
    
    UIButton *kSendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    kSendBtn.frame=CGRectMake(kTextField.right+10, 5, 40, 30);
    [kCommentView addSubview:kSendBtn];
    [kSendBtn setTitle:@"发送"forState:UIControlStateNormal];
    [kSendBtn setTitleColor:KSYCOLER(32, 223, 232) forState:UIControlStateNormal];
    kSendBtn.layer.masksToBounds=YES;
    kSendBtn.layer.borderColor=[KSYCOLER(32, 223, 232)CGColor];
    kSendBtn.layer.borderWidth=1;
    kSendBtn.layer.cornerRadius=5;
    [kSendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *kCommentView=[self.view viewWithTag:kCommentViewTag];
    
    //执行动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.view.bottom<500)
        {
            CGFloat kCommentViewY=self.view.bottom/2-50;
            kCommentView.frame=CGRectMake(0,  kCommentViewY, self.view.width, 40);
        }
        else
        {
            
        }
        
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];
}
- (void)sendComment
{
    UIView *kCommentView=[self.view viewWithTag:kCommentViewTag];
    UITextField *textField=(UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textField resignFirstResponder];
    //执行动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        kCommentView.frame=CGRectMake(0, self.view.bottom-40, self.view.width, 40);
    } completion:^(BOOL finished) {
        NSLog(@"Animation Over!");
    }];
}
#pragma mark 添加下面的内容(就两个字，去做，动手去做)
- (void)addBellowPart
{
    CGFloat backgroundViewX=0;
    CGFloat backgroundViewY=_phoneLivePlayVC.bottom;
    CGFloat backgroundVieWidth=_phoneLivePlayVC.width;
    CGFloat backgroundViewHeight=THESCREENHEIGHT-_phoneLivePlayVC.bottom;
    CGRect backgroundViewRect=CGRectMake(backgroundViewX, backgroundViewY, backgroundVieWidth, backgroundViewHeight);
    //在这里初始化
    self.kShortBackgroundView=[[UIView alloc]initWithFrame:backgroundViewRect];
    self.kShortBackgroundView.backgroundColor=KSYCOLER(90, 90, 90);
    [self.view addSubview:self.kShortBackgroundView];
    //初始化分段控制器
    NSArray *segmentedArray=[NSArray arrayWithObjects:@"评论",@"详情",@"推荐",@"分享" ,nil];
    self.kShortSegmentedCTL=[[UISegmentedControl alloc]initWithItems:segmentedArray];
    self.kShortSegmentedCTL.frame=CGRectMake(10, 10, self.kShortBackgroundView.width-20, 30);
    self.kShortSegmentedCTL.tintColor=KSYCOLER(92, 223, 232);
    [self.kShortBackgroundView addSubview:self.kShortSegmentedCTL];
    [self.kShortSegmentedCTL addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.kShortSegmentedCTL.selectedSegmentIndex=0;
    //添加一个分割线
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.kShortSegmentedCTL.frame)+10, THESCREENWIDTH, 1)];
    lineLabel.backgroundColor=[UIColor blackColor];
    [self.kShortBackgroundView addSubview:lineLabel];
    //初始化表视图 只要你在做你就在想
    self.kShortTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame)+10, THESCREENWIDTH, THESCREENHEIGHT/2-60) style:UITableViewStylePlain];
    self.kShortTableView.userInteractionEnabled=YES;
    [self.kShortBackgroundView addSubview:self.kShortTableView];
    self.kShortTableView.delegate=self;
    self.kShortTableView.dataSource=self;
    [self segmentChange:self.kShortSegmentedCTL];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   _models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
#pragma mark tableViewDelegate 表视图代理方法
#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSY1TableViewCell *cell=_modelsCells[indexPath.row];
    cell.model1=_models[indexPath.row];//这里执行set方法
    return cell.height;
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
    }
}


#pragma mark 注册通知
- (void)registerApplicationObservers
{
    //添加通知设备方向改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
/**
 *  移除通知
 */
- (void)unregisterApplicationObservers
{
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}


/**
 *  设备方向发生改变
 */
- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
    {
        [self changeDeviceOrientation:UIInterfaceOrientationPortrait];
    }
    
}

//手动设置设备方向，这样就能收到转屏事件
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


- (void)menu
{
    //弹框
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rate AppName" message:nil delegate:self cancelButtonTitle:@"举报" otherButtonTitles:@"订阅",@"取消", nil];
    [alert show];
}
- (void)theplay
{
    if (!_phoneLivePlayVC)
    {
        return;
    }
    if ([_phoneLivePlayVC.player isPlaying]==NO){
        [_phoneLivePlayVC play];
    }
    else{
        [_phoneLivePlayVC pause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)seekCompletedWithPosition:(CGFloat)position {
    UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kPlaySliderTag];
    UIButton *btn = (UIButton *)[self.view viewWithTag:kShortPlayBtnTag];
    progressSlider.value = position;
    if (isCompleted == YES) {
        isCompleted = NO;
        UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
        [btn setImage:playImg forState:UIControlStateNormal];
    }
    else {
        
        if (isKSYPlayerPling) {
            [_phoneLivePlayVC play];
        }else{
            isKSYPlayerPling = NO;
            [_phoneLivePlayVC pause];
        }
        isActive = YES;
        [self refreshControl];
    }
}
- (void)refreshControl {
    
    UILabel *kCurrentLabe = (UILabel *)[self.view viewWithTag:kCurrentLabelTag];
    UILabel *kTotalLabel = (UILabel *)[self.view viewWithTag:kTotalLabelTag];
    UISlider *kPlaySlider = (UISlider *)[self.view viewWithTag:kPlaySliderTag];
    
    NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
    //    NSInteger playableDuration = (NSInteger)_player.playableDuration;//获得可以播放时间
    
    NSInteger position = (NSInteger)_phoneLivePlayVC.player.currentPlaybackTime;
    
    int iMin  = (int)(position / 60);
    int iSec  = (int)(position % 60);
    
    kCurrentLabe.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
    if (duration > 0) {
        int iDuraMin  = (int)(duration / 60);
        int iDuraSec  = (int)(duration % 3600 % 60);
        kTotalLabel.text = [NSString stringWithFormat:@"%02d:%02d", iDuraMin, iDuraSec];
        kPlaySlider.value = position;
        kPlaySlider.maximumValue = duration;
    }
    else {
        kTotalLabel.text = @"--:--";
        kPlaySlider.value = 0.0f;
        kPlaySlider.maximumValue = 1.0f;
    }
    if (isActive == YES && isEnd == NO) {
        [self performSelector:@selector(refreshControl) withObject:nil afterDelay:1.0];
    }
    
}
#pragma mark 移除错误视图
- (void)kShortRemoveError
{
    _kShortErrorView.hidden = YES;
}
#pragma mark  移除加载视图
- (void)kShortRemoveLoading
{
    _kShortLodingView.hidden=YES;
}
#pragma mark 显示加载视图
- (void)kShortShowLoading {
    if (_kShortLodingView == nil) {
        _kShortLodingView = [[UIView alloc] initWithFrame:_phoneLivePlayVC.bounds];
        _kShortLodingView.backgroundColor = [UIColor clearColor];
        [_phoneLivePlayVC addSubview:_kShortLodingView];
        
        // **** activity
        UIActivityIndicatorView *kShortIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        kShortIndicatorView.tag=kShortIndicatorViewTag;
        kShortIndicatorView.center = CGPointMake(_kShortLodingView.center.x, _kShortLodingView.center.y - 10);
        [kShortIndicatorView startAnimating];
        [_kShortLodingView addSubview:kShortIndicatorView];
        
        CGRect labelRect = CGRectMake(0, 0, 100, 30);
        UILabel * kShortIndicatorLabel = [[UILabel alloc] initWithFrame:labelRect];
        kShortIndicatorLabel.tag=kShortIndicatorLabelTag;
        kShortIndicatorLabel.text = @"加载中...";
        kShortIndicatorLabel.textAlignment = NSTextAlignmentCenter;
        kShortIndicatorLabel.textColor = [UIColor whiteColor];
        [_kShortLodingView addSubview:kShortIndicatorLabel];
        kShortIndicatorLabel.center = CGPointMake(_kShortLodingView.center.x, _kShortLodingView.center.y + 20);
    }
    _kShortLodingView.hidden = NO;
    [self reSetLoadingViewFrame];
}
#pragma mark 显示加载视图
- (void)kShortShowError {
    if (_kShortErrorView == nil) {
        _kShortErrorView = [[UIView alloc] initWithFrame:_phoneLivePlayVC.bounds];
        _kShortErrorView.backgroundColor = [UIColor clearColor];
        [_phoneLivePlayVC addSubview:_kShortErrorView];
        
        // **** indicator
        CGRect labelRect = CGRectMake(0,_kShortErrorView.center.y-25,_kShortErrorView.width, 50);
        UILabel *kShortIndicatorLabel = [[UILabel alloc] initWithFrame:labelRect];
        kShortIndicatorLabel.tag = kShortErrorLabelTag;
        kShortIndicatorLabel.text = @":( 视频出错了，请重试！";
        kShortIndicatorLabel.textAlignment = NSTextAlignmentCenter;
        kShortIndicatorLabel.textColor = [UIColor whiteColor];
        [_kShortErrorView addSubview:kShortIndicatorLabel];
    }
    _kShortErrorView.hidden = NO;
    [self reSetLoadingViewFrame];
}

#pragma mark 重置加载视图
- (void)reSetLoadingViewFrame
{
    if (!_kShortLodingView.hidden) {
        _kShortLodingView.frame =_phoneLivePlayVC.bounds;
        UIActivityIndicatorView *kShortIndicatorView = (UIActivityIndicatorView *)[_kShortLodingView viewWithTag:kShortIndicatorViewTag];
        kShortIndicatorView.center = CGPointMake(_kShortLodingView.center.x, _kShortLodingView.center.y - 10);
        UILabel *kShortIndicatorLabel = (UILabel *)[_kShortLodingView viewWithTag:kShortIndicatorLabelTag];
        kShortIndicatorLabel.center = CGPointMake(_kShortLodingView.center.x, _kShortLodingView.center.y + 20);
    }
    if (!_kShortErrorView.hidden) {
        _kShortErrorView.frame = _phoneLivePlayVC.bounds;
        UILabel *kShortIndicatorLabel = (UILabel *)[_kShortErrorView viewWithTag:kShortErrorLabelTag];
        kShortIndicatorLabel.center = CGPointMake(_kShortErrorView.center.x, _kShortErrorView.center.y);
    }
}
#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isKSYPlayerPling = _phoneLivePlayVC.player.isPlaying;
    UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kPlaySliderTag];
    _startPoint = [[touches anyObject] locationInView:self.view];
    _curPosition = progressSlider.value;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint curPoint = [[touches anyObject] locationInView:self.view];
    CGFloat deltaX = curPoint.x - _startPoint.x;
    CGFloat deltaY = curPoint.y - _startPoint.y;
    NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
    
    if (fabs(deltaX) < fabs(deltaY)) {//如果是纵向滑动
        return ;
    }
    else if (curPoint.y>64&&curPoint.y<_phoneLivePlayVC.bottom&&duration > 0 && (_gestureType == kKSYUnknown || _gestureType == kKSYProgress)) {
        
        if (!isPreperded) {
            return;
        }
        if (fabs(deltaX) > fabs(deltaY)) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
            _gestureType = kKSYProgress;
            UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kPlaySliderTag];
            UILabel *startLabel = (UILabel *)[self.view viewWithTag:kCurrentLabelTag];
            CGFloat totalWidth=_phoneLivePlayVC.width;
            CGFloat deltaProgress = deltaX / totalWidth * duration;
            NSInteger position = _curPosition + deltaProgress;
            if (position < 0) {
                position = 0;
            }
            else if (position > duration) {
                position = duration;
            }
            progressSlider.value = position;
            int iMin1  = ((int)labs(position) / 60);
            int iSec1  = ((int)labs(position) % 60);
            NSString *strCurTime1 = [NSString stringWithFormat:@"%02d:%02d", iMin1, iSec1];
            startLabel.text = strCurTime1;
            UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
            [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
        }
    }
    else if (duration <= 0 && (_gestureType == kKSYUnknown || _gestureType == kKSYProgress)) {
        if (!isPreperded) {
            return;
        }
        NSLog(@"durationnnnn is %@",@(duration));
        
        //        [self showNotice:@"直播不支持拖拽"];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_gestureType == kKSYUnknown) { // **** tap 动作
        if (isActive == NO) {
            [self showAllControls];
            
        }
        else {
            [self hiddenAllControls];
        }
        [self sendComment];
    }
    else if (_gestureType == kKSYProgress) {
        if (!isPreperded) {
            return;
        }
        
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kPlaySliderTag];
        [_phoneLivePlayVC setCurrentPlaybackTime:progressSlider.value];
        UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
        [progressSlider setThumbImage:dotImg forState:UIControlStateNormal];
    }
    _gestureType = kKSYUnknown;
}
#pragma mark 显示控件
- (void) showAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        self.kShortTopView.hidden=NO;
        self.kShortBottomView.hidden=NO;
    } completion:^(BOOL finished) {
        isActive = YES;
        [self refreshControl];
    }];
}
#pragma mark 隐藏控件
- (void) hiddenAllControls
{
    [UIView animateWithDuration:0.3 animations:^{
        self.kShortTopView.hidden=YES;
        self.kShortBottomView.hidden=YES;
    } completion:^(BOOL finished) {
        isActive = NO;
    }];
    
    
}
#pragma mark 进度条开始
- (void)progressDidBegin:(id)slider
{
    isKSYPlayerPling = _phoneLivePlayVC.player.isPlaying;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
    [(UISlider *)slider setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration =_phoneLivePlayVC.player.duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        if ([_phoneLivePlayVC.player isPlaying] == YES) {
            isActive = NO;
            [_phoneLivePlayVC pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self.view viewWithTag:kShortPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
    }
}

- (void)progressChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (!isPreperded) {
        slider.value = 0.0f;
        return;
    }
    NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
    if (duration > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshControl) object:nil];
        UISlider *progressSlider = (UISlider *)[self.view viewWithTag:kPlaySliderTag];
        UILabel *startLabel = (UILabel *)[self.view viewWithTag:kCurrentLabelTag];
        
        if ([_phoneLivePlayVC.player isPlaying] == YES) {
            isActive = NO;
            [_phoneLivePlayVC pause];
            UIImage *playImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"bt_play_normal"];
            UIButton *btn = (UIButton *)[self.view viewWithTag:kShortPlayBtnTag];
            [btn setImage:playImg forState:UIControlStateNormal];
        }
        NSInteger position = progressSlider.value;
        int iMin  = (int)(position / 60);
        int iSec  = (int)(position % 60);
        NSString *strCurTime = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
        startLabel.text = strCurTime;
    }
    else {
        slider.value = 0.0f;
        //        [self showNotice:@"直播不支持拖拽"];
    }
}

- (void)progressChangeEnd:(id)sender {
    if (!isPreperded) {
        return;
    }
    
    UISlider *slider = (UISlider *)sender;
    UIImage *dotImg = [[ThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot_normal"];
    [slider setThumbImage:dotImg forState:UIControlStateNormal];
    NSInteger duration = (NSInteger)_phoneLivePlayVC.player.duration;
    if (duration > 0) {
        
        [_phoneLivePlayVC.player setCurrentPlaybackTime: slider.value];
        
    }
    else {
        slider.value = 0.0f;
        //NSLog(@"###########当前是直播状态无法拖拽进度###########");
    }
}
#pragma mark －导航按钮响应事件

#pragma mark 转到另一个控制器
- (void)back
{
    [ksyPoularLiveView shutDown];
    [self.navigationController popViewControllerAnimated:YES];
    //修改状态栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
}


- (void)dealloc
{
    [self unregisterApplicationObservers];
}


@end
