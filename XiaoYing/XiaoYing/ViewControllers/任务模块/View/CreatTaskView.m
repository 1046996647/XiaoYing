//
//  CreatTaskView.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "CreatTaskView.h"
#import "AFNetClient.h"
#import "AFNetworking.h"
//存储数据库数据的数据模型
#import "taskDatabase.h"
#import "taskModel.h"
#import "detePickerView.h"

#import "StringChangeDate.h"
#define frame_Height  self.frame.size.height
#define frame_width  self.frame.size.width

@interface CreatTaskView()<UITextFieldDelegate,UITextViewDelegate>
{
    
    UITextField *titleField_;//标题文本框
    UIButton *dateBt_;//日期选择键
    UITextView *remarkView_;//文本
    UILabel *placehold_;
   
   //时间设置
    UIDatePicker *dataPicker;
    NSString *dateString;
    
    //当前时间
    NSString *locationString;
    
    //数据库数据模型
    taskModel *modelSQL;
    
    //设定缓冲区将数据保存在缓冲区中
    NSMutableData *data_;
  
    UIView *view;
     UIControl *_coverView;//阴影笼罩视图
    UILabel *dateLabel1;
    UILabel *dateLabel2;
    UIView *navbarBack;//导航栏阴影笼罩视图
    CGRect rect3;
    CGRect rect5;
    detePickerView *datepickerView;

}
@end

@implementation CreatTaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        data_=[[NSMutableData alloc]init];
        
        [self initUI];
        [self createPickrerView];
       
        //点击空白处，取消键盘
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
        [self addGestureRecognizer:tap];
        
        //初始化数据模型
        [self initSQL];
    }
    return self;
}

-(void)initUI{
//    
   UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.contentSize = CGSizeMake(kScreen_Width, kScreen_Height+40);
    
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:backView];

    //输入标题文本框
    titleField_=[[UITextField alloc]initWithFrame:CGRectMake(27,16.5,frame_width-50, 30)];
    titleField_.placeholder=@"请输入标题";
    titleField_.delegate=self;
    titleField_.font=[UIFont systemFontOfSize:16];
    [backView addSubview:titleField_];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 50, kScreen_Width-30, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [backView addSubview:lineView1];
   
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 90, kScreen_Width-30, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [backView addSubview:lineView2];
    
   //设置时间按钮
    dateBt_ = [[UIButton alloc] initWithFrame:CGRectMake(20, 57, kScreen_Width-30, 30)];
    [dateBt_ addTarget:self action:@selector(SEtTime:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:dateBt_];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, 30)];
    label1.text = @"设置时间";
    label1.textColor = [UIColor colorWithHexString:@"#333333"];
    label1.font = [UIFont systemFontOfSize:16];
    [dateBt_ addSubview:label1];
    
    
    NSDate *  senddate=[NSDate date];
    
    locationString=[StringChangeDate DateChangeStringWay:senddate];
    
    dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-190, 0, 190, 30)];
    dateLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    dateLabel1.text = [taskModel cutTimeString:locationString];
    dateLabel1.font = [UIFont systemFontOfSize:14];
  
    [dateBt_ addSubview:dateLabel1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-new"]];
    imageView.frame = CGRectMake(140, 8, 7, 13);
    [dateLabel1 addSubview:imageView];
    
    //正文
    remarkView_=[[UITextView alloc]initWithFrame:CGRectMake(15, 40+38+40, frame_width-30, 250)];
    remarkView_.font = [UIFont systemFontOfSize:14];
    remarkView_.layer.borderColor = [UIColor colorWithHexString:@"#dfdfdf"].CGColor;
    remarkView_.delegate = self;
    remarkView_.layer.borderWidth = 0.5;
    remarkView_.layer.cornerRadius=3;
    [backView addSubview:remarkView_];
   
    placehold_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    placehold_.text = @"请输入内容";
    placehold_.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    placehold_.font = [UIFont systemFontOfSize:16];
    [remarkView_ addSubview:placehold_];
    
    if (IS_IPHONE_4) {
        [self addSubview:scrollView];
        [scrollView addSubview:backView];
    }else{
        [self addSubview:backView];
    }
    
    //导航栏阴影笼罩视图
    navbarBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    navbarBack.backgroundColor=[UIColor blackColor];
    navbarBack.alpha=0;
    navbarBack.hidden=YES;
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [[appDelegate window] addSubview:navbarBack];
    
    //整个视图的阴影笼罩视图
    _coverView = [[UIControl alloc]initWithFrame:self.bounds];
    _coverView.alpha = 0;
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.hidden = YES;
    [self addSubview:_coverView];
  
}

- (void)createPickrerView{
    if (IS_IPHONE_4) {
        rect3 = CGRectMake(0, 100, kScreen_Width, kScreen_Height-100);
        rect5 = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-100);
    }else if (IS_iPhone6Plus){
        rect3 = CGRectMake(0, 200, kScreen_Width, kScreen_Height-200);
        rect5 = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-200);
    }else{
        rect3 = CGRectMake(0, 180, kScreen_Width, kScreen_Height-180);
        rect5 = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-180);
    }
    datepickerView = [[detePickerView alloc]initWithFrame:rect5];
    [self addSubview:datepickerView];
}
//设置时间
-(void)SEtTime:(UIButton *)btn{
    [remarkView_ resignFirstResponder];
    [titleField_ resignFirstResponder];
    _coverView.hidden = NO;
    navbarBack.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        datepickerView.frame = rect3;
        _coverView.alpha = 0.4;
        navbarBack.alpha = 0.4;
    }];
}

//监听时间的变化
-(void)xuanze:(id)sender{
    dateLabel2.text = [self Set_Time_Way];
}

-(NSString *)Set_Time_Way{
    //获取用户通过控制器设置的时间和日期
    NSDate *pickerDate=[dataPicker date];
    //将日期转换为字符串的形式
    dateString = [StringChangeDate DateChangeStringWay:pickerDate];
    
    dateLabel2.text = dateString;
    
    
    return dateString;
}

//点击空白处，取消键盘
-(void)gesture:(UITapGestureRecognizer*)tap
{
    [remarkView_ resignFirstResponder];
    [titleField_ resignFirstResponder];
    remarkView_.hidden=NO;
    [self deleteAction];
}

- (void)deleteAction{

    [UIView animateWithDuration:0.5 animations:^{
        datepickerView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-200);
        _coverView.alpha = 0;
        navbarBack.alpha = 0;
        
    }completion:^(BOOL finished) {
        _coverView.hidden = YES;
        navbarBack.hidden = YES;
    }];
}

- (void)confirmAction:(UIButton *)btn{
    
    [UIView animateWithDuration:0.5 animations:^{
        datepickerView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-200);
        _coverView.alpha = 0;
        navbarBack.alpha = 0;
    } completion:^(BOOL finished) {
        _coverView.hidden = YES;
        navbarBack.hidden = YES;
        dateLabel1.text = [datepickerView Set_Time_Way];
        
        dateString = dateLabel1.text;
    
    }];
}

#pragma mark ----UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        placehold_.hidden = NO;
    }else{
        placehold_.hidden = YES;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    placehold_.hidden = YES;
    if (IS_IPHONE_4 || IS_IPHONE_5 ) {
        remarkView_.frame = CGRectMake(15, 40+38+40, frame_width-30, 130);
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    if (IS_IPHONE_4 || IS_IPHONE_5 ) {
        remarkView_.frame = CGRectMake(15, 40+38+40, frame_width-30, 250);
    }
}

#pragma mark ----UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark------添加任务
-(void)initSQL{
    modelSQL=[[taskModel alloc]init];;
}

-(void)postTask{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *flag = [user objectForKey:@"YESORNOTLOGIN"];
    
    if ([titleField_.text isEqualToString:@""]) {
       
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"标题不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
        return ;
    }
    
    if ([flag isEqualToString:@"0"]) {
        modelSQL.TaskUpAndDown=0;//0代表任务没有上传到服务器
        modelSQL.TaskRemark=remarkView_.text;//任务详情
        modelSQL.TaskTitle=titleField_.text;//任务标题
        //任务提醒时间
        if (dateString==nil) {
            modelSQL.TaskTime=locationString;
        }else{
            modelSQL.TaskTime=dateString;
        }
        //仅仅执行一次的方法
        
        //创建一个本地通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatLocalNotification" object:modelSQL];
        
        modelSQL.TaskFlag=1;//任务的重要程度
        
        //在非登录状态下的任务ID
        
        NSInteger overALLTaskId = [UserInfo getOverALLTaskId];
        overALLTaskId--;
        modelSQL.TaskId=overALLTaskId;//任务编号
        [UserInfo saveOverALLTaskId:overALLTaskId];
        modelSQL.TaskAddTime=locationString;//任务添加时间
        modelSQL.TaskExpiresTime=@"";//任务消亡时间
        modelSQL.TaskState=1;//任务状态
        if (![modelSQL.TaskTime isEqual:[NSNull null]]) {
            NSArray *arrSepreate=[modelSQL.TaskTime componentsSeparatedByString:@" "];
            //任务添加日期
            modelSQL.TaskDay=arrSepreate[0];
        }
        BOOL sucess=[taskDatabase insertModal:modelSQL];
        if (sucess==YES) {
            NSLog(@"数据库插入成功");
        }else{
            NSLog(@"数据库插入失败");
        }
    }else{
        
        if (dateString == nil) {
            dateString = locationString;
        }
        NSNumber *num=[NSNumber numberWithInt:1];
        NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
        [paramDic  setValue:titleField_.text forKey:@"title"];
        [paramDic  setValue:remarkView_.text forKey:@"remark"];
        [paramDic  setValue:num forKey:@"flag"];
        [paramDic  setValue:dateString forKey:@"time"];
        // 上传任务
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AFNetClient  POST_Path:AddTask params:paramDic completed:^(NSData *stringData, id JSONDict) {
                NSLog(@"添加任务JSONDict=%@",JSONDict);
                modelSQL.TaskRemark=[[JSONDict objectForKey:@"Data"] objectForKey:@"Remark"];
                modelSQL.TaskTitle=[[JSONDict objectForKey:@"Data"] objectForKey:@"Title"];
                modelSQL.TaskTime=[[JSONDict objectForKey:@"Data"] objectForKey:@"Time"];
                modelSQL.TaskFlag=[[[JSONDict objectForKey:@"Data"] objectForKey:@"Flag"]integerValue];
                modelSQL.TaskId=[[[JSONDict objectForKey:@"Data"] objectForKey:@"Id"]integerValue];
                modelSQL.TaskAddTime=[[JSONDict objectForKey:@"Data"] objectForKey:@"AddTime"];
                modelSQL.TaskExpiresTime=[[JSONDict objectForKey:@"Data"] objectForKey:@"ExpiresTime"];
                modelSQL.TaskState=[[[JSONDict objectForKey:@"Data"] objectForKey:@"Status"]integerValue];
                modelSQL.TaskUpAndDown=1;
                if (![modelSQL.TaskTime isEqual:[NSNull null]]) {
                    NSArray *arrSepreate=[modelSQL.TaskTime componentsSeparatedByString:@" "];
                    modelSQL.TaskDay=arrSepreate[0];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatLocalNotification" object:modelSQL];
                BOOL sucess=[taskDatabase insertModal:modelSQL];
                if (sucess==YES) {
                    NSLog(@"数据插入数据库成功");
                }else{
                    NSLog(@"数据插入数据库失败");
                }
            } failed:^(NSError *error) {
                NSLog(@"请求失败Error--%ld",(long)error.code);
            }];
        });
    }
    return ;
}
@end
