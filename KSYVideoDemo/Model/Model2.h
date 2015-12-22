//
//  Model2.h
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/9.
//  Copyright © 2015年 kingsoft. All rights reserved.
//  我只看你做了啥，做了几遍



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Model2 : NSObject

//属性
@property (nonatomic, copy) NSString *hostImageProf;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *hostLevel;
@property (nonatomic, copy) NSString *fansCount;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *studioName;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *playtimes;
@property (nonatomic, copy) NSString *content;
//方法
//动态方法
- (Model2 *)initWithDictionary:(NSDictionary *)dict;
//静态方法
+ (Model2 *)modelWithDictionary:(NSDictionary *)dict;
@end
