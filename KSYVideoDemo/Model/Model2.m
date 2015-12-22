//
//  Model2.m
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/9.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "Model2.h"

@implementation Model2


#pragma mark 动态方法 聪明的人都是能够控制自己双手的人
- (Model2 *)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        self.hostImageProf=dict[@"hostImageProf"];
        self.hostName=dict[@"hostName"];
        self.hostLevel=dict[@"hostLevel"];
        self.fansCount=dict[@"fansCount"];
        self.signature=dict[@"signature"];
        self.studioName=dict[@"studioName"];
        self.time=dict[@"time"];
        self.playtimes=dict[@"playtimes"];
        self.content=dict[@"content"];
    }
    return self;
}
#pragma mark 静态方法
+ (Model2 *)modelWithDictionary:(NSDictionary *)dict
{
    Model2 *model2=[[Model2 alloc]initWithDictionary:dict];
    return model2;
}
@end
