//
//  detePickerView.m
//  XiaoYing
//
//  Created by ZWL on 15/11/30.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "detePickerView.h"


@implementation detePickerView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    if (IS_IPHONE_4) {
        rect1 = CGRectMake((kScreen_Width-250)/2, 70+150+30, 125, 44);
        rect2 = CGRectMake((kScreen_Width-250)/2+125, 70+150+30, 125, 44);
                rect4 = CGRectMake(0, 70, kScreen_Width, 150);
    }else if (IS_iPhone6Plus){
        rect1 = CGRectMake((kScreen_Width-250)/2, 100+150+130, 125, 44);
        rect2 = CGRectMake((kScreen_Width-250)/2+125, 100+150+130, 125,44);
        rect4 = CGRectMake(0, 100, kScreen_Width, 200);
    }else{
        rect1 = CGRectMake((kScreen_Width-250)/2, 70+150+30, 125, 44);
        rect2 = CGRectMake((kScreen_Width-250)/2+125, 70+150+30, 125, 44);
        rect4 = CGRectMake(0, 70, kScreen_Width, 150);
    }
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    dataPicker = [[UIDatePicker alloc] initWithFrame:rect4];
    dataPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    dataPicker.locale=locale;
    [dataPicker setCalendar:[NSCalendar currentCalendar]];
    [dataPicker addTarget:self action:@selector(xuanze:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:dataPicker];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-63)/2, 16, kScreen_Width, 15)];
    label1.text = @"设置时间";
    label1.textColor = [UIColor colorWithHexString:@"#333333"];
    label1.font = [UIFont systemFontOfSize:18];
    [view addSubview:label1];
    
    dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-115)/2, 45, kScreen_Width, 11)];
    dateLabel2.text = [self Set_Time_Way];
    dateLabel2.font = [UIFont systemFontOfSize:14];
    dateLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:dateLabel2];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:rect1];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"left-button"] forState: UIControlStateNormal];
    [deleteBtn setTitle:@"取消" forState:UIControlStateNormal];
    deleteBtn.tag=11;
//    [deleteBtn addTarget:[self superview] action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [view addSubview:deleteBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:rect2];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"right-button"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [confirmBtn addTarget:[self superview] action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [view addSubview:confirmBtn];
}

-(void)xuanze:(UIButton *)btn{
    
     dateLabel2.text = [self Set_Time_Way];
}

-(NSString *)Set_Time_Way{
    //获取用户通过控制器设置的时间和日期
    NSDate *pickerDate=[dataPicker date];
    NSDateFormatter *pickerFormatter=[[NSDateFormatter alloc]init];
    //创建日期显示格式
    [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将日期转换为字符串的形式
    NSString *dateString=[pickerFormatter stringFromDate:pickerDate];

    
    return dateString;
}

@end
