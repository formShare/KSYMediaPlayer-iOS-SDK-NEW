//
//  KSYBasePlayView.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/18.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYBasePlayView.h"
#import "KSYPlayer.h"

@interface KSYBasePlayView ()<KSYMediaPlayerDelegate>

@property (nonatomic, strong)KSYPlayer *player;

@end

@implementation KSYBasePlayView

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _player = [[KSYPlayer alloc] initWithURL:[NSURL URLWithString:urlString]];
        _player.shouldAutoplay = YES;
        _player.delegate = self;
        [self addSubview:_player.videoView];
        _player.videoView.frame = frame;
        _player.videoView.backgroundColor = [UIColor blackColor];

        
        //开启低延时模式
        [_player playerSetUseLowLatencyWithBenable:LOW_LATENCY_DROP_AUDIO maxMs:3000 minMs:500];
        
        [_player setScalingMode:MPMovieScalingModeAspectFit];
        
        [_player prepareToPlay];

        [self registerApplicationObservers];

    }
    return self;
}

- (void)dealloc
{
    [self unregisterApplicationObservers];
    [self.player shutdown];
    self.player = nil;
}


- (void)registerApplicationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

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

- (void)applicationWillEnterForeground
{
}

- (void)applicationDidBecomeActive
{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_isRtmp) {
//            _player = [KSYPlayer sharedKSYPlayer];
//            [_player startWithMURL:_videoUrl withOptions:nil allowLog:NO appIdentifier:@"ksy"];
//            _player.shouldAutoplay = YES;
//            [_player prepareToPlay];
//            
//            _player.videoView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/2);
//            _player.videoView.backgroundColor = [UIColor blackColor];
//            [self.view addSubview:_player.videoView];
//            
//            //            _mediaControlViewController = [[MediaControlViewController alloc] init];
//            //            _mediaControlViewController.delegate = self;
//            [self.view addSubview:_mediaControlViewController.view];
//            [_player setScalingMode:MPMovieScalingModeAspectFit];
//            
//            [_player playerSetUseLowLatencyWithBenable:1 maxMs:3000 minMs:500];
//            
//        }else {
//            if (![_player isPlaying]) {
//                [self play];
//            }
//            
//        }
//        
//    });
}

- (void)applicationWillResignActive
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_pauseInBackground && [_player isPlaying]) {
//            if (_isRtmp) {
//                [_player shutdown];
//                [_mediaControlViewController.view removeFromSuperview];
//                
//            }else {
//                [self pause];
//            }
//        }
//    });
    
}

- (void)applicationDidEnterBackground
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_pauseInBackground && [_player isPlaying]) {
//            if (_isRtmp) {
//                [_player shutdown];
//                
//            }else {
//                [self pause];
//            }
//            
//        }
//    });
}

- (void)applicationWillTerminate
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_pauseInBackground && [_player isPlaying]) {
//            if (_isRtmp) {
//                [_player shutdown];
//                
//            }else {
//                [self pause];
//            }
//            
//        }
//    });
}

@end
