//
//  KSYBasePlayView.h
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/18.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "Reachability.h"
@interface KSYBasePlayView : UIView



@property (nonatomic, strong)   KSYMoviePlayerController    *player;
@property (nonatomic, assign)   NSTimeInterval              currentPlaybackTime;
@property (nonatomic, readonly) NSTimeInterval              duration;
/**
 *	@brief	app退到后台是否释放播放器，默认是 NO
 */
@property (nonatomic) BOOL      isBackGroundReleasePlayer;
@property (nonatomic, strong)   NSTimer *timer;
@property (nonatomic, assign)   BOOL isLivePlay;
@property (nonatomic, strong)   UIActivityIndicatorView *indicator;
@property (nonatomic, copy)     NSString *urlString;
@property (nonatomic)           Reachability *hostReachability;
@property (nonatomic)           NetworkStatus networkStatus;
@property (nonatomic) BOOL      isShowFinishAlert;
@property (nonatomic) BOOL      isShowErrorAlert;
@property (nonatomic) BOOL      isNetShowAlert;
@property (nonatomic) BOOL      isWifiShowAlert;
//初始化视图
- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
//播放器启动
- (void)play;
//播放器暂停
- (void)pause;
//播放器停止
- (void)stop;
//关闭播放器
- (void)shutDown;
//当前播放器的状态
- (void)moviePlayerPlaybackState:(MPMoviePlaybackState)playbackState;
//当前网络加载情况
- (void)moviePlayerLoadState:(MPMovieLoadState)loadState;
//已经加载的数据大小
- (void)moviePlayerReadSize:(double)readSize;
//播放器完成状态
- (void)moviePlayerFinishState:(MPMoviePlaybackState)finishState;
//播放器完成原因
- (void)moviePlayerFinishReson:(MPMovieFinishReason)finishReson;
//播放器seek
- (void)moviePlayerSeekTo:(NSTimeInterval)position;
//更新当前时间
- (void)updateCurrentTime;
//定时器关闭
- (void)timerIsStop:(BOOL)isStop;


@end
