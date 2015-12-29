//
//  KSYHead.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/21.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#ifndef KSYHead_h
#define KSYHead_h

#import "UIView+BFExtension.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "KSYBasePlayView.h"
#import "ThemeManager.h"
#import "MediaVoiceView.h"
#import "KSY1TableViewCell.h"
#import "Model1.h"
#import "KSY2TableViewCell.h"
#import "Model2.h"
#import "KSY3TableViewCell.h"
#import "Model3.h"
#import "KSYDefine.h"
#import "MediaControlDefine.h"
typedef enum : NSUInteger {
    KSYPopularLivePlay,
    KSYPopularPlayBack,
    kSYShortVideoPlay,
    KSYVideoOnlinePlay,
} KSYPopularLivePlayState;

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

//  弱引用宏
#define WeakSelf(VC) __weak VC *weakSelf = self

//屏幕的宽高
#define THESCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define THESCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define TEXTCOLOR1 ([UIColor colorWithRed:207.0/255.0 green:206.0/255.0 blue:203.0/255.0 alpha:1.0])
#define TEXTCOLOR2 ([UIColor colorWithRed:237.0/255.0 green:236.0/255.0 blue:234.0/255.0 alpha:1.0])
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define kTopBarHeight 40
#define kBottomBarHeight 58
#define kCoverBarHeight 140
#define kCoverBarLeftMargin 20
#define kCoverBarRightMargin 20
#define kCoverBarTopMargin 48
#define kCoverBarBottomMargin 42
#define kCoverLockViewLeftMargin 68
#define kCoverLockViewBgWidth 40
#define kCoverLockWidth 30
#define kCoverBarWidth 25
#define kProgressViewWidth 150
#define kLandscapeSpacing 10
#define kVertialSpacing 20
#define kBigFont 18
#define kSmallFont 16


//颜色
#define KSYCOLER(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//字体大小
#define WORDFONT16 16
#define WORDFONT18 18


#endif /* KSYHead_h */
