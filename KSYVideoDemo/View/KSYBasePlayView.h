//
//  KSYBasePlayView.h
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/18.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KSYMediaPlayer/KSYMediaPlayer.h>

@interface KSYBasePlayView : UIView
@property (nonatomic, strong)KSYMoviePlayerController *player;
@property (nonatomic, strong)NSTimer *timer;

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;

//播放器启动
- (void)play;
//播放器暂停
- (void)pause;
//播放器停止
- (void)stop;
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
@property (nonatomic, assign)NSTimeInterval currentPlaybackTime;
@property (nonatomic, readonly)NSTimeInterval duration;
@end
