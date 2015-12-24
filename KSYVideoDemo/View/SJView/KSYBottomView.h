//
//  KSYBottomView.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSYBottomView : UIView


@property (nonatomic, retain) void (^progressDidBegin)(UISlider *slider);
@property (nonatomic, retain) void (^progressChanged)(UISlider *slider);
@property (nonatomic, retain) void (^progressChangeEnd)(UISlider *slider);
@property (nonatomic, retain) void (^BtnClick)();

@end
