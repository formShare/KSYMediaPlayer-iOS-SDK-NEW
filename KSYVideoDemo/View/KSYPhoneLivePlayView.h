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
    KSYPhoneLivePlay,
    KSYPhoneLivePlayBlock,
} KSYPhoneLivePlayState;

@interface KSYPhoneLivePlayView : UIView<KSYMediaPlayerDelegate>


- (BOOL)start;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) KSYPhoneLivePlayState playState;
@property (nonatomic, copy) void (^liveBroadcastCloseBlock)();
@property (nonatomic, copy) void (^liveBroadcastReporteBlock)();
@end
