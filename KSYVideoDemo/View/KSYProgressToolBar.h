//
//  KSYProgressToolBar.h
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/17.
//  Copyright © 2015年 kingsoft. All rights reserved.
//  进度控制Bar

#import <UIKit/UIKit.h>

@interface KSYProgressToolBar : UIView

@property (nonatomic, copy)void (^playControlEventBlock)(BOOL isStop);

@property (nonatomic, copy)void (^seekToBlock)(double position);
- (void)updataSliderWithPosition:(NSInteger)position duration:(NSInteger)duration;
- (void)playerStop;
@end
