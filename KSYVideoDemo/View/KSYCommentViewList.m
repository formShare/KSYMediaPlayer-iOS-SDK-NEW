//
//  KSYCommentViewList.m
//  KSYVideoDemo
//
//  Created by 崔崔 on 15/12/8.
//  Copyright © 2015年 kingsoft. All rights reserved.
//

#import "KSYCommentViewList.h"
#import "CommentModel.h"

#define DeviceSizeBounds [UIScreen mainScreen].bounds

@interface KSYCommentViewList ()
{
    NSMutableArray  *_userArr;
}


@end


@implementation KSYCommentViewList

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _userArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)newUserAdd:(id)object
{
    NSLog(@"添加新成员");
    CommentModel *model = (CommentModel *)object;

//    for (NSInteger i = _userArr.count - 1; i < _userArr.count; i--) {
//        UIView *testView = [_userArr objectAtIndex:i];
//        NSLog(@"user.count is %@",@(_userArr.count));
//        NSInteger ii = [_userArr indexOfObject:testView];
//        if (ii == 0) {
//            testView.backgroundColor = [UIColor yellowColor];
//            [UIView beginAnimations:@"move" context:nil];
//            [UIView setAnimationDuration:1];
//            [UIView setAnimationDelegate:self];
//            //改变它的frame的x,y的值
//            testView.frame=CGRectMake(10, self.frame.size.height - (ii + 1) * 35, 100, 30);
//            [UIView commitAnimations];
//            
//        }else {
//            //改变它的frame的x,y的值
//            testView.frame=CGRectMake(10, self.frame.size.height - (ii + 1) * 35, 100, 30);
//            
//        }
//
//    }

    for (UIView *testView in _userArr) {
        testView.backgroundColor = [UIColor yellowColor];
        NSLog(@"user.count is %@",@(_userArr.count));
        NSInteger ii = [_userArr indexOfObject:testView];
//        if (ii == _userArr.count + 1) {
//            testView.backgroundColor = [UIColor yellowColor];
//            [UIView beginAnimations:@"move" context:nil];
//            [UIView setAnimationDuration:1];
//            [UIView setAnimationDelegate:self];
//            //改变它的frame的x,y的值
//            testView.frame=CGRectMake(10, self.frame.size.height - (ii + 1) * 35, 100, 30);
//            [UIView commitAnimations];

//        }else {
            //改变它的frame的x,y的值
            testView.frame=CGRectMake(10, self.frame.size.height - (ii + 1) * 35, 100, 30);
//
//        }

    }
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 30, 100, 30)];
    testView.backgroundColor = [UIColor greenColor];
    [self addSubview:testView];
    [_userArr addObject:testView];

//    [UIView animateWithDuration:2 animations:^(void){
//        testView.alpha = 0;
//        
//    } completion:^(BOOL finish){
//        NSLog(@"删除旧成员");
//        testView.alpha = 1;
//    }];


    
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    //改变它的frame的x,y的值
    testView.frame = CGRectMake(10, self.frame.size.height, 100, 30);
//    testView.alpha = 0;
    [UIView commitAnimations];

    
//    [UIView animateWithDuration:3 animations:^(void){
//        testView.alpha = 0;
//
//    } completion:^(BOOL finish){
//        NSLog(@"删除旧成员");
//        [_userArr removeObject:testView];
//        [testView removeFromSuperview];
//    }];
//

    //    [testView removeFromSuperview];

}


@end
