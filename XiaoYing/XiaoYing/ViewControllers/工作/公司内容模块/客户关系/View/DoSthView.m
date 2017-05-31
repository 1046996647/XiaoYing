//
//  DoSthView.m
//  XiaoYing
//
//  Created by ZWL on 16/2/2.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DoSthView.h"
@interface DoSthView()
{
}
@property (nonatomic,strong) UILabel *lab1;//2016-01-01~2016-01-28
@property (nonatomic,strong) UILabel *lab2;//优先级：高，中，低
@property (nonatomic,strong) UILabel *lab3;//已完成，进行中，未完成

@end

@implementation DoSthView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //初始化UI控件
        [self initUI];
    }
    return self;
}
//初始化UI控件
- (void)initUI{
    self.lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 14)];
    self.lab1.text = @"2016-01-01~2016-01-28";
    self.lab1.textColor = [UIColor colorWithHexString:@"#333333"];
    self.lab1.font = [UIFont systemFontOfSize:14];
    self.lab1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab1];
    
    
    self.lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12+14+10, kScreen_Width, 12)];
    self.lab2.text = @"优先级：高，中，低";
    self.lab2.textColor = [UIColor colorWithHexString:@"#333333"];
    self.lab2.font = [UIFont systemFontOfSize:14];
    self.lab2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab2];

    self.lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12+14+10+12+6, kScreen_Width, 12)];
    self.lab3.text = @"优先级：高，中，低";
    self.lab3.textColor = [UIColor colorWithHexString:@"#333333"];
    self.lab3.font = [UIFont systemFontOfSize:14];
    self.lab3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab3];
    
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 12+14+10+12+6+12+11.5, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self addSubview:viewline];

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
