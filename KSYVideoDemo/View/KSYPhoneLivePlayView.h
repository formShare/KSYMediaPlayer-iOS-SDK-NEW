//
//  KSYPhoneLivePlayView.h
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSYPlayer.h"

typedef enum : NSUInteger {
    KSYPhoneLivePlay,       //手机直播播放
    KSYPhoneLivePlayBlock,  //手机直播回放
} KSYPhoneLivePlayState;

typedef enum : NSUInteger {
    SpectatorsInteractivePraise = 0,    //点赞
    SpectatorsInteractivePresent = 1,   //礼物
} SpectatorsInteractiveType;            //用户互动类型

@interface KSYPhoneLivePlayView : UIView<KSYMediaPlayerDelegate>

//启动
- (BOOL)start;

//视频url
@property (nonatomic, copy) NSString *urlString;
//播放类型
@property (nonatomic, assign) KSYPhoneLivePlayState playState;
//关闭时间block
@property (nonatomic, copy) void (^liveBroadcastCloseBlock)();
//举报事件block
@property (nonatomic, copy) void (^liveBroadcastReporteBlock)();


- (void)addNewCommentWith:(id)model;
//点赞
- (void)onPraiseWithSpectatorsInteractiveType:(SpectatorsInteractiveType )type;
@end
