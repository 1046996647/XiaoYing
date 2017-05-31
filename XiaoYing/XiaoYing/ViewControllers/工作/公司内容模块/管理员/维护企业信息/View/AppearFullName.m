//
//  AppearFullName.m
//  XiaoYing
//
//  Created by GZH on 16/7/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AppearFullName.h"

@implementation AppearFullName


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self appearFullName];
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5.0;
        self.clipsToBounds = YES;
        self.alpha = 0.8;
        
    }
    return self;
}

- (void)appearFullName {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:view];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.width - 20, view.height - 20)];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:_label];
}


@end
