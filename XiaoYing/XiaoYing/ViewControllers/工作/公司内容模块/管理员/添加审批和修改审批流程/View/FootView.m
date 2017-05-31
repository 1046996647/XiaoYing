//
//  FootView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FootView.h"

@implementation FootView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *lineView1;
        UIView *lineView;
        
        self.leftbt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbt.frame = CGRectMake(0, 0, kScreen_Width/2, 44);
        
        [self.leftbt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        self.leftbt.titleLabel.font = [UIFont systemFontOfSize:16];
        self.leftbt.tag = 10001;
        
        [self addSubview:self.leftbt];
        
        self.rightbt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbt.frame = CGRectMake(kScreen_Width/2+0.5, 0, kScreen_Width/2, 44);
         
        [self.rightbt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        self.rightbt.titleLabel.font = [UIFont systemFontOfSize:16];
        self.rightbt.tag=10002;
        [self addSubview:self.rightbt];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2, 11, 0.5, 20)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [self addSubview:lineView];
        
        lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
        lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [self addSubview:lineView1];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
