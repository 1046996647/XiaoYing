//
//  PushView.m
//  XiaoYing
//
//  Created by GZH on 16/7/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "PushView.h"

@implementation PushView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self pushView];
    }
    return self;
}



- (void)pushView {
    
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.4;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverBackAction)];
    [_coverView addGestureRecognizer:tap];
    
    _littleView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 270) / 2, (kScreen_Height - 250) / 2, 270 , 250)];
    _littleView.backgroundColor = [UIColor whiteColor];
    _littleView.layer.cornerRadius = 5;
    _littleView.clipsToBounds = YES;
    [window addSubview:_littleView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 270, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.text = @"同级单元";
    [_littleView addSubview:titleLabel];
    

}

- (void)coverBackAction {
    [_coverView removeFromSuperview];
    [_littleView removeFromSuperview];
}

- (void)setRanks:(NSNumber *)ranks
{
    _ranks = ranks;
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        if ([self.ranks isEqualToNumber:dic[@"Ranks"]]) {
            [titleArr addObject:dic[@"Title"]];
        }
    }
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake((10 + 90 * (i % 3)), 40 + (((250 - 40 - 10) / 7) * (i / 3)), (kScreen_Width - 60) / 3, 30)];
        Label.text = titleArr[i];
        Label.textAlignment = NSTextAlignmentCenter;
        Label.font = [UIFont systemFontOfSize:14];
        Label.textColor = [UIColor colorWithHexString:@"#848484"];
        [_littleView addSubview:Label];
    }
}





@end
