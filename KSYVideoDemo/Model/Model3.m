//
//  Model3.m
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/14.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "Model3.h"

@implementation Model3
- (Model3 *)initWithDictionary:(NSDictionary *)dict
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
+ (Model3 *)modelWithDictionary:(NSDictionary *)dict
{
    Model3 *model3=[[Model3 alloc]initWithDictionary:dict];
    return model3;
}
@end
