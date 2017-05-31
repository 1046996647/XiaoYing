//
//  AlertView.m
//  XiaoYing
//
//  Created by ZWL on 16/2/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
   UIView *deleteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-44*3-12-64,kScreen_Width, 44*3+12)];
    deleteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:deleteView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    label.text = @"邮件彻底删除后将不再恢复";
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [deleteView addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [deleteView addSubview:lineView];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, 44)];
    [deleteBtn setTitle:@"彻底删除" forState:UIControlStateNormal];
//    [deleteBtn addTarget:[self superview] action:@selector(deleteAllAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#f75d5c"] forState:UIControlStateNormal];
    [deleteView addSubview:deleteBtn];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44*2, kScreen_Width, 12)];
    view.backgroundColor = [UIColor lightGrayColor];
    [deleteView addSubview:view];
    
    UIButton *noDeleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, kScreen_Width, 44)];
    [noDeleteBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noDeleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [noDeleteBtn addTarget:[self superview] action:@selector(noDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteView addSubview:noDeleteBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
