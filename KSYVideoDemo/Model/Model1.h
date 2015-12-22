//
//  Model1.h
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/9.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model1 : NSObject
//属性
@property (nonatomic, copy) NSString *imageName;//图片名称
@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, copy) NSString *time;//发布时间
@property (nonatomic, copy) NSString *content;//评论
//方法
//动态方法
-(Model1 *)initWithDictionary:(NSDictionary *)dict;
//静态方法
+(Model1 *)modelWithDictionary:(NSDictionary *)dict;
@end
