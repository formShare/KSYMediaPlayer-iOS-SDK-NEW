//
//  KSY3TableViewCell.h
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/14.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model3.h"
@interface KSY3TableViewCell : UITableViewCell


//两个属性
@property (nonatomic, strong) Model3 *model3;
@property (nonatomic, assign) CGFloat height;

@end
