//
//  NotSearchView.m
//  XiaoYing
//
//  Created by ZWL on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NotSearchView.h"

@implementation NotSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 185) / 2, 50, 185, 161)];
        image.image = [UIImage imageNamed:@"face3"];
        [self addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, image.bottom + 12, kScreen_Width - 24, 16)];
        label.text = @"对不起, 找不到对象!";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#848484"];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
