//
//  Model1.m
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/9.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "Model1.h"

@implementation Model1
//初始化
- (Model1 *)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        self.imageName=dict[@"imageName"];
        self.userName=dict[@"userName"];
        self.time=dict[@"time"];
        self.content=dict[@"content"];
    }
    return self;
}
#pragma mark 动态方法
+ (Model1 *)modelWithDictionary:(NSDictionary *)dict
{
    Model1 *model=[[Model1 alloc]initWithDictionary:dict];
    return model;
}
@end
