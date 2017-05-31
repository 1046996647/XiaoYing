//
//  XYSearchBar.m
//  XiaoYing
//
//  Created by ZWL on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYSearchBar.h"

@implementation XYSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
//        self.showsCancelButton = NO;
        self.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
        [self setBackgroundImage:[UIImage new]];
        self.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    
    }
    return self;
}

@end
