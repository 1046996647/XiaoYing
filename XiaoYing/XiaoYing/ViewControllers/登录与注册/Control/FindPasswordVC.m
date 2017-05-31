//
//  RegisterViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/26.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "FindPasswordVC.h"
//#import "LoginViewController.h"
#import "WLRemindView.h"
#import <RongIMKit/RongIMKit.h>
#import "TabBarItem.h"


@interface FindPasswordVC ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    
    
    //密码
    UITextField *PassField;
    //重新输入
    UITextField *RePassField;
    
    //电子邮箱
    UITextField *MailField;
    
    //提示文字
    UILabel *labnum;
    
    //验证码
    UITextField *RegNumField;
    
    
    //验证码
    NSString *RegNumStr;
    //获取验证码返回的一个值
    
    NSString *queueidStr;
    
    //注册什么不符合标准
    NSString *messageStr;
    
    //获取验证码
    UIButton *loginBt;
    
    // 确定
    UIButton *sendBtn;
    
}
@end

@implementation FindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //标题
//    self.title = @"忘记密码";
    
//    _RegisterBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
//    [self.view addSubview:_RegisterBackView];
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width, 88.5)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *labPassword=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 44)];
    labPassword.text=@"新密码";
//    labPassword.textAlignment = NSTextAlignmentRight;
    labPassword.font=[UIFont systemFontOfSize:16];
    labPassword.textColor=[UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:labPassword];

    
    //密码
    PassField=[[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreen_Width-85-12, 44)];
    PassField.placeholder=@"6~16位数字和字母组合";
    PassField.delegate=self;
    PassField.font=[UIFont systemFontOfSize:14];
    PassField.textColor=[UIColor colorWithHexString:@"#333333"];
    PassField.secureTextEntry=YES;
    PassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    PassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [PassField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:PassField];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, PassField.bottom, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline];
    
    
    UILabel *labRePassword=[[UILabel alloc] initWithFrame:CGRectMake(12, viewline.bottom, 80, 44)];
    labRePassword.text=@"确认密码";
//    labRePassword.textAlignment = NSTextAlignmentRight;
    labRePassword.font=[UIFont systemFontOfSize:16];
    labRePassword.textColor=[UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:labRePassword];
    
    
    //重写密码
    RePassField=[[UITextField alloc] initWithFrame:CGRectMake(85, viewline.bottom, kScreen_Width-85-12, 44)];
    RePassField.placeholder=@"请再次输入密码";
    RePassField.delegate=self;
    RePassField.textColor=[UIColor colorWithHexString:@"#333333"];
    RePassField.font=[UIFont systemFontOfSize:14];
    RePassField.secureTextEntry=YES;
    RePassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    RePassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [RePassField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:RePassField];
    
    
    sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    sendBtn.layer.cornerRadius=5;
    sendBtn.tag=101;
    sendBtn.userInteractionEnabled = NO;
    sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
//    sendBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(BackANDFinish:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:sendBtn];
    
    
    
}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (PassField.text.length > 0 && RePassField.text.length > 0) {
        sendBtn.userInteractionEnabled = YES;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        sendBtn.userInteractionEnabled = NO;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
}

-(void)BackANDFinish:(UIButton*)bt {
    
    if (![RegexTool judgePassWordLegal:PassField.text]) {
        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
        
        return;
    }
    
    if (![PassField.text isEqualToString:RePassField.text]) {
        [MBProgressHUD showMessage:@"两次密码输入不一致" toView:self.view];
        
        return;
    }
    
    NSMutableDictionary  *paramDic = [[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:PassField.text forKey:@"password"];
    [paramDic  setValue:self.queueId forKey:@"queueId"];
    [paramDic  setValue:self.verificationCode forKey:@"validateCode"];
    
    [AFNetClient  POST_Path:PasswordReset params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            [WLRemindView showIcon:@"success"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StartExit" object:nil];

            // 登录
//            [self login];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        
    }];

}



#pragma mark --登录
//登录按钮
-(void)login {
    
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *imei=[user objectForKey:@"UUID"];
    
    
    NSString *loginStr = [NSString stringWithFormat:@"%@username=%@&password=%@&imei=%@",Login, self.mailText,PassField.text,imei];
    
    //登录的方法
    [AFNetClient POST_Path:loginStr completed:^(NSData *stringData, id JSONDict) {
        
        //            UserDic=JSONDict;
        
        
        NSString *Code=[NSString stringWithFormat:@"%@",[JSONDict objectForKey:@"Code"]];
        
        if ([Code isEqualToString:@"0"]) {
            
            [self.view endEditing:YES];
            
            app.tabvc = [[LoginTabVC alloc] init];
            app.window.rootViewController = app.tabvc;
            app.tabvc.selectedIndex = 1;
            
            // 保存账户
            [UserInfo saveUserCount:self.mailText];
            
            //保存Token的值
            [UserInfo saveToken:[[JSONDict objectForKey:@"Data"] objectForKey:@"Token"]];
            [UserInfo saveUserID:[[[JSONDict objectForKey:@"Data"] objectForKey:@"Profile"] objectForKey:@"ProfileId"]];
            
            //get请求获取用户简介
            //            [self getProfile];
            
            
            
            //处于登录状态
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:@"1" forKey:@"YESORNOTLOGIN"];
            
            //请求融云token和连接融云服务器
            [self connectRongyunServie];
            
            //获取个人信息并保存到本地
            [self getMyMessage];
            
        }else if ([Code isEqualToString:@"1"]){
            
            [MBProgressHUD showMessage:[JSONDict  objectForKey:@"Message"]];
            
        }
    } failed:^(NSError *error) {
        
    }];
    
    
}

#pragma mark----融云
-(void)connectRongyunServie{
    //******* 获取融云Token
    [AFNetClient GET_Path:IMToken completed:^(NSData *stringData, id JSONDict) {
        NSString * RongCode=[NSString stringWithFormat:@"%@",[JSONDict objectForKey:@"Code"]];
        //                    获取融云Token
        id DataDic =[JSONDict objectForKey:@"Data"];
        
        if ([DataDic isKindOfClass:[NSNull class]]) {
            return ;
        }
        
        NSString * RongCloud =[DataDic objectForKey:@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "RongCloudToken"];
        
        // 本地保存融云token(改)
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:RongCloud forKey:@"RongCloud"];
        [userDefaults synchronize];
        
        if ([RongCode isEqualToString:@"0"]) {
            // 连接融云服务器
            [[RCIM sharedRCIM] connectWithToken:RongCloud success:^(NSString *userId) {
                NSLog(@" IMToken chenggong ********************* ");
                //                [[RCIM sharedRCIM] setUserInfoDataSource:self];
                
            }
                                          error:^(RCConnectErrorCode status) {  }
                                 tokenIncorrect:^(){}];
        }
        else if ([RongCode isEqualToString:@"1"])
        {
            NSLog(@"Rong Cloud Message ");
        }
    } failed:^(NSError *error) {
        NSLog(@"error   213321233 %@",error);
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/**
 *  获取个人信息
 */
-(void)getMyMessage{
    
    [AFNetClient GET_Path:ProfileMy completed:^(NSData *stringData, id JSONDict) {
        
        ProfileMyModel * model1 = [FirstModel GetProfileMyModel:[JSONDict objectForKey:@"Data"]];
        //获取存储沙盒路径
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentPath = [documentPath stringByAppendingPathComponent:@"PersonCentre.plist"];
        //用归档存储数据在plist文件中
        NSLog(@"个人中心存储在PersonCentre.plist文件中%@",documentPath);
        
        [NSKeyedArchiver archiveRootObject:model1 toFile:documentPath];
        
    } failed:^(NSError *error) {
        
        NSLog(@"  %@",error);
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


@end
