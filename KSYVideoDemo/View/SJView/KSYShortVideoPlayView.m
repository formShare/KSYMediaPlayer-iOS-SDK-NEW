//
//  KSYShortVideoPlayView.m
//  KSYVideoDemo
//
//  Created by 孙健 on 15/12/25.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYShortVideoPlayView.h"
#import "KSYCommentView.h"

@interface KSYShortVideoPlayView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *ksyShortTableView;
    NSString *videoString;
    KSYCommentView *commentView;

}
@end


@implementation KSYShortVideoPlayView


- (instancetype)initWithFrame:(CGRect)frame UrlPathString:(NSString *)urlPathString
{
    videoString=urlPathString;
    //重置播放界面的大小
    self = [super initWithFrame:frame];//初始化父视图的(frame、url)
    if (self) {
        ksyShortTableView=[[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
        ksyShortTableView.delegate=self;
        ksyShortTableView.dataSource=self;
        [self addSubview:ksyShortTableView];
        NSString *path=[[NSBundle mainBundle] pathForResource:@"Model1" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        _models=[[NSMutableArray alloc]init];
        _modelsCells=[[NSMutableArray alloc]init];
        //利用代码块遍历
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_models addObject:[Model1 modelWithDictionary:obj]];
            KSY1TableViewCell *cell=[[KSY1TableViewCell alloc]init];
            [_modelsCells addObject:cell];
        }];
        [self addCommentView];
        commentView.hidden=YES;
    }
    return self;
}
#pragma mark 添加评论视图
- (void)addCommentView
{
    WeakSelf(KSYShortVideoPlayView);
    commentView=[[KSYCommentView alloc]initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
    commentView.textFieldDidBeginEditing=^(){
        [weakSelf changeCommentViewFrame];
    };
    commentView.send=^(){
        [weakSelf rechangeCommentViewFrame];
    };
    [self addSubview:commentView];
}
#pragma mark 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return _models.count;
    }
}
#pragma mark 每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1=@"identify1";
    static NSString *cellId2=@"identify2";
    if (indexPath.section==0) {
        commentView.hidden=YES;
        [_videoCell.ksyShortView play];
        _videoCell=[tableView dequeueReusableCellWithIdentifier:cellId1];
        if (!_videoCell) {
            _videoCell=[[KSYShortTabelViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1 urlstr:videoString frame:CGRectMake(0, 0, self.width, 260)];
        }
        return _videoCell;
    }else if(indexPath.section==1){
        commentView.hidden=NO;
        [_videoCell.ksyShortView pause];
        KSY1TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId2];
        if (!cell){
            cell=[[KSY1TableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"KSY1TableViewCellIdentify"];
            UIView* tempView=[[UIView alloc] initWithFrame:cell.frame];
            tempView.backgroundColor =KSYCOLER(90, 90, 90);
            cell.backgroundView = tempView;  //更换背景色     不能直接设置backgroundColor
            UIView* tempView1=[[UIView alloc] initWithFrame:cell.frame];
            tempView1.backgroundColor = KSYCOLER(100, 100, 100);
            cell.selectedBackgroundView = tempView1;
            
        }
        Model1 *SKYmodel=_models[indexPath.row];
        cell.model1=SKYmodel;
        return cell;
    }else{
        return nil;
    }
}
#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        return 260;
    }else if(indexPath.section==1){
        
        KSY1TableViewCell *cell=_modelsCells[indexPath.row];
        cell.model1=_models[indexPath.row];//这里执行set方法
        return cell.height;

    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (void)changeCommentViewFrame
{
    commentView.frame=CGRectMake(0, self.height/2-8, self.width, 40);
}
- (void)rechangeCommentViewFrame
{
    commentView.frame=CGRectMake(0, self.height-40, self.width, 40);
    UITextField *kTextField=(UITextField *)[self viewWithTag:kCommentFieldTag];
    [kTextField resignFirstResponder];
}

@end
