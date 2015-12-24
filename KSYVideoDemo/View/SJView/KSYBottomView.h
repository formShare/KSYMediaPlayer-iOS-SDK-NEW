//
//  KSYBottomView.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSYBottomViewDelegate <NSObject>

- (void)progressDidBegin:(id)sender;
- (void)progressChanged:(id)sender;
- (void)progressChangeEnd:(id)sender;
- (void)playBtnClick;

@end


@interface KSYBottomView : UIView

@property (nonatomic, weak) id<KSYBottomViewDelegate>delegate;

@end
