//
//  KSYVideoPlayerView.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/24.
//  Copyright © 2015年 kingsoft. All rights reserved.
//


#import "KSYPopularVideoView.h"


@interface KSYVideoPlayerView : KSYPopularVideoView

- (instancetype)initWithFrame:(CGRect)frame UrlWithString:(NSString *)urlString playState:(KSYPopularLivePlayState)playState;
@property (nonatomic, copy) void (^changeNavigationBarColor)();
@property (nonatomic, copy) void (^lockScreen)(BOOL isLocked);


@end
