//
//  RegisterViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/26.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "RegisterViewController.h"
//#import "LoginViewController.h"
#import "ConsumerAgreementVC.h"
#import "KeepAcountModel.h"
#import <RongIMKit/RongIMKit.h>
#import "WLRemindView.h"




@interface RegisterViewController ()<UIScrollViewDelegate>
{
    
    //添加一个uiscrollview
    
    UIScrollView *scrollview;
    
    //用户名
    UITextField *NameField;
    //密码
    UITextField *PassField;
    //重新输入
    UITextField *RePassField;
    
    //提示文字
    UILabel *labnum;
    
    
    //验证码
    NSString *RegNumStr;

    
    //注册什么不符合标准
    NSString *messageStr;
    
    //获取验证码
    UIButton *loginBt;
    
    // 协议同意按钮
    UIButton *imageSelect;
    
    //保存密码按钮
    UIButton *saveBtn;
    
    // 提交
    UIButton *sendBtn;

}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //标题
    self.title = @"注册";
    
    _RegisterBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];

    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width, 133)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_RegisterBackView addSubview:baseView];
    
    UIScrollView *scrollview1 = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollview1.backgroundColor=[UIColor greenColor];
    scrollview1.delegate = self;
    scrollview1.contentSize = CGSizeMake(kScreen_Width, kScreen_Height+80);
    [scrollview1 addSubview:_RegisterBackView];
    [self.view addSubview:scrollview1];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTap)];
    [self.view addGestureRecognizer:tap];
    
    
    UILabel *labUserName = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 44)];
    labUserName.text=@"昵称";
//    labUserName.backgroundColor = [UIColor cyanColor];
    labUserName.font=[UIFont systemFontOfSize:16];
//    labUserName.textAlignment = NSTextAlignmentRight;
    labUserName.textColor=[UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:labUserName];

    
    //姓名
    NameField=[[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreen_Width-85-12, 44)];
//    NameField.backgroundColor = [UIColor cyanColor];
    NameField.placeholder=@"请输入昵称";
//    NameField.delegate=self;
    NameField.tag = 100;
    NameField.font=[UIFont systemFontOfSize:16];
    NameField.textColor=[UIColor colorWithHexString:@"#333333"];
    NameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [NameField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:NameField];
//    [NameField addTarget:self action:@selector(limitLength:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, NameField.bottom, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline];

    
    UILabel *labPassword=[[UILabel alloc] initWithFrame:CGRectMake(12, viewline.bottom, 80, 44)];
    labPassword.text=@"密码";
//    labPassword.textAlignment = NSTextAlignmentRight;
    labPassword.font=[UIFont systemFontOfSize:16];
    labPassword.textColor=[UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:labPassword];

    
    //密码
    PassField=[[UITextField alloc] initWithFrame:CGRectMake(85, viewline.bottom, kScreen_Width-85-12, 44)];
    PassField.placeholder=@"6~16位数字和字母组合";
//    PassField.delegate=self;
    PassField.tag = 102;
    PassField.font=[UIFont systemFontOfSize:16];
    PassField.textColor=[UIColor colorWithHexString:@"#333333"];
    PassField.secureTextEntry=YES;
    PassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    PassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [PassField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:PassField];


    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(0, PassField.bottom, kScreen_Width, 0.5)];
    viewline1.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline1];
    
    UILabel *labRePassword=[[UILabel alloc] initWithFrame:CGRectMake(12, viewline1.bottom, 80, 44)];
    labRePassword.text=@"确认密码";
//    labRePassword.textAlignment = NSTextAlignmentRight;
    labRePassword.font=[UIFont systemFontOfSize:16];
    labRePassword.textColor=[UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:labRePassword];

    
    
    //重写密码
    RePassField=[[UITextField alloc] initWithFrame:CGRectMake(85, viewline1.bottom, kScreen_Width-85-12, 44)];
    RePassField.placeholder=@"请再次输入密码";
//    RePassField.delegate=self;
    RePassField.textColor=[UIColor colorWithHexString:@"#333333"];
    RePassField.font=[UIFont systemFontOfSize:16];
    RePassField.secureTextEntry=YES;
    RePassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    RePassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [RePassField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:RePassField];

    
    
    
    //用户协议
    imageSelect = [UIButton buttonWithType:UIButtonTypeCustom];
//    imageSelect.backgroundColor = [UIColor cyanColor];
    imageSelect.frame = CGRectMake(12, baseView.bottom+6, 40, 40);
    [imageSelect setImage:[UIImage imageNamed:@"choose2"] forState:UIControlStateNormal];
    [imageSelect addTarget:self action:@selector(ReadAgreement:) forControlEvents:UIControlEventTouchUpInside];
    [_RegisterBackView addSubview:imageSelect];
    
    UILabel *labkeepPassword1=[[UILabel alloc] initWithFrame:CGRectMake(imageSelect.right, imageSelect.top+6, 100, 30)];
    labkeepPassword1.text=@"您已阅读并同意";
//    labkeepPassword1.backgroundColor = [UIColor cyanColor];
    labkeepPassword1.font=[UIFont systemFontOfSize:14];
    labkeepPassword1.textColor=[UIColor colorWithHexString:@"#848484"];
    [_RegisterBackView addSubview:labkeepPassword1];

    
    UILabel *labkeepPassword2=[[UILabel alloc] initWithFrame:CGRectMake(labkeepPassword1.right, imageSelect.top+6, 120, 30)];
    labkeepPassword2.text=@"小赢计划用户协议";
    labkeepPassword2.font=[UIFont systemFontOfSize:14];
    labkeepPassword2.textColor=[UIColor colorWithHexString:@"f99740"];
    labkeepPassword2.userInteractionEnabled=YES;
    [_RegisterBackView addSubview:labkeepPassword2];

    
    UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapYonghuxieyi)];
    [labkeepPassword2 addGestureRecognizer:tap3];

    
    sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(12, imageSelect.bottom+25, kScreen_Width-24, 44);
    sendBtn.layer.cornerRadius=5;
    sendBtn.tag=101;
    sendBtn.userInteractionEnabled = NO;
    sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(BackANDFinish:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [_RegisterBackView addSubview:sendBtn];

    
}


int flagReadAgreement;
-(void)ReadAgreement:(UIButton *)btn {
    if (flagReadAgreement==0) {
        [imageSelect setImage:[UIImage imageNamed:@"choose2-none"] forState:UIControlStateNormal];
        sendBtn.userInteractionEnabled = NO;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];

        flagReadAgreement=1;
    }else{
        [imageSelect setImage:[UIImage imageNamed:@"choose2"] forState:UIControlStateNormal];
        
        if (NameField.text.length > 0 && PassField.text.length > 0 && RePassField.text.length > 0) {
            sendBtn.userInteractionEnabled = YES;
            sendBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
        }

        flagReadAgreement = 0;
        
    }
}




//跳转到用户协议的方法
-(void)tapYonghuxieyi{
    NSLog(@"跳转到用户协议");
    ConsumerAgreementVC *agree=[[ConsumerAgreementVC alloc]init];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:agree animated:YES];
}
//是否完成注册
-(void)BackANDFinish:(UIButton*)bt{

//    if (PassField.text.length < 6 || PassField.text.length > 16) {
//        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
//
//        return;
//    }
    
    if (![RegexTool judgePassWordLegal:PassField.text]) {
        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
        
        return;
    }
    
    if (![PassField.text isEqualToString:RePassField.text]) {
        [MBProgressHUD showMessage:@"两次密码输入不一致" toView:self.view];

        return;
    }

    
    //提交注册
    [self RegisWay];
    
    
}


- (void)editChangeAction:(UITextField *)textField
{
    
    if (NameField.text.length > 12) {
        NameField.text = [NameField.text substringToIndex:12];
    }
    
    if (NameField.text.length > 0 && PassField.text.length > 0 && RePassField.text.length > 0 && 0 == flagReadAgreement) {
        sendBtn.userInteractionEnabled = YES;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        sendBtn.userInteractionEnabled = NO;
        sendBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }

}
#pragma mark ---添加手势点击按钮
-(void)gestureTap{
    [self.view endEditing:YES];
}


#pragma mark ---注册
-(void)RegisWay{
    
    [self.view endEditing:YES];
    
    //登录中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //判断验证码是否成功，如果UUID，Queneid,verficationcode都正确则注册成功否则重新输入
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *imei=[userDefaultes objectForKey:@"UUID"];
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:self.queueId forKey:@"queueId"];
    [paramDic  setValue:NameField.text forKey:@"nick"];
    [paramDic  setValue:self.mailText forKey:@"account"];
    [paramDic  setValue:@"0"forKey:@"accountType"];
    [paramDic  setValue:PassField.text forKey:@"password"];
    [paramDic  setValue:self.verificationCode  forKey:@"verificationcode"];
    [paramDic  setValue:imei forKey:@"imei"];
    
    //注册账号
    [AFNetClient  POST_Path:SubmitRegister params:paramDic completed:^(NSData *stringData, id JSONDict) {

        [hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {

            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            [WLRemindView showIcon:@"success"];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            
//            // 登录
//            [self login];
            
        }
        
    } failed:^(NSError *error) {
        
        [hud hide:YES];

        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        NSLog(@"%@",error);
    }];
    
    return ;
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
