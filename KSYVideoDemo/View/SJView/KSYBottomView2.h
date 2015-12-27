//
//  KSYBottomView2.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSYBottomView2 : UIView<UITextFieldDelegate>
@property (nonatomic, copy) void (^clickPlayBtn)(UIButton *btn);
@property (nonatomic, copy) void (^clickFullBtn)(UIButton *btn);
@property (nonatomic, copy) void (^textFildDidBeginEditing)(UITextField *text);
@end
