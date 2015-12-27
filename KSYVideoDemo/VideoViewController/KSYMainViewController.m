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

@interface KSYMainViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *_sesionArr;
    UITextField *_httpTextF;
    UITextField *_rtmpTextF;
    UISwitch *_switchControl;
}
@end

@implementation KSYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"KSYPlayer";
    self.view.backgroundColor = [UIColor whiteColor];
    _sesionArr = [[NSArray alloc] initWithObjects:@"传统直播",@"手机直播",@"在线视频点播",@"短视频播放",@"列表浮窗", nil];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 20, 300, 20)];
    label1.text = @"APP退到后台，锁屏，来电等中断是否释放播放器";
    label1.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:label1];
    
    UILabel *httpUrlLabl = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom + 5, 60, 20)];
    httpUrlLabl.text = @"点播URL";
    httpUrlLabl.font = [UIFont systemFontOfSize:13.0];

    [self.view addSubview:httpUrlLabl];
    
    UILabel *rtmpUrlLabl = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, httpUrlLabl.bottom + 7, 60, 20)];
    rtmpUrlLabl.text = @"点播URL";
    rtmpUrlLabl.font = [UIFont systemFontOfSize:13.0];

    [self.view addSubview:rtmpUrlLabl];

    _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(label1.right + 8, label1.top - 5, 40, 25)];
    [_switchControl addTarget:self action:@selector(switchControlEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switchControl];
    
    _httpTextF = [[UITextField alloc] initWithFrame:CGRectMake(httpUrlLabl.right + 5, httpUrlLabl.top, 250, 20)];
    _httpTextF.text = @"http://121.42.58.232:8980/hls_test/1.m3u8";
    _httpTextF.borderStyle = UITextBorderStyleRoundedRect;
    _httpTextF.returnKeyType = UIReturnKeyDone;
    _httpTextF.font = [UIFont systemFontOfSize:13.0];
    _httpTextF.delegate = self;
    [self.view addSubview:_httpTextF];
    
    _rtmpTextF = [[UITextField alloc] initWithFrame:CGRectMake(rtmpUrlLabl.right + 5, rtmpUrlLabl.top, 250, 20)];
    _rtmpTextF.text = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    _rtmpTextF.borderStyle = UITextBorderStyleRoundedRect;
    _rtmpTextF.returnKeyType = UIReturnKeyDone;
    _rtmpTextF.font = [UIFont systemFontOfSize:13.0];
    _rtmpTextF.delegate = self;
    [self.view addSubview:_rtmpTextF];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rtmpUrlLabl.bottom + 10, self.view.frame.size.width, self.view.frame.size.height - rtmpUrlLabl.bottom - 10)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:tableView];
}

- (void)switchControlEvent:(UISwitch *)switchControl
{

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
                KSYPopilarLivePlayVC *view=[[KSYPopilarLivePlayVC alloc]init];
                [self.navigationController pushViewController:view animated:YES];
               
            }else {
                KSYPopilarLivePlayBackVC *view=[[KSYPopilarLivePlayBackVC alloc]init];
                [self.navigationController pushViewController:view animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                KSYPhoneLivePlayVC *phoneLivePlayerVC = [KSYPhoneLivePlayVC new];
                phoneLivePlayerVC.videoUrlString = _rtmpTextF.text;
                phoneLivePlayerVC.isReleasePlayer = _switchControl.isOn;
//                phoneLivePlayerVC.videoUrlString = @"rtmp://test.live.ksyun.com/live/68D478.264";

                [self.navigationController presentViewController:phoneLivePlayerVC animated:YES completion:nil];
            }else{
                KSYPhoneLivePlayBackVC *phoneLivePlayBackVC = [KSYPhoneLivePlayBackVC new];
                phoneLivePlayBackVC.videoUrlString = _httpTextF.text;
                phoneLivePlayBackVC.isReleasePlayer = _switchControl.isOn;
                [self.navigationController presentViewController:phoneLivePlayBackVC animated:YES completion:nil];

            }
        }
            break;
        case 2:
        {
            KSYVideoOnDemandPlayVC *view=[[KSYVideoOnDemandPlayVC alloc]init];
            view.videoPath=[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp4"];
            [self.navigationController pushViewController:view animated:YES];
            view.isRtmp=NO;
        }
            break;
        case 3:
        {
            KSYShortVideoPlayVC *view=[[KSYShortVideoPlayVC alloc]init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 4:
        {
            KSYPopilarLivePlayVC *view=[[KSYPopilarLivePlayVC alloc]init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
