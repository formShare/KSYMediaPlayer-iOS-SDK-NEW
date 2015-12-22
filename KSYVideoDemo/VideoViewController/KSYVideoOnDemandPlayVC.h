//
//  KSYVideoOnDemandPlayVC.h
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//  视频点播播放

#import <UIKit/UIKit.h>
#import "KSYBaseViewController.h"
#import "KSYPlayer.h"
#import "MediaControlViewController.h"

@interface KSYVideoOnDemandPlayVC : KSYBaseViewController<KSYMediaPlayDelegate>{//播放器代理
    
    BOOL _pauseInBackground;//是否进入后台
}

@property (nonatomic, strong) NSURL *videoUrl;//视频资源地址
@property (nonatomic) BOOL isFullScreen;//全屏标志
@property (nonatomic, assign) BOOL isCycleplay;//循环标志
@property (nonatomic,assign) NSUInteger motionInterfaceOrientation;
@property (readonly)   BOOL fullScreenModeToggled;
@property (nonatomic,assign)UIDeviceOrientation beforeOrientation;
@property (nonatomic,assign)UIDeviceOrientation deviceOrientation;
- (KSYPlayer *)player;
//全屏
- (void)launchFullScreen;
//最小话播放界面
- (void)minimizeVideo;
@end
