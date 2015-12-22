//
//  RootViewController.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/9/17.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "KSYMainViewController.h"
#import "VideoViewController.h"
#import "KSYPopilarLivePlayVC.h"
#import "KSYPopilarLivePlayBackVC.h"
#import "KSYPhoneLivePlayVC.h"
#import "KSYPhoneLivePlayBackVC.h"
#import "KSYVideoOnDemandPlayVC.h"
#import "KSYShortVideoPlayVC.h"

@interface KSYMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_sesionArr;
}
@end

@implementation KSYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"KSYPlayer";
    _sesionArr = [[NSArray alloc] initWithObjects:@"传统直播",@"手机直播",@"在线视频点播",@"短视频播放",@"列表浮窗", nil];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sesionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        case 1:
            row = 2;
            break;
        case 2:
            row = 1;
            break;
        case 3:
            row = 1;
            break;
        case 4:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sesionArr objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.textAlignment = 1;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"传统直播播放";
            }else {
                cell.textLabel.text = @"传统直播回放";
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"手机直播播放";
            }else {
                cell.textLabel.text = @"手机直播回放";
            }

        }
            break;
        case 2:
        {
            cell.textLabel.text = @"在线视频点播";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"短视频播放";
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"列表浮窗";
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                KSYPopilarLivePlayVC *popilarLivePlayVC = [KSYPopilarLivePlayVC new];
                [self.navigationController pushViewController:popilarLivePlayVC animated:YES];

            }else {
                KSYPopilarLivePlayBackVC *popilarLivePlayBackVC = [KSYPopilarLivePlayBackVC new];
                [self.navigationController pushViewController:popilarLivePlayBackVC animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                KSYPhoneLivePlayVC *phoneLivePlayerVC = [KSYPhoneLivePlayVC new];
                phoneLivePlayerVC.videoUrlString = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
//                phoneLivePlayerVC.videoUrlString = @"rtmp://test.live.ksyun.com/live/68D478.264";

                [self.navigationController presentViewController:phoneLivePlayerVC animated:YES completion:nil];
            }else{
                KSYPhoneLivePlayBackVC *phoneLivePlayBackVC = [KSYPhoneLivePlayBackVC new];
                phoneLivePlayBackVC.videoUrlString = @"http://121.42.58.232:8980/hls_test/1.m3u8";
                [self.navigationController presentViewController:phoneLivePlayBackVC animated:YES completion:nil];

            }
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {

        }
            break;
        case 4:
        {

        }
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
