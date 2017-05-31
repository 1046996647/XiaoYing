//
//  HSBlockButton.m
//  XiaoYing
//
//  Created by chenchanghua on 16/12/1.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "HSBlockButton.h"

@implementation HSBlockButton

- (void)addTouchUpInsideBlock:(ButtonBlock)block
{
    _block = block;
    [self addTarget:self action:@selector(buttonTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouchUpInsideAction:(UIButton *)button
{
    _block(button);
}

@end
