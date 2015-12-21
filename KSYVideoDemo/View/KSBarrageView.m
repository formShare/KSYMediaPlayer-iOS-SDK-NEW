//
//  KSBarrageView.m
//
//
//  Created by yuchenghai on 14/12/22.
//  Copyright (c) 2014年 kuwo.cn. All rights reserved.
//  弹幕功能的使用步骤：通过单例来解决这个问题
//  1.初始化弹幕视图 _danmuView
//  2.将弹幕视图添加大当前视图上： [self.view addSubView:_danmuView]
//  3.得到弹幕数据 _danmuView.dataArray
//  4.开始 _danmuView start
//  5.停止 _danmuView pause
//  6.设置弹幕字体的大小 _danmuView setDanmuTextFont
//  7.设置弹幕透明度 _danmuView setDanmuAlpha

#import "KSBarrageView.h"
#import "UIView+Sizes.h"
#import "KSBarrageItemView.h"

#define ITEMTAG 300

@implementation KSBarrageView {
    
    UIImageView *_avatarView;//图片视图
    UIImageView *_giftView;//图片视图
    
    NSTimer *_timer;//定时器
    NSInteger _curIndex;//索引
    
    //创建弹幕项目
    KSBarrageItemView *_item;
    CGFloat _font;
    CGFloat _alpha;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self setClipsToBounds:YES];//如果子视图的边界超出了父视图的边界，则超出的部分被裁减掉
        
        _curIndex = 0;
    }
    return self;
}
#pragma mark 开始弹幕
- (void)start {
    //如果数组中有内容
    if (_dataArray && _dataArray.count > 0) {
        if (!_timer) {//如果定时器还未创建
            //创建定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(postView) userInfo:nil repeats:YES];
        }
    }
}
#pragma mark 结束弹幕
- (void)stop {
    if (_timer) {
        //停止定时器
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark 设置字体大小
-(void)setDanmuFont:(CGFloat)font
{
    _font=font;
}
#pragma mark 设置弹幕透明度
-(void)setDanmuAlpha:(CGFloat)alpha
{
    _alpha=alpha;
}
#pragma mark 发送弹幕
- (void)postView {
    //如果数组不为空
    if (_dataArray && _dataArray.count > 0) {
        //将屏幕均分成30份 随即取得顶部位置
        int indexPath = random()%(int)((self.frame.size.height)/20);
        int top = indexPath * 20;//单条弹幕的宽度
        //KSBarrageItemView设置弹幕的状态
        UIView *view = [self viewWithTag:indexPath + ITEMTAG];  
        if (view && [view isKindOfClass:[KSBarrageItemView class]]) {
            return;
        }
        
        NSDictionary *dict = nil;//创建一个字典
        if (_dataArray.count > _curIndex) {//如果数组内容大于当前索引
            dict = _dataArray[_curIndex];//给字典赋值
            _curIndex++;//索引加1
        } else {
            _curIndex = 0;
            dict = _dataArray[_curIndex];
            _curIndex++;
        }
        
        for (KSBarrageItemView *view in self.subviews) {
            if ([view isKindOfClass:[KSBarrageItemView class]] && view.itemIndex == _curIndex-1) {
                return;
            }
        }
        
        _item = [[KSBarrageItemView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, top, 10, 30)];
        [_item KSBarrageItemViewsetDanmuFont:_font];
        [_item KSBarrageItemViewsetDanmuAlpha:_alpha];
        id avatar = [dict objectForKey:@"avatar"];
        NSString *content = [dict objectForKey:@"content"];
        if ([avatar isKindOfClass:[UIImage class]]) {
            [_item setAvatarWithImage:avatar withContent:content];
        } else if ([avatar isKindOfClass:[NSString class]]){
            UIImage *image = [UIImage imageNamed:avatar];
            if (image) {
                [_item setAvatarWithImage:image withContent:content];
            } else {
                // 这里使用网络图片，请加入sdwebImage库
//                [item setAvatarUrl:avatar withContent:content];
            }
        } else {
            return;
        }
        
        _item.itemIndex = _curIndex-1;
        _item.tag = indexPath + ITEMTAG;
        [self addSubview:_item];
        
        CGFloat speed = 100;
        speed += random()%10;
        CGFloat time = (_item.width+[[UIScreen mainScreen] bounds].size.width) / speed;
        
        [UIView animateWithDuration:time delay:0.f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear  animations:^{
            _item.left = -_item.width;
        } completion:^(BOOL finished) {
            [_item removeFromSuperview];
        }];
        
    }
}

@end
