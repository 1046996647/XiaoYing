//
//  BirthdayController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/18.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "BirthdayController.h"
#import "ZWLDatePickerView.h"


@interface BirthdayController ()

@property (nonatomic,strong) ZWLDatePickerView *datepickerView;


@end

@implementation BirthdayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    //日期选择视图
//    _datepickerView = [[ZWLDatePickerView alloc]initWithFrame:CGRectMake(0,kScreen_Height, kScreen_Width, 270)];
//    _datepickerView.type = 1;
//    //            datepickerView.delegate = self;
//    //崩溃原因：日期格式问题
//    _datepickerView.dateStr = self.dateStr;
//    [self.view addSubview:_datepickerView];
//
//    //延迟1秒执行这个方法
//    [self performSelector:@selector(delayAction) withObject:nil afterDelay:.1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)delayAction
//{
//    [UIView animateWithDuration:.5 animations:^{
//        _datepickerView.top = kScreen_Height - 270;
//    }];
//}

@end
