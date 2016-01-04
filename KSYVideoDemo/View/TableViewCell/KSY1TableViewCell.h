//
//  KSY1TableViewCell.h
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/8.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSYCommentModel.h"
@interface KSY1TableViewCell : UITableViewCell

//状态属性
@property (nonatomic, strong) KSYCommentModel *model1;
//高度属性
@property (nonatomic, assign) CGFloat height;

@end
