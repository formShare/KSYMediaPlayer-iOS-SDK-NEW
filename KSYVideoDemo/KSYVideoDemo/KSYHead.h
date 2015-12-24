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

//颜色
#define KSYCOLER(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//字体大小
#define WORDFONT16 16
#define WORDFONT18 18



#define kShortPlayBtnTag            160
#define kTextFieldTag               161
#define kCommentViewTag             162
#define kPlaySliderTag              163
#define kShortIndicatorViewTag      164
#define kShortIndicatorLabelTag     165
#define kShortErrorLabelTag         166
#define kTotalLabelTag              167
#define kCurrentLabelTag            168
#define ksyTextFieldTag             169
#define kDetailViewTag              170

#endif /* KSYHead_h */
