//
//  UIViewController+PlayerState.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/7.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "UIViewController+PlayerState.h"

@implementation UIViewController (PlayerState)

- (void)controScrenState
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (_deviceOrientation!=orientation) {
        if (orientation == UIDeviceOrientationPortrait)
        {
//            self.deviceOrientation = orientation;
//            [self minimizeVideo];
        }
        else if (orientation == UIDeviceOrientationLandscapeRight||orientation == UIDeviceOrientationLandscapeLeft)
        {
//            self.deviceOrientation = orientation;
//            [self launchFullScreen];
        }
//        [_mediaControlViewController reSetLoadingViewFrame];
//    }
}

//- (void)launchFullScreen
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    if (!_fullScreenModeToggled) {
//        _fullScreenModeToggled = YES;
//        [self launchFullScreenWhileUnAlwaysFullscreen];
//    }
//    else {
//        [self launchFullScreenWhileFullScreenModeToggled];
//    }
//    [_mediaControlViewController reSetLoadingViewFrame];
//}
//
//- (void)minimizeVideo
//{
//    if (_fullScreenModeToggled) {
//        _fullScreenModeToggled = NO;
//        self.navigationController.navigationBar.hidden = NO;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO
//                                                withAnimation:UIStatusBarAnimationFade];
//        [self minimizeVideoWhileUnAlwaysFullScreen];
//    }
//    [_mediaControlViewController reSetLoadingViewFrame];
//}
//
//
//- (void)launchFullScreenWhileFullScreenModeToggled{
//    if ([UIApplication sharedApplication].statusBarOrientation == (UIInterfaceOrientation)[[UIDevice currentDevice] orientation]) {
//        return;
//    }
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (!KSYSYS_OS_IOS8) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
//    }
//    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
//                          delay:0.0f
//                        options:(UIViewAnimationOptions)UIViewAnimationCurveLinear
//                     animations:^{
//                         float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
//                         float deviceWidth = [[UIScreen mainScreen] bounds].size.width;
//                         UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//                         CGFloat angle =((orientation==UIDeviceOrientationLandscapeLeft)?(-M_PI):M_PI);
//                         
//                         _player.videoView.transform = CGAffineTransformRotate(_player.videoView.transform, angle);
//                         _mediaControlViewController.view.transform = CGAffineTransformRotate(_mediaControlViewController.view.transform, angle);
//                         
//                         [_player.videoView setCenter:CGPointMake(deviceWidth/2, deviceHeight/2)];
//                         _player.videoView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
//                         [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
//                     }
//                     completion:^(BOOL finished) {
//                         _beforeOrientation = [UIDevice currentDevice].orientation;
//                     }];
//}

//- (void)launchFullScreenWhileUnAlwaysFullscreen
//{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (orientation == UIDeviceOrientationLandscapeRight) {
//        if (!KSYSYS_OS_IOS8) {
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
//        }
//        else {
//        }
//    }
//    else {
//        if (!KSYSYS_OS_IOS8) {
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//            
//        }
//        else {
//        }
//    }
//    self.previousBounds = _player.videoView.frame;
//    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
//                          delay:0.0f
//                        options:UIViewAnimationOptionLayoutSubviews//UIViewAnimationCurveLinear
//                     animations:^{
//                         float deviceHeight = KSYSYS_OS_IOS8?[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height;
//                         float deviceWidth = KSYSYS_OS_IOS8?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width;
//                         
//                         deviceHeight = [[UIScreen mainScreen] bounds].size.height;
//                         deviceWidth = [UIScreen mainScreen].bounds.size.width;
//                         if (orientation == UIDeviceOrientationLandscapeRight) {
//                             _player.videoView.transform = CGAffineTransformRotate(_player.videoView.transform, -M_PI_2);
//                             _mediaControlViewController.view.transform = CGAffineTransformRotate( _mediaControlViewController.view.transform, -M_PI_2);
//                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
//                             mediaControlView.center= _player.videoView.center;
//                             
//                         }else{
//                             _player.videoView.transform = CGAffineTransformRotate(_player.videoView.transform, M_PI_2);
//                             _mediaControlViewController.view.transform = CGAffineTransformRotate( _mediaControlViewController.view.transform, M_PI_2);
//                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
//                             mediaControlView.center= _player.videoView.center;
//                         }
//                         
//                         if ([UIDevice currentDevice].systemVersion.floatValue < 8 ) {
//                             
//                             [_player.videoView setCenter:CGPointMake(deviceWidth/2, deviceHeight/2)];
//                             _player.videoView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
//                             
//                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
//                             mediaControlView.bounds = _player.videoView.bounds;
//                             mediaControlView.center = CGPointMake(deviceWidth/2, deviceHeight/2);
//                         }else{
//                             [_player.videoView setCenter:CGPointMake(deviceWidth/2, deviceHeight/2)];
//                             _player.videoView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
//                             
//                             MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
//                             mediaControlView.center = CGPointMake(deviceWidth/2, deviceHeight/2);
//                             mediaControlView.bounds = CGRectMake(0, 0, deviceHeight, deviceWidth);
//                         }
//                         [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
//                     }
//                     completion:^(BOOL finished) {
//                         _beforeOrientation = [UIDevice currentDevice].orientation;
//                     }
//     ];
//}
//
//- (void)minimizeVideoWhileUnAlwaysFullScreen{
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
//    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         _player.videoView.transform = CGAffineTransformIdentity;
//                         _mediaControlViewController.view.transform = CGAffineTransformIdentity;
//                         _player.videoView.frame = self.previousBounds;
//                         MediaControlView *mediaControlView = (MediaControlView *)(_mediaControlViewController.view);
//                         mediaControlView.bounds = _player.videoView.bounds;
//                         mediaControlView.center = CGPointMake(mediaControlView.bounds.size.width / 2, mediaControlView.bounds.size.height/2);
//                         
//                         [(MediaControlView *)_mediaControlViewController.view updateSubviewsLocation];
//                     }
//                     completion:^(BOOL success){
//                         _beforeOrientation = [UIDevice currentDevice].orientation;
//                         
//                     }];
//}
//
#pragma mark - minimize Exchange

//- (void)minimizeVideoWhileIsAlwaysFullScreen{
//    
//    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         _player.videoView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/2);
//                     }
//                     completion:^(BOOL success){
//                         _beforeOrientation = [UIDevice currentDevice].orientation;
//                     }];
//}

@end
