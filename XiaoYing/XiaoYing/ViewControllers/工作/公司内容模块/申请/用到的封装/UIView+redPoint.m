//
//  UIView+redPoint.m
//  XiaoYing
//
//  Created by chenchanghua on 16/11/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "UIView+redPoint.h"

#define USERDEF [NSUserDefaults standardUserDefaults]

@implementation UIView (redPoint)

#pragma other(redPoint)
//添加显示
- (void)showRedAtOffSetX:(float)offsetX AndOffSetY:(float)offsetY OrValue:(NSString *)value{
    [self removeRedPoint];//添加之前先移除，避免重复添加
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 998;
    
    CGFloat viewWidth = 12;
    if (value) {
        viewWidth = 18;
        UILabel *valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        valueLbl.text = value;
        valueLbl.font = [UIFont systemFontOfSize:12];
        valueLbl.textColor = [UIColor whiteColor];
        valueLbl.textAlignment = NSTextAlignmentCenter;
        valueLbl.clipsToBounds = YES;
        [badgeView addSubview:valueLbl];
    }
    
    badgeView.layer.cornerRadius = viewWidth / 2;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    if (offsetX == 0) {
        //        offsetX = 1;
        offsetX = -viewWidth/2.0;
    }
    
    if (offsetY == 0) {
        //        offsetY = 0.05;
        offsetY = -viewWidth/2.0;
    }
    CGFloat x = ceilf(tabFrame.size.width + offsetX);
    CGFloat y = 0;
    if (offsetY == -viewWidth/2.0) {
        y = ceilf(offsetY);
    }else{
        y = ceilf(offsetY * tabFrame.size.height);
    }
    
    badgeView.frame = CGRectMake(x, y, viewWidth, viewWidth);
    [self addSubview:badgeView];
}

//隐藏
- (void)hideRedPoint{
    [self removeRedPoint];
}

//移除
- (void)removeRedPoint{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 998) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark Tabbar(redPoint)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    NSString *keyStr = [NSString stringWithFormat:@"%d_HADSET",index];
    if ([USERDEF objectForKey:keyStr]) {
        return;
    } else {
        [USERDEF setObject:@"HADSET" forKey:keyStr];
    }
    //移除之前可能存在的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 6;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.55) / 5; //5为tabbaritem的总个数
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.05 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 12, 12);
    
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    NSString *keyStr = [NSString stringWithFormat:@"%d_HADSET",index];
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    if ([USERDEF objectForKey:keyStr]) {
        [USERDEF removeObjectForKey:keyStr];
    }
}

//移除
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
