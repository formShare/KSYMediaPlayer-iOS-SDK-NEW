//
//  KSYPhoneLivePlayVC.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPhoneLivePlayVC.h"
#import "KSYPhoneLivePlayView.h"
#import "CommentModel.h"
@interface KSYPhoneLivePlayVC ()
{
    KSYPhoneLivePlayView *_phoneLivePlayVC;
}
@end

@implementation KSYPhoneLivePlayVC


- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) wekSelf = self;
    _phoneLivePlayVC = [[KSYPhoneLivePlayView alloc] initWithFrame:self.view.bounds];
    _phoneLivePlayVC.urlString = self.videoUrlString;
    [_phoneLivePlayVC start];
    _phoneLivePlayVC.liveBroadcastCloseBlock = ^{
        
        [wekSelf dismissViewControllerAnimated:YES completion:nil];
    };
    _phoneLivePlayVC.liveBroadcastReporteBlock = ^{
        NSLog(@"举报");
    };
    [self.view addSubview:_phoneLivePlayVC];
    
    //模拟点赞事件
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(praiseEvent) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(presentEvent) userInfo:nil repeats:YES];

    //模拟观众评论
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addNewCommentWith) userInfo:nil repeats:YES];
    NSLog(@"%@",timer);

}


- (void)praiseEvent
{
    [_phoneLivePlayVC onPraiseWithSpectatorsInteractiveType:SpectatorsInteractivePraise];
}

- (void)presentEvent
{
    [_phoneLivePlayVC onPraiseWithSpectatorsInteractiveType:SpectatorsInteractivePresent];

}

- (void)addNewCommentWith
{
    CommentModel *model = [[CommentModel alloc] init];
    model.userComment = @"哇，大美女！";
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    model.backColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.9];
    
    CGFloat hue1 = ( arc4random() % 256 / 256.0 );
    CGFloat saturation1 = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness1 = ( arc4random() % 128 / 256.0 ) + 0.5;
    model.headColor = [UIColor colorWithHue:hue1 saturation:saturation1 brightness:brightness1 alpha:1];

    [_phoneLivePlayVC addNewCommentWith:model];
}

- (void)dealloc
{

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
