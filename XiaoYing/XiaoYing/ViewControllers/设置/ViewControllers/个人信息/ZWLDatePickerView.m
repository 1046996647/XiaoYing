//
//  detePickerView.m
//  XiaoYing
//
//  Created by 林颖 on 15/11/30.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ZWLDatePickerView.h"

@interface ZWLDatePickerView ()
{
    MBProgressHUD *_hud;

}

@end


@implementation ZWLDatePickerView


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
    
    dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom + 10, kScreen_Width, 11)];
    dateLabel2.textAlignment = NSTextAlignmentCenter;
    dateLabel2.font = [UIFont systemFontOfSize:14];
    dateLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:dateLabel2];
    
    //日期选择器
    dataPicker = [[UIDatePicker alloc] init];
    
    //改变大小必须分开写
    dataPicker.frame = CGRectMake(0, dateLabel2.bottom, kScreen_Width, 150);
    //最大日期
    dataPicker.maximumDate = [NSDate date];
    dataPicker.datePickerMode = UIDatePickerModeDate;
    [dataPicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:dataPicker];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2.0-250/2.0, dataPicker.bottom, 250/2.0, 88/2.0)];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"left-button"] forState: UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"确认" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2.0 - 1, dataPicker.bottom, 250/2.0, 88/2.0)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"right-button"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn setTitle:@"取消" forState:UIControlStateNormal];
    [confirmBtn addTarget:[self superview] action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [view addSubview:confirmBtn];
}

-(void)valueChange:(UIDatePicker *)datePicker
{
    
     dateLabel2.text = [self Set_Time_Way];
}

-(NSString *)Set_Time_Way{
    //获取用户通过控制器设置的时间和日期
    NSDate *pickerDate=[dataPicker date];
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
    NSDate *pickerDate=[dataPicker date];
    NSDateFormatter *pickerFormatter=[[NSDateFormatter alloc]init];
    //创建日期显示格式
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转换为字符串的形式
    NSString *dateString=[pickerFormatter stringFromDate:pickerDate];
    
    if (self.type == 1) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        _hud.labelText = @"正在加载...";

        //修改生日
        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
        [paramDic  setValue:dateString forKey:@"birthday"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:Profile parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self getMyMessage];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else {
        
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            if (_dataBlock) {
                _dataBlock(dateString);
            }
        }];
    }

    
    
}

//重写setter方法
- (void)setDateStr:(NSString *)dateStr
{
    if (_dateStr != dateStr) {
        _dateStr = dateStr;
    }
    
    if ([self.dateStr isEqualToString:@""]) {
        dataPicker.date = [NSDate date];
    } else {
        dateLabel2.text = _dateStr;
        
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //初始值
        NSDate *date = [dateFormatter dateFromString:_dateStr];

        dataPicker.date = date;
    }
    
}

/**
 *  获取个人信息
 */
-(void)getMyMessage{
    
    
    [AFNetClient GET_Path:ProfileMy completed:^(NSData *stringData, id JSONDict) {
        
        [_hud hide:YES];
        
        ProfileMyModel * model1 = [FirstModel GetProfileMyModel:[JSONDict objectForKey:@"Data"]];
        //获取存储沙盒路径
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentPath = [documentPath stringByAppendingPathComponent:@"PersonCentre.plist"];
        //用归档存储数据在plist文件中
        NSLog(@"个人中心存储在PersonCentre.plist文件中%@",documentPath);
        
        [NSKeyedArchiver archiveRootObject:model1 toFile:documentPath];
        
        //发送生日修改通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"birthdayChangeNotification" object:nil];
        
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

@end
