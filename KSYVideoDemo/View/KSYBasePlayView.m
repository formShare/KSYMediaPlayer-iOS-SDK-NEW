//
//  KSYBasePlayView.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/18.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYBasePlayView.h"
@interface KSYBasePlayView ()

@end

@implementation KSYBasePlayView

- (void)dealloc
{
    [self stopTimer];
    if (_player) {
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
        
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
    [self releaseObservers];
    //    [self unregisterApplicationObservers];
}

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        _player = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
        
        
        _player.controlStyle = MPMovieControlStyleNone;
        [_player.view setFrame: self.bounds];  // player's frame must match parent's
        [self addSubview: _player.view];
        self.autoresizesSubviews = TRUE;
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _player.shouldAutoplay = TRUE;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        NSLog(@"ip: %@", [_player serverAddress]);
        [_player prepareToPlay];

        [self setupObservers];
        

//        [self registerApplicationObservers];

    }
    return self;
}

#pragma mark- playerControl

- (void)play
{
    if (self.player) {
        [self.player play];
    }
}

- (void)pause
{
    if (self.player) {
        [self.player pause];
    }

}

- (void)stop
{
    if (self.player) {
        [self.player stop];
    }

}

- (NSTimeInterval)currentPlaybackTime
{
    if (self.player) {
        return self.player.currentPlaybackTime;
    }
    return 0;
}

- (NSTimeInterval)duration
{
    if (self.player) {
        return self.player.duration;
    }
    return 0;
}
#pragma mark- playerState

- (void)moviePlayerPlaybackState:(MPMoviePlaybackState)playbackState
{
    NSLog(@"player playback state: %ld", (long)playbackState);

}

- (void)moviePlayerLoadState:(MPMovieLoadState)loadState
{
    NSLog(@"player load state: %ld", (long)loadState);

}

- (void)moviePlayerReadSize:(double)readSize
{
    NSLog(@"player download flow size: %f MB", readSize);

}

- (void)moviePlayerFinishState:(MPMoviePlaybackState)finishState
{
    NSLog(@"player finish state: %ld", finishState);

}

- (void)moviePlayerFinishReson:(MPMovieFinishReason)finishReson
{
    NSLog(@"player finish reson is %ld",finishReson);
}

- (void)moviePlayerSeekTo:(NSTimeInterval)position
{
    if (self.player) {
        self.player.currentPlaybackTime = position;
    }
}
- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];

    }
}

- (void)stopTimer
{
    if (nil == _timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)updateCurrentTime
{
    NSLog(@"currentTime is %f",self.currentPlaybackTime);

}


#pragma mark- notify
-(void)handlePlayerNotify:(NSNotification*)notify
{
    
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        [self startTimer];
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
        
        [self moviePlayerPlaybackState:self.player.playbackState];
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        
        [self moviePlayerLoadState:self.player.loadState];
        if (MPMovieLoadStateStalled & _player.loadState) {

        }
        
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        
        [self moviePlayerFinishState:self.player.playbackState];

        [self moviePlayerReadSize:self.player.readSize];
    }
    
    if (MPMoviePlayerPlaybackDidFinishReasonUserInfoKey == notify.name) {
        NSNumber *reason = [[notify userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        
        [self moviePlayerFinishReson:[reason integerValue]];
    }
}


- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
}

- (void)releaseObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:nil];
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
