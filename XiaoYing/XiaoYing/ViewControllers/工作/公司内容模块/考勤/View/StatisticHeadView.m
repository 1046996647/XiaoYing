//
//  StatisticHeadView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "StatisticHeadView.h"

@interface StatisticHeadView()
{
}
@property (nonatomic,strong)UILabel *startTimeLab;//开始时间
@property (nonatomic,strong)UILabel *endTimeLab;//至什么时间
@property (nonatomic,strong)UIButton *certainBt;//确定按钮
@property (nonatomic,strong)UIView *lowView;//下面的阴影
@property (nonatomic,strong)UIDatePicker *dataPicker;

@end

@implementation StatisticHeadView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lab1;//从
        UILabel *lab2;//至
        UIButton *allSignBt;//全签
        UIButton *eailySignBt;//早签
        UIButton *leakSignBt;//漏签
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

        allSignBt = [UIButton buttonWithType:UIButtonTypeCustom];
        allSignBt.frame = CGRectMake(50, 12+30+12+30+12, 50, 30);

        [allSignBt setTitle:@"已签" forState:UIControlStateNormal];
        [allSignBt setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
        allSignBt.layer.cornerRadius = 5;
        allSignBt.titleLabel.font = [UIFont systemFontOfSize:14];
        allSignBt.clipsToBounds = YES;
        allSignBt.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [self addSubview:allSignBt];
        
        eailySignBt = [UIButton buttonWithType:UIButtonTypeCustom];
        eailySignBt.frame = CGRectMake(kScreen_Width/2-25, 12+30+12+30+12, 50, 30);
     
        [eailySignBt setTitle:@"早签" forState:UIControlStateNormal];
        [eailySignBt setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
        eailySignBt.layer.cornerRadius = 5;
        eailySignBt.titleLabel.font = [UIFont systemFontOfSize:14];
        eailySignBt.clipsToBounds = YES;
        eailySignBt.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [self addSubview:eailySignBt];
        
        
        leakSignBt = [UIButton buttonWithType:UIButtonTypeCustom];
        leakSignBt.frame = CGRectMake(kScreen_Width-100, 12+30+12+30+12, 50, 30);

        [leakSignBt setTitle:@"漏签" forState:UIControlStateNormal];
        [leakSignBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leakSignBt.layer.cornerRadius = 5;
        leakSignBt.titleLabel.font = [UIFont systemFontOfSize:14];
        leakSignBt.clipsToBounds = YES;
        leakSignBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
        [self addSubview:leakSignBt];
        
        viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 12+30+12+30+12+30+15, kScreen_Width, 0.5)];
        viewline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        
        [self addSubview:viewline];
        
        
        self.certainBt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.certainBt.frame = CGRectMake(0, 12+30+12+30+12+30+15+0.5, kScreen_Width, 44);
       
        [self.certainBt setTitle:@"确定" forState:UIControlStateNormal];
        self.certainBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.certainBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        self.certainBt.layer.cornerRadius = 5;
        self.certainBt.clipsToBounds = YES;
 
        [self addSubview:self.certainBt];
        
        self.lowView = [[UIView alloc] initWithFrame:CGRectMake(0, 12+30+12+30+12+30+15+0.5+44, kScreen_Width, kScreen_Height)];
        self.lowView.backgroundColor = [UIColor blackColor];
        self.lowView.alpha = 0.5;
        [self addSubview:self.lowView];
        
        
//        self.dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.frame.size.height-150, kScreen_Width, 100)];
//        self.dataPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
//        self.dataPicker.locale=locale;
//        [self.dataPicker setCalendar:[NSCalendar currentCalendar]];
//        self.dataPicker.datePickerMode = UIDatePickerModeDate;
//        [self.dataPicker addTarget:self action:@selector(xuanze:) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:self.dataPicker];

        
    }
    return self;
}
- (void)xuanze:(UIDatePicker *)pic{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
