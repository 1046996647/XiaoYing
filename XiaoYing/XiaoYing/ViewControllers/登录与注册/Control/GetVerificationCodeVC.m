//
//  RegisterViewController1.m
//  XiaoYing
//
//  Created by ZWL on 16/8/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "GetVerificationCodeVC.h"
#import "RegisterViewController.h"
#import "FindPasswordVC.h"
#import "CountDownServer.h"


#define kCountDownForVerifyCode @"CountDownForVerifyCode"


@interface GetVerificationCodeVC ()<UITextFieldDelegate>
{
    //电子邮箱
    UITextField *MailField;
    
    //验证码
    UITextField *RegNumField;

    
    //获取验证码
    UIButton *loginBt;
    
    // 确定
    UIButton *sendBtn;

    //获取验证码返回的一个值
    NSString *queueidStr;

}

@end

@implementation GetVerificationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width, 88.5)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    
    UILabel *mailLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 44)];
    mailLab.text = @"邮箱";
//    mailLab.textAlignment = NSTextAlignmentRight;
    mailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    mailLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:mailLab];
    
    
    MailField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreen_Width-85-12, 44)];
    MailField.placeholder=@"请输入邮箱";
    //    MailField.delegate=self;
    MailField.font=[UIFont systemFontOfSize:16];
    MailField.textColor=[UIColor colorWithHexString:@"#333333"];
    MailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    MailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [MailField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:MailField];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, MailField.bottom, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline];
    
    
    UILabel *verificateLab = [[UILabel alloc] initWithFrame:CGRectMake(12, viewline.bottom, 80, 44)];
    verificateLab.text = @"验证码";
//    verificateLab.textAlignment = NSTextAlignmentRight;
    verificateLab.textColor = [UIColor colorWithHexString:@"#848484"];
    verificateLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:verificateLab];
    
    RegNumField = [[UITextField alloc] initWithFrame:CGRectMake(85, viewline.bottom, kScreen_Width-85-12-100, 44)];
    RegNumField.placeholder=@"请输入验证码";
    RegNumField.delegate=self;
    RegNumField.textColor=[UIColor colorWithHexString:@"333333"];
    RegNumField.font=[UIFont systemFontOfSize:16];
    RegNumField.keyboardType = UIKeyboardTypeNumberPad;
    [RegNumField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:RegNumField];
    
    //发送验证码按钮
    loginBt=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBt.frame = CGRectMake(kScreen_Width-100, RegNumField.top, 100, 44);
    loginBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginBt.titleLabel.lineBreakMode = 0 ;
    loginBt.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
    loginBt.userInteractionEnabled = NO;
    //    loginBt.backgroundColor=[UIColor colorWithHexString:@"f99740"];
    [loginBt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [loginBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginBt addTarget:self action:@selector(GetRegistNum:) forControlEvents:UIControlEventTouchUpInside];
    loginBt.tag = 100;
    [baseView addSubview:loginBt];
    
    //发送验证码按钮
    sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.layer.cornerRadius=5;
    sendBtn.tag=101;
    sendBtn.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    sendBtn.userInteractionEnabled = NO;
    //    sendBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:sendBtn];

    
    //通知中心监测通知事件
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(countDownUpdate:) name:@"CountDownUpdate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendAction
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary  *paramDic = [[NSMutableDictionary  alloc]initWithCapacity:0];
    
    NSString *verificateStr = nil;
    
    if ([self.title isEqualToString:@"注册"]) {
        
        [paramDic  setValue:MailField.text forKey:@"account"];
//        [paramDic  setValue:queueidStr forKey:@"queueId"];
        [paramDic  setValue:@"0"forKey:@"accounttype"];
        [paramDic  setValue:RegNumField.text forKey:@"verificationCode"];
        
        verificateStr = VerificateRegister;
        
    } else if ([self.title isEqualToString:@"忘记密码"])
    {
        [paramDic  setValue:MailField.text forKey:@"account"];
        [paramDic  setValue:RegNumField.text forKey:@"code"];
        verificateStr = VerificateReset;
        
    }

    [AFNetClient  POST_Path:verificateStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
    
            queueidStr=[[JSONDict objectForKey:@"Data"] objectForKey:@"QueueId"];

            if ([self.title isEqualToString:@"注册"]) {
                
                RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
                registerViewController.queueId = queueidStr;
                registerViewController.mailText = MailField.text;
                registerViewController.verificationCode = RegNumField.text;
                [self.navigationController pushViewController:registerViewController animated:YES];

            } else if ([self.title isEqualToString:@"忘记密码"])
            {

                FindPasswordVC * findPasswordVC =[[FindPasswordVC alloc] init];
                findPasswordVC.queueId = queueidStr;
                findPasswordVC.title = @"忘记密码";
                findPasswordVC.mailText = MailField.text;
                findPasswordVC.verificationCode = RegNumField.text;

                [self.navigationController pushViewController: findPasswordVC animated:YES];

            }
        }


        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        [hud hide:YES];
        
    }];
    


}



- (void)editChangeAction:(UITextField *)textField
{
    if (MailField.text.length > 0) {
        loginBt.userInteractionEnabled = YES;
        loginBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        loginBt.userInteractionEnabled = NO;
        loginBt.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
    if (RegNumField.text.length > 6) {
        RegNumField.text = [RegNumField.text substringToIndex:6];
    }
    
    if (MailField.text.length > 0 && RegNumField.text.length > 0) {
        sendBtn.userInteractionEnabled = YES;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        sendBtn.userInteractionEnabled = NO;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    

    
}


//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    if ([CountDownServer isCountDowning:kCountDownForVerifyCode]) {
//        [CountDownServer cancelCountDowning:kCountDownForVerifyCode];
//    }
//}


#pragma mark ---获取验证码
-(void)GetRegistNum:(UIButton *)btn
{
//    if (![RegexTool judgePassWordLegal:MailField.text]) {
//        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
//        
//        return;
//    }
    [self.view endEditing:YES];
    
    if (![RegexTool validateEmail:MailField.text]) {
        [MBProgressHUD showMessage:@"邮箱格式错误"];
        return;
    }
    
    // 开始计时
    [CountDownServer startCountDown:5 identifier:kCountDownForVerifyCode];


    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    NSString *sendStr = nil;
    
    if ([self.title isEqualToString:@"注册"]) {
        
        NSUserDefaults   *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString  *imei=[userDefaultes objectForKey:@"UUID"];
        [paramDic  setValue:MailField.text forKey:@"account"];
        [paramDic  setValue:@"0"forKey:@"accounttype"];
        [paramDic  setValue:imei forKey:@"imei"];
        
        sendStr = SendRegister;
        
    } else if ([self.title isEqualToString:@"忘记密码"])
    {
        [paramDic  setValue:MailField.text forKey:@"account"];
        sendStr = sendVerificateCodeReset;
        
    }

    
    [AFNetClient  POST_Path:sendStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
        

        NSNumber *code=[JSONDict objectForKey:@"Code"];

        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];

            [self.navigationController.view makeToast:msg
                                             duration:1.0
             
                                             position:CSToastPositionCenter];
            if ([CountDownServer isCountDowning:kCountDownForVerifyCode]) {
                [CountDownServer cancelCountDowning:kCountDownForVerifyCode];
            }
            
            [loginBt setTitle:@"获取验证码" forState:UIControlStateNormal];
            loginBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
            loginBt.userInteractionEnabled = YES;
            
        } else {
            
//            [MBProgressHUD showMessage:msg toView:self.view];

            
            loginBt.tag = 101;
            
//            if ([self.title isEqualToString:@"注册"]) {
//                
//                queueidStr=[JSONDict objectForKey:@"Data"] objectForKey:@"QueueId"];
//                
//            }
            
//            message1 = @"发送验证码成功,请到邮箱查看";
            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showError:@"网络似乎已断开!" toView:self.view];
        if ([CountDownServer isCountDowning:kCountDownForVerifyCode]) {
            [CountDownServer cancelCountDowning:kCountDownForVerifyCode];
        }
        
        [loginBt setTitle:@"获取验证码" forState:UIControlStateNormal];
        loginBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
        loginBt.userInteractionEnabled = YES;
        
    }];
    
    
}

//接收到通知实现的方法
- (void)countDownUpdate:(NSNotification *)noti
{
    NSString *identifier = [noti.userInfo objectForKey:@"CountDownIdentifier"];
    if ([identifier isEqualToString:kCountDownForVerifyCode]) {
        NSNumber *n = [noti.userInfo objectForKey:@"SecondsCountDown"];
        
        [self performSelectorOnMainThread:@selector(updateVerifyCodeCountDown:) withObject:n waitUntilDone:YES];
    }
}

- (void)updateVerifyCodeCountDown:(NSNumber *)num{
    if ([num integerValue] == 0){
        [loginBt setTitle:@"重新获取" forState:UIControlStateNormal];
        loginBt.userInteractionEnabled = YES;
        loginBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    }else{
        [loginBt setTitle:[NSString stringWithFormat:@"重新获取验证码（%@S）",num] forState:UIControlStateNormal];
        loginBt.userInteractionEnabled = NO;
        loginBt.backgroundColor=[UIColor colorWithHexString:@"cccccc"];

    }
}

#pragma mark ---UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    if (loginBt.tag == 100) {
        return NO;
    } else {
        return YES;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

@end
