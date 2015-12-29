//
//  AppDelegate.m
//  KSYVideoDemo
//
//  Created by JackWong on 15/3/20.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import "KSYMainViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)redirectNSlogToDocumentFolder

{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"NSLog.txt"];
    
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarOrientation = UIInterfaceOrientationPortrait;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    KSYMainViewController *viewController = [[KSYMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
//    [self redirectNSlogToDocumentFolder];
    return YES;
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }else{
        //判断一下当前设备的方向
        if ([[UIApplication sharedApplication]statusBarOrientation]==UIInterfaceOrientationLandscapeLeft) {
            return UIInterfaceOrientationMaskLandscapeLeft;
        }else if([[UIApplication sharedApplication]statusBarOrientation]==UIInterfaceOrientationLandscapeRight){
            return UIInterfaceOrientationMaskLandscapeRight;
        }else if([[UIApplication sharedApplication]statusBarOrientation]==UIInterfaceOrientationPortrait){
            return UIInterfaceOrientationMaskPortrait;
        }
        return 0;
    }
}
//- (void)applicationWillResignActive:(UIApplication *)application {
//    NSLog(@"applicationWillResignActive,应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了");
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    NSLog(@"applicationDidEnterBackground 程序被推送到后台");
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//     NSLog(@"applicationWillEnterForeground程序从后台将要重新回到前台");
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSLog(@"applicationDidBecomeActive应用程序入活动状态执行");
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    NSLog(@"applicationWillTerminate程序将要退出");
//}

@end
