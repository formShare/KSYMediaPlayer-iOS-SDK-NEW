//
//  SpectatorModel.h
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/9.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SpectatorModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *headUrl;

//临时成员，测试效果用
@property (nonatomic, strong)UIColor *headColor;
@end
