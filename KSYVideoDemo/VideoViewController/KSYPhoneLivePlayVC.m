//
//  KSYPhoneLivePlayVC.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYPhoneLivePlayVC.h"
#import "KSYPhoneLivePlayView.h"

@interface KSYPhoneLivePlayVC ()

@end

@implementation KSYPhoneLivePlayVC


- (void)viewDidLoad {
    [super viewDidLoad];

    KSYPhoneLivePlayView *phoneLivePlayVC = [[KSYPhoneLivePlayView alloc] initWithFrame:self.view.bounds];
    phoneLivePlayVC.urlString = self.videoUrlString;
    [phoneLivePlayVC start];
    phoneLivePlayVC.liveBroadcastCloseBlock = ^{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:phoneLivePlayVC];

}


- (void)dealloc
{

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
