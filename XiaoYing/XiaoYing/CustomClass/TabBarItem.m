//
//  TabBarItem.m
//  WaiMai
//
//  Created by imac on 15/10/4.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "TabBarItem.h"

@implementation TabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 子视图
        
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.frame = CGRectMake((self.width - 30) / 2.0, 2, 30, 30);
        _imageBtn.userInteractionEnabled = NO;
        [self addSubview:_imageBtn];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageBtn.bottom, self.width, 16)];
        _title.font = [UIFont systemFontOfSize:10];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor lightGrayColor];
        [self addSubview:_title];
    }
    return self;
}
@end
