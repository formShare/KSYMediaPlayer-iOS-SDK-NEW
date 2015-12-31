//
//  UserinfoModel3.m
//  KSYVideoDemo
//
//  Created by KSC on 15/12/30.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "UserinfoModel3.h"

@implementation UserinfoModel3
- (UserinfoModel3 *)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        self.imageName=dict[@"imageName"];
        self.videoName=dict[@"videoName"];
        self.time=dict[@"time"];
        self.customerCount=dict[@"customerCount"];
        self.content=dict[@"content"];
    }
    return self;
}
+ (UserinfoModel3 *)modelWithDictionary:(NSDictionary *)dict
{
    UserinfoModel3 *model3=[[UserinfoModel3 alloc]initWithDictionary:dict];
    return model3;
}
@end
