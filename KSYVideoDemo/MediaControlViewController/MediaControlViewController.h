//
//  MediaControlViewController.h
//  KS3PlayerDemo
//
//  Created by Blues on 15/3/18.
//  Copyright (c) 2015年 KSY. All rights reserved.
//

enum KSYVideoQuality {
    kKSYVideoNormal = 0, // **** default
    kKSYVideoHight,
    kKSYVideoSuper,
};

enum KSYVideoScale {
    kKSYVideo16W9H = 0, // **** default
    kKSYVideo4W3H,
};

enum KSYGestureType {
    kKSYUnknown = 0,
    kKSYBrightness,
    kKSYVoice,
    kKSYProgress,
};

typedef enum KSYVideoQuality KSYVideoQuality;
typedef enum KSYVideoScale KSYVideoScale;
typedef enum KSYGestureType KSYGestureType;

#import <UIKit/UIKit.h>

@protocol KSYMediaPlayDelegate <NSObject>

@required
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;

- (void)seekProgress:(CGFloat)position;
- (void)setVideoQuality:(KSYVideoQuality)videoQuality;
- (void)setVideoScale:(KSYVideoScale)videoScale;
- (void)setAudioAmplify:(CGFloat)amplify;
- (void)clickFullBtn;
- (void)refreshControl;
- (void)progressDidBegin:(id)sender;
- (void)progressChanged:(id)sender;
- (void)progressChangeEnd:(id)sender;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface MediaControlViewController : UIViewController

@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat curPosition;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UITableView *episodeTableView;
@property (nonatomic, assign) NSInteger audioAmplify;
@property (nonatomic, assign) CGFloat curVoice;
@property (nonatomic, assign) CGFloat curBrightness;
@property (nonatomic, assign) KSYGestureType gestureType;
@property (nonatomic, strong) KSYBasePlayView *phoneLivePlayVC;



@property (nonatomic, weak) id<KSYMediaPlayDelegate> delegate;

- (void)clickPlayBtn:(id)sender;
- (void)clickQualityBtn:(id)sender;
- (void)clickHighlightBtn:(id)sender;
- (void)clickNormalBtn:(id)sender;
- (void)progressChanged:(id)sender;
- (void)progressDidBegin:(id)slider;
- (void)progressChangeEnd:(id)sender;
- (void)brightnessChanged:(id)sender;
- (void)brightnessDidBegin:(id)sender;
- (void)brightnessChangeEnd:(id)sender;
- (void)voiceChanged:(id)sender;
- (void)clickFullBtn:(id)sender;
- (void)clickScaleBtn:(id)sender;
- (void)clickEpisodeBtn:(id)sender;
- (void)clickSnapBtn:(id)sender;
- (void)clickLockBtn:(id)sender;
- (void)clickSoundOff:(UITapGestureRecognizer *)tapGesture;
- (void)showLoading;
- (void)reSetLoadingViewFrame;
- (void)hideAllControls;
- (void)showAllControls;
@end
