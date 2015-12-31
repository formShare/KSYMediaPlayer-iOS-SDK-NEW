//
//  UserinfoModel2.m
//  KSYVideoDemo
//
//  Created by KSC on 15/12/30.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "UserinfoModel2.h"

@implementation UserinfoModel2

- (UserinfoModel2 *)initWithDictionary:(NSDictionary *)dict
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

+ (UserinfoModel2 *)modelWithDictionary:(NSDictionary *)dict
{
    UserinfoModel2 *model2=[[UserinfoModel2 alloc]initWithDictionary:dict];
    return model2;
}
@end
