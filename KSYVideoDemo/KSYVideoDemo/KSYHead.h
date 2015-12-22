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
//屏幕的宽高
#define THESCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define THESCREENHEIGHT [UIScreen mainScreen].bounds.size.height

//颜色
#define KSYCOLER(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//字体大小
#define WORDFONT16 16
#define WORDFONT18 18



#define kShortPlayBtnTag            200
#define kTextFieldTag               199
#define kCommentViewTag             198
#define kPlaySliderTag              197
#define kShortIndicatorViewTag      196
#define kShortIndicatorLabelTag     195
#define kShortErrorLabelTag         194
#define kTotalLabelTag              193
#define kCurrentLabelTag            192
#define ksyTextFieldTag             191


#endif /* KSYHead_h */
