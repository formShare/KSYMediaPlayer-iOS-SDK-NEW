//
//  KSYShortVideoPlayView.h
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPopularVideoView.h"
#import "KSYTopView.h"
#import "KSYBottomView.h"

@interface KSYShortVideoPlayView : KSYPopularVideoView

- (instancetype)initWithFrame:(CGRect)frame UrlPathString:(NSString *)urlPathString;

@property (nonatomic, strong) KSYTopView *topView;
@property (nonatomic, strong) KSYBottomView *bottomView;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat curPosition;


@end
