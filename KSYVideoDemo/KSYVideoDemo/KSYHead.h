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

//屏幕的宽高
#define THESCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define THESCREENHEIGHT [UIScreen mainScreen].bounds.size.height

//颜色
#define KSYCOLER(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//字体大小
#define WORDFONT16 16
#define WORDFONT18 18



#define kShortPlayBtnTag            400
#define kTextFieldTag               401
#define kCommentViewTag             402
#define kPlaySliderTag              403
#define kShortIndicatorViewTag      404
#define kShortIndicatorLabelTag     405
#define kShortErrorLabelTag         406
#define kTotalLabelTag              407
#define kCurrentLabelTag            408
#define ksyTextFieldTag             409
#define kDetailViewTag              410

#endif /* KSYHead_h */
