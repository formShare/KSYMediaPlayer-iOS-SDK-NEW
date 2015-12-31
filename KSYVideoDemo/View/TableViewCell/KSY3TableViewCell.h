//
//  KSY3TableViewCell.h
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/14.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinfoModel3.h"
@interface KSY3TableViewCell : UITableViewCell


//两个属性
@property (nonatomic, strong) UserinfoModel3 *model3;
@property (nonatomic, assign) CGFloat height;

@end
