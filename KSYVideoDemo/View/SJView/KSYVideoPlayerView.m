//
//  KSYVideoPlayerView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYVideoPlayerView.h"



@interface KSYVideoPlayerView ()
//播放类型
@property (nonatomic, assign) KSYPopularLivePlayState playState;


@end




@implementation KSYVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString playState:(KSYPopularLivePlayState)playState
{
    self = [super initWithFrame:frame urlString:urlString];
    if (self) {
        
        self.playState = playState;
//        [self addSubview:self.closeButton];
//        [self addSubview:self.reportButton];
//        [self addSubview:self.playStateLab];
//        [self addSubview:self.curentTimeLab];
//        [self addSubview:self.headButton];
//        [self addSubview:self.headImageView];
//        [self addSubview:self.interactiveView];
//        [self addSubview:self.alertView];
//        
//        [self bringSubviewToFront:self.closeButton];
        
    }
    return self;
}

#pragma mark 添加顶部视图
- (void)addShortTopView
{
//    self.kShortTopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _player.view.width, 40)];
//    [_player.view addSubview:self.kShortTopView];
//    self.kShortTopView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]];
//    self.kShortTopView.hidden=YES;
//    //用户名和关注按钮
//    UIImageView *kUserImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
//    [self.kShortTopView addSubview:kUserImageView];
//    kUserImageView.layer.masksToBounds=YES;
//    kUserImageView.layer.cornerRadius=15;
//    kUserImageView.contentMode=UIViewContentModeScaleAspectFit;//等比例缩放
//    kUserImageView.image=[UIImage imageNamed:@"touxiang.png"];
//    
//    UILabel *kUserName=[[UILabel alloc]initWithFrame:CGRectMake(kUserImageView.right+5, kUserImageView.center.y-10, 80, 20)];
//    [self.kShortTopView addSubview:kUserName];
//    kUserName.text=@"用户名ID";
//    kUserName.textColor=[UIColor whiteColor];
//    kUserName.font=[UIFont systemFontOfSize:WORDFONT16];
//    
//    UIButton *kForcBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.kShortTopView.right-70, 5, 60, 30)];
//    [self.kShortTopView addSubview:kForcBtn];
//    [kForcBtn setTitle:@"＋关注" forState:UIControlStateNormal];
//    [kForcBtn setTitleColor:KSYCOLER(92, 223, 232) forState:UIControlStateNormal];
//    //设置边框
//    kForcBtn.layer.masksToBounds=YES;
//    kForcBtn.layer.cornerRadius=5;
//    kForcBtn.layer.borderColor=[KSYCOLER(92, 223, 232)CGColor];
//    kForcBtn.layer.borderWidth=1;
    
}




@end
