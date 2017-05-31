//
//  GetSecretNumVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "GetSecretNumVC.h"
#import "GeneralAlertView.h"
#import "MBProgressHUD.h"

@interface GetSecretNumVC ()
@property (nonatomic, strong)UIButton *againButton;
@property (nonatomic, strong)UIButton *sendeNumBt;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong) UIImageView *moveImage;//推出的图片
//@property (nonatomic, strong)UIImageView *wrongImage;
@property (nonatomic, strong)UILabel *label;


@end

@implementation GetSecretNumVC



- (void)viewDidLoad {
    [super viewDidLoad];

    [self sendeNumAction];
    
    [self initBasic];
    [self initUI];

}


- (void)initBasic {
    self.title = @"输入验证码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
}


- (void)initUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(makeSureAction)];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, kScreen_Width, 12)];
    _label.text = @"已向该公司创建者的注册邮箱发出验证邮件";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor colorWithHexString:@"#848484"];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _label.bottom, kScreen_Width, 12)];
    label1.text = @"请联系对方取得验证码完成操作";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor colorWithHexString:@"#848484"];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, label1.bottom + 12, kScreen_Width, 44)];
    view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view];

    _textField = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width - 12 - 100, 44)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.placeholder = @"输入验证码";
    [_textField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    [_textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:_textField];
    
    _sendeNumBt = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 100, 0, 100, 44)];
    _sendeNumBt.titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *strTime = [NSString stringWithFormat:@"重新发送验证码\n(15s)"];
    _sendeNumBt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_sendeNumBt setTitle:strTime forState:UIControlStateNormal];
    _sendeNumBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    _sendeNumBt.titleLabel.textColor = [UIColor whiteColor];
    _sendeNumBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_sendeNumBt addTarget:self action:@selector(sendeNumAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_sendeNumBt];
    
//    _wrongImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 55 - 100, (44 - 15) / 2, 48, 15)];
//    _wrongImage.hidden = YES;
//    _wrongImage.image = [UIImage imageNamed:@"wrong_word"];
//    [view addSubview:_wrongImage];
    
    _againButton = [[UIButton alloc]initWithFrame:CGRectMake(12, view.bottom + 15, kScreen_Width - 24, 44)];
    _againButton.layer.masksToBounds = YES;
    _againButton.layer.cornerRadius = 5;
    [_againButton setTitle:@"重新添加子公司" forState:UIControlStateNormal];
    _againButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _againButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _againButton.titleLabel.textColor = [UIColor whiteColor];
    _againButton.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_againButton addTarget:self action:@selector(addChildAgainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_againButton];

}



- (void)sendeNumAction {
     NSLog(@"发送验证码");
    _label.text = @"已向对方邮箱发出验证邮件";
    [self PostCodeToCompanyAction];
    [self countDownOnButtonAction];
}

- (void)PostCodeToCompanyAction {
    NSString *strURL = [PostCodeToCompanyURl stringByAppendingFormat:@"&ComapnyCode=%@",_textField.text];
    [AFNetClient POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@1]) {
            
        }
        NSLog(@"_______________________%@", JSONDict);
    } failed:^(NSError *error) {
        NSLog(@"_______________________%@", error);
    }];
    
}


- (void)addChildAgainAction {
     NSLog(@"重新添加子公司");
    GeneralAlertView *alerView = [[GeneralAlertView alloc] init];
    [self.view addSubview:alerView];
    
}


- (void)makeSureAction {
     NSLog(@"确定");
    if ([_textField.text isEqualToString:@""]) {
        
       [self imageAnimalAction];
       [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(backAction) userInfo:nil repeats:nil];
        
    }else{
        
        [self ApplyforJoinCompanyAction];
    }
}
           
//确认添加子公司
- (void)ApplyforJoinCompanyAction {
    
     NSLog(@"----------------------------%@++%@",_tempStr, _textField.text);
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setValue:_tempStr forKey:@"childComapnyId"];
    [paramDic setValue:_textField.text forKey:@"verificationCode"];
    [AFNetClient POST_Path:ApplyforJoinCompanyURl params:paramDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[3] animated:YES];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
//             _wrongImage.hidden = NO;
        }
         NSLog(@"-----确认验证--%@",JSONDict);
    } failed:^(NSError *error) {
       
    }];

}

- (void) textFieldDidChange {
//    _wrongImage.hidden = YES;
}

#pragma mark --countDownOnButtonAction--
- (void)countDownOnButtonAction {
    __block int timeout = 15; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0 ){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时完成时的设置
               [_sendeNumBt setTitle:@"发送验证码" forState:UIControlStateNormal];
                _sendeNumBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
                _sendeNumBt.userInteractionEnabled = YES;
            });
        }else{
            //倒计时进行时的设置
            NSString *strTime = [NSString stringWithFormat:@"重新发送验证码\n(%ds)",timeout];
            _sendeNumBt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendeNumBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                _sendeNumBt.userInteractionEnabled = NO;
                [_sendeNumBt setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}



//转移成功之后显示的图片
- (void)imageAnimalAction {
    _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noverification"]];
    [_moveImage setFrame:CGRectMake((kScreen_Width - 190) / 2, (kScreen_Height - 90) / 2 - 100, 190, 90)];
    [self.view addSubview:_moveImage];
    [_moveImage setHidden:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:1.0];
    [UIView commitAnimations];
    
    [_moveImage setHidden:NO];
}




- (void) backAction {
    [_moveImage setHidden:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
