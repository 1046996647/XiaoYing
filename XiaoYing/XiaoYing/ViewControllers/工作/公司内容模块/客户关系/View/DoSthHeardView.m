//
//  DoSthHeardView.m
//  XiaoYing
//
//  Created by ZWL on 16/2/2.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DoSthHeardView.h"
@interface DoSthHeardView()
{
}
@property (nonatomic,strong)UILabel *startTimeLab;//开始时间
@property (nonatomic,strong)UILabel *endTimeLab;//至什么时间
@property (nonatomic,strong)UIButton *certainBt;//确定按钮
@property (nonatomic,strong)UIView *lowView;//下面的阴影
@end

@implementation DoSthHeardView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    UILabel *lab1;//从
    UILabel *lab2;//至
    
    UIView *viewline;//细线
    
    lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 30, 30)];
    lab1.text = @"从";
    lab1.textColor = [UIColor colorWithHexString:@"#333333"];
    lab1.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:lab1];
    
    
    self.startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(15+30, 12,kScreen_Width-15-(15+30), 30)];
    self.startTimeLab.text = @"2016-01-01";
    self.startTimeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.startTimeLab.font = [UIFont systemFontOfSize:16];
    
    self.startTimeLab.textAlignment = NSTextAlignmentCenter;
    self.startTimeLab.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"]CGColor];
    self.startTimeLab.layer.borderWidth = 0.5;
    self.startTimeLab.layer.cornerRadius = 5;
    self.startTimeLab.clipsToBounds = YES;
    [self addSubview:self.startTimeLab];
    
    
    lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 12+30+12, 30, 30)];
    lab2.text = @"至";
    lab2.textColor = [UIColor colorWithHexString:@"#333333"];
    lab2.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:lab2];
    
    self.endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(15+30, 12+30+12, kScreen_Width-15-(15+30), 30)];
    self.endTimeLab.text = @"2016-01-21";
    self.endTimeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.endTimeLab.font = [UIFont systemFontOfSize:16];
    
    self.endTimeLab.textAlignment = NSTextAlignmentCenter;
    self.endTimeLab.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"]CGColor];
    self.endTimeLab.layer.borderWidth = 0.5;
    self.endTimeLab.layer.cornerRadius = 5;
    self.endTimeLab.clipsToBounds = YES;
    [self addSubview:self.endTimeLab];
    
    
    
    
    viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 12+30+12+30+12, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    [self addSubview:viewline];
    
    
    self.certainBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainBt.frame = CGRectMake(0, 12+30+12+30+12+0.5, kScreen_Width, 44);
    
    [self.certainBt setTitle:@"确定" forState:UIControlStateNormal];
    self.certainBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.certainBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    self.certainBt.layer.cornerRadius = 5;
    self.certainBt.clipsToBounds = YES;
    
    [self addSubview:self.certainBt];
    
    self.lowView = [[UIView alloc] initWithFrame:CGRectMake(0, 12+30+12+30+12+0.5+44, kScreen_Width, kScreen_Height)];
    self.lowView.backgroundColor = [UIColor blackColor];
    self.lowView.alpha = 0.5;
    [self addSubview:self.lowView];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
