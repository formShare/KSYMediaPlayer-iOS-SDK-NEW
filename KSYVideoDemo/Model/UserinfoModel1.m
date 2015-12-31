//
//  UserinfoModel1.m
//  KSYVideoDemo
//
//  Created by KSC on 15/12/30.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "UserinfoModel1.h"

@implementation UserinfoModel1

- (UserinfoModel1 *)initWithDictionary:(NSDictionary *)dict
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

+ (UserinfoModel1 *)modelWithDictionary:(NSDictionary *)dict
{
    UserinfoModel1 *model=[[UserinfoModel1 alloc]initWithDictionary:dict];
    return model;
}

@end
