//
//  KSYPopularVideoView.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYBasePlayView.h"
#import "SJDetailView.h"
#import "KSYCommentView.h"
@interface KSYPopularVideoView : KSYBasePlayView

@property (nonatomic,strong) SJDetailView *detailView;
@property (nonatomic,strong)  KSYCommentView *commtenView;
@property (nonatomic, assign) KSYGestureType gestureType;



- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;

- (void)resetTextFrame;

@end
