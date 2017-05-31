//
//  EditorView.m
//  XiaoYing
//
//  Created by ZWL on 15/11/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "EditorView.h"
#import "taskModel.h"
#import "detePickerView.h"

@interface EditorView(){
    UIDatePicker *datePicker;//时间选择器
    
    CGRect rect1;
    CGRect rect2;
    CGRect rect3;
    CGRect rect5;
    UILabel *tasklabel;//任务标题
    UIButton *dateBt_;//设置时间按钮
    
    
    UILabel *dateLabel2;//弹窗上的时间按钮
    UIView *navbarBack;//导航栏阴影
    UIControl *_coverView;//阴影笼罩视图
    NSInteger clerk;
    
    UILabel *stateLabel;
    detePickerView *datePickerView;
}
@end
@implementation EditorView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self createPickerView];
        //添加单击空白处键盘退回手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setTaskmodel:(taskModel *)taskmodel{
    _taskmodel = taskmodel;
    
    self.remarkView.text = _taskmodel.TaskRemark;
    tasklabel.text = _taskmodel.TaskTitle;
     _dateLabel1.text =[taskModel cutTimeString:_taskmodel.TaskTime] ;
    
    if (_taskmodel.TaskFlag == 1) {
        _button1.hidden = NO;
    }else if(_taskmodel.TaskFlag == 2){
        _button2.hidden = NO;
    }else if(_taskmodel.TaskFlag == 3){
        _button3.hidden = NO;
    }
    
    if (_taskmodel.TaskState == 1) {
        _switch1.on = YES;
    }else if (_taskmodel.TaskState == 99){
        _switch1.on = NO;
    }
    
    [self setNeedsLayout];
}

-(void)initUI{
    clerk = 0;
    self.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.contentSize = CGSizeMake(kScreen_Width, kScreen_Height+100) ;
    
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];

    //任务标题
    tasklabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 16.5, kScreen_Width-50, 30)];
    tasklabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:tasklabel];
    
    //标题后面的红绿灯按钮
    _button1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-44.5, 15, 35, 35)];
    [_button1 setImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    _button1.hidden = YES;
    [backView addSubview:_button1];
    
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-44.5, 15, 35, 35)];
    [_button2 setImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    _button2.hidden = YES;
    [backView addSubview:_button2];
    
    _button3 = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-44.5, 15, 35, 35)];
    [_button3 setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [_button3 addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
    _button3.hidden = YES;
    [backView addSubview:_button3];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 50, kScreen_Width-30, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [backView addSubview:lineView1];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 90, kScreen_Width-30, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [backView addSubview:lineView2];
    
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(15, 130, kScreen_Width-30, 0.5)];
    lineView3.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [backView addSubview:lineView3];
    
    //设置时间按钮  点击按钮，弹出设置时间视图
    dateBt_ = [[UIButton alloc] initWithFrame:CGRectMake(20, 57, kScreen_Width-30, 30)];
    [dateBt_ addTarget:self action:@selector(SEtTime) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:dateBt_];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, 30)];
    label1.text = @"设置时间";
    label1.textColor = [UIColor colorWithHexString:@"#333333"];
    label1.font = [UIFont systemFontOfSize:16];
    [dateBt_ addSubview:label1];
    
    //时间Label
    _dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-190, 0, 190, 30)];
    _dateLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    _dateLabel1.font = [UIFont systemFontOfSize:14];
    [dateBt_ addSubview:_dateLabel1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-new"]];
    imageView.frame = CGRectMake(140, 8, 7, 13);
    [_dateLabel1 addSubview:imageView];
    
    
    stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 97, 130, 30)];
    stateLabel.text = @"该任务已完成";
    
    [backView addSubview:stateLabel];
    
    _switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(kScreen_Width-70, 95, 50, 30)];
    [_switch1 addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    [backView addSubview:_switch1];
   
    //正文
    _remarkView=[[UITextView alloc]initWithFrame:CGRectMake(15, 40+38+70, kScreen_Width-30, 250)];
    _remarkView.delegate = self;
    
    _remarkView.font = [UIFont systemFontOfSize:14];
    _remarkView.layer.borderColor = [UIColor colorWithHexString:@"#dfdfdf"].CGColor;
    _remarkView.layer.borderWidth = 0.5;
    _remarkView.layer.cornerRadius=3;
    [backView addSubview:_remarkView];
    
    
    if (IS_IPHONE_4) {
        [self addSubview:scrollView];
        [scrollView addSubview:backView];
    }else{
        [self addSubview:backView];
    }
    
    
    //导航栏阴影视图
    navbarBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    navbarBack.backgroundColor=[UIColor blackColor];
    navbarBack.alpha=0;
    navbarBack.hidden=YES;
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [[appDelegate window] addSubview:navbarBack];
    
    //整个视图的阴影覆盖视图
    _coverView = [[UIControl alloc]initWithFrame:self.bounds];
    _coverView.alpha = 0;
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.hidden = YES;
    [self addSubview:_coverView];
    
}

//弹出的设置时间视图
-(void)createPickerView{
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
    
    datePickerView = [[detePickerView alloc]initWithFrame:rect5];
    [self addSubview:datePickerView];

}

//点击空白处，取消键盘
-(void)gesture:(UITapGestureRecognizer*)tap
{
    [_remarkView resignFirstResponder];
    [self deleteAction];
}

-(void)switchAction{
    if (_switch1.on == YES) {
        stateLabel.textColor = [UIColor blackColor];
        self.taskmodel.TaskState=1;
         
    }else if (_switch1.on == NO){
       stateLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        self.taskmodel.TaskState=99;
    }
}

-(void)SEtTime{
    [_remarkView resignFirstResponder];
    _coverView.hidden = NO;
    navbarBack.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        datePickerView.frame = rect3;
        _coverView.alpha = 0.4;
        navbarBack.alpha = 0.4;
        
    }];
}


-(void)deleteAction{
    [UIView animateWithDuration:0.5 animations:^{
        datePickerView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-200);
        _coverView.alpha = 0;
        navbarBack.alpha = 0;
        
    }completion:^(BOOL finished) {
        _coverView.hidden = YES;
        navbarBack.hidden = YES;
    }];
}
-(void)confirmAction:(UIButton *)btn{
    [UIView animateWithDuration:0.5 animations:^{
        datePickerView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height-200);
        _coverView.alpha = 0;
        navbarBack.alpha = 0;
    } completion:^(BOOL finished) {
        _coverView.hidden = YES;
        navbarBack.hidden = YES;
        _dateLabel1.text = [datePickerView Set_Time_Way];
    }];
}
-(NSString *)Set_Time_Way{
    //获取用户通过控制器设置的时间和日期
    NSDate *pickerDate=[datePicker date];
    NSDateFormatter *pickerFormatter=[[NSDateFormatter alloc]init];
    //创建日期显示格式
    [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //将日期转换为字符串的形式
   NSString *dateString=[pickerFormatter stringFromDate:pickerDate];

    return dateString;
}

-(void)btn1Action:(UIButton *)btn{
    CGRect rect = CGRectMake(kScreen_Width-44.5, 15, 35, 35);
    
    if (clerk == 0) {
        _button2.hidden = NO;
        _button3.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            _button1.frame = CGRectMake(kScreen_Width-44.5, 15, 35, 35);
            _button2.frame = CGRectMake(kScreen_Width-79.5, 15, 35, 35);
            _button3.frame = CGRectMake(kScreen_Width-114.5, 15, 35, 35);
        }];
    }else if (clerk == 1){
        [UIView animateWithDuration:0.2 animations:^{
            _button1.frame = rect;
            _button2.frame = rect;
            _button3.frame = rect;
            
        } completion:^(BOOL finished) {
            _button2.hidden = YES;
            _button3.hidden = YES;
        }];
    }
    clerk =! clerk;
}

-(void)btn2Action:(UIButton *)btn{
    CGRect rect = CGRectMake(kScreen_Width-44.5, 15, 35, 35);
    if (clerk == 0) {
        _button1.hidden = NO;
        _button3.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            _button2.frame = CGRectMake(kScreen_Width-44.5, 15, 35, 35);
            _button1.frame = CGRectMake(kScreen_Width-79.5, 15, 35, 35);
            _button3.frame = CGRectMake(kScreen_Width-114.5, 15, 35, 35);
        }];
    }else if (clerk == 1){
        [UIView animateWithDuration:0.2 animations:^{
            _button2.frame = rect;
            _button1.frame = rect;
            _button3.frame = rect;
            
        } completion:^(BOOL finished) {
            _button1.hidden = YES;
            _button3.hidden = YES;
        }];
    }
    clerk =! clerk;
}

-(void)btn3Action:(UIButton *)btn{
    CGRect rect = CGRectMake(kScreen_Width-44.5, 15, 35, 35);
    if (clerk == 0) {
        _button1.hidden = NO;
        _button2.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            _button3.frame = CGRectMake(kScreen_Width-44.5, 15, 35, 35);
            _button1.frame = CGRectMake(kScreen_Width-79.5, 15, 35, 35);
            _button2.frame = CGRectMake(kScreen_Width-114.5, 15, 35, 35);
        }];
    }else if (clerk == 1){
        [UIView animateWithDuration:0.2 animations:^{
            _button3.frame = rect;
            _button1.frame = rect;
            _button2.frame = rect;
            
        } completion:^(BOOL finished) {
            _button1.hidden = YES;
            _button2.hidden = YES;
        }];
    }
    clerk =! clerk;
}

#pragma mark ----UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (IS_IPHONE_4 || IS_IPHONE_5 ) {
        _remarkView.frame = CGRectMake(15, 40+38+40+30, kScreen_Width-30, 100);
    }else if (IS_iPhone6){
        _remarkView.frame = CGRectMake(15, 40+38+40+30, kScreen_Width-30, 190);
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (IS_IPHONE_4 || IS_IPHONE_5 || IS_iPhone6 ) {
        _remarkView.frame = CGRectMake(15, 40+38+40+30, kScreen_Width-30, 250);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
