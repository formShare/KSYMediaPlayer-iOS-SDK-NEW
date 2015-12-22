//
//  Model3.h
//  AMZVideoDemo
//
//  Created by 孙健 on 15/12/14.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model3 : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *customerCount;
@property (nonatomic, copy) NSString *content;

//两个方法:1.静态方法 2.动态方法
//动态方法
-(Model3 *)initWithDictionary:(NSDictionary *)dict;
//静态方法
+(Model3 *)modelWithDictionary:(NSDictionary *)dict;


@end
