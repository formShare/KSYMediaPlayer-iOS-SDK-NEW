//
//  UserinfoModel3.h
//  KSYVideoDemo
//
//  Created by KSC on 15/12/30.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserinfoModel3 : NSObject


@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *customerCount;
@property (nonatomic, copy) NSString *content;


-(UserinfoModel3 *)initWithDictionary:(NSDictionary *)dict;

+(UserinfoModel3 *)modelWithDictionary:(NSDictionary *)dict;
@end
