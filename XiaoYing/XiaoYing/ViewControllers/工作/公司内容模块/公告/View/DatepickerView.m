//
//  DatepickerView.m
//  XiaoYing
//
//  Created by 王思齐 on 16/11/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DatepickerView.h"

@implementation DatepickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, kScreen_Width, 15)];
    label1.text = @"设置时间";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor colorWithHexString:@"#333333"];
    label1.font = [UIFont systemFontOfSize:16];
    [view addSubview:label1];
    
    _dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom + 10, kScreen_Width, 11)];
    _dateLabel2.textAlignment = NSTextAlignmentCenter;
    _dateLabel2.font = [UIFont systemFontOfSize:14];
    _dateLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:_dateLabel2];
    
    //日期选择器
    _dataPicker = [[UIDatePicker alloc] init];
    
    //改变大小必须分开写
    _dataPicker.frame = CGRectMake(0, _dateLabel2.bottom, kScreen_Width, 150);
    //最大日期
    _dataPicker.maximumDate = [NSDate date];
   
    _dataPicker.datePickerMode = UIDatePickerModeDate;
    [_dataPicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_dataPicker];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2.0-250/2.0, _dataPicker.bottom, 250/2.0, 88/2.0)];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"left-button"] forState: UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"确认" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2.0 - 1, _dataPicker.bottom, 250/2.0, 88/2.0)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"right-button"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn setTitle:@"取消" forState:UIControlStateNormal];
    [confirmBtn addTarget:[self superview] action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [view addSubview:confirmBtn];
}

-(void)valueChange:(UIDatePicker *)datePicker
{
    
    _dateLabel2.text = [self Set_Time_Way];
}

-(NSString *)Set_Time_Way{
    //获取用户通过控制器设置的时间和日期
    NSDate *pickerDate=[_dataPicker date];
    NSDateFormatter *pickerFormatter=[[NSDateFormatter alloc]init];
    //创建日期显示格式
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转换为字符串的形式
    NSString *dateString=[pickerFormatter stringFromDate:pickerDate];
    return dateString;
}

- (void)deleteAction
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmAction
{
    NSDate *pickerDate=[_dataPicker date];
    NSDateFormatter *pickerFormatter=[[NSDateFormatter alloc]init];
    //创建日期显示格式
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转换为字符串的形式
    NSString *dateString=[pickerFormatter stringFromDate:pickerDate];
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            if (_dataBlock) {
                _dataBlock(dateString);
            }
        }];
    
}

//重写setter方法
- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    
    if ([dateStr isEqualToString:@""]) {
        _dataPicker.date = [NSDate date];
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dateLabel2.text = [dateFormatter stringFromDate:_dataPicker.date];
    } else {
        _dateLabel2.text = dateStr;
        
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //初始值
        NSDate *date = [dateFormatter dateFromString:dateStr];
        _dataPicker.date = date;
    }
}

-(void)setMinDateStr:(NSString *)minDateStr{
    _minDateStr = minDateStr;
    if (![minDateStr isEqualToString:@""]) {
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dataPicker.minimumDate = [dateFormatter dateFromString:_minDateStr];
    }
}


@end
