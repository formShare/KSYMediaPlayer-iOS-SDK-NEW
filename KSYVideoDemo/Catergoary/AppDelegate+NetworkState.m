//
//  AppDelegate+NetworkState.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/23.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "AppDelegate+NetworkState.h"
#import "Reachability.h"

@interface AppDelegate ()

//@property (nonatomic) Reachability *hostReachability;
//@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;

@end
@implementation AppDelegate (NetworkState)

- (void)networkMonitorApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"www.baidu.com";
    
    Reachability *hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [hostReachability startNotifier];
    [self updateInterfaceWithReachability:hostReachability];

    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    [self updateInterfaceWithReachability:internetReachability];
    
    Reachability *wifiReachability = [Reachability reachabilityForLocalWiFi];
    [wifiReachability startNotifier];
    [self updateInterfaceWithReachability:wifiReachability];


}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];

    switch (netStatus)
    {
        case NotReachable:
        {

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络似乎已经断开，请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
            [alertView show];
            break;
        }
            
        case ReachableViaWWAN:
        {
            NSLog(@"3G");

            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"wifi");

            break;
        }
            default:
            break;
    }
    
    
}

@end
