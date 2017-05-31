//
//  LoginViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/21.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ReLoginViewController.h"
#import "GetVerificationCodeVC.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "LoginTabVC.h"
#import "CustomTabVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "ConnectModel.h"


#import <RongIMKit/RongIMKit.h>

#define XiaoYingVersion @"V1.0.0.0"

@interface ReLoginViewController ()<UITextFieldDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    //设定缓冲区将数据保存在缓冲区中
    NSMutableData *data_;
    //标题
    UILabel *titleLab;
    
    //头像
    
    UIImageView *imageviewHead;
    
    //用户名
    UITextField *userNameField;
    //密码
    UITextField *passWordField;
    //登录按钮
    UIButton *loginBt;
    //注册
    
    UIButton *registerBt;
    //找回密码
    
    UIButton *FindPassWord;
    
    //登录url
    NSString *LOGIN;
    
    
    NSDictionary *UserDic;
    
    
    UIScrollView *scroll_;
    
    
    //保存密码的图片
    UIButton *imageSelect;
    
    //初始化
    NSUserDefaults *usermy;
    NSMutableArray * friendArr; //好友数组
    
    // 登陆错误提醒
    UIButton *_remindBtn;
}


@end

@implementation ReLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];

    
//    self.navigationItem.title =@"小赢计划";
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFriendArray:) name:@"KReceiveFriendArray" object:nil];
    usermy = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    
    data_=[[NSMutableData alloc]init];
    self.view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
    [self.view addGestureRecognizer:tap];
    [self initUI];
    
    // 为了解决masonry未给frame问题
    [self performSelector:@selector(initSubviews) withObject:nil afterDelay:.05];
    
    NSLog(@"dsds");
}
//-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
////    self.navigationController.navigationBar.hidden = NO;
//}


-(void)hide:(UITapGestureRecognizer*)tap{
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
}
-(void)initUI{
    
    
    //头像
    imageviewHead = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"face"]];
    [self.view addSubview:imageviewHead];
    
    imageviewHead.layer.masksToBounds = YES;
    imageviewHead.layer.cornerRadius = 50*scaleX;
    [imageviewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_top).offset(90*scaleY);
        make.size.mas_equalTo(CGSizeMake(100*scaleX, 100*scaleX));
    }];
    
    //账号
    UIView *userNameView=[[UIView alloc]init];
    userNameView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:userNameView];
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(177*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 50*scaleY));
    }];
    
    
    UIImageView *imageviewName=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username"]];
    [userNameView addSubview:imageviewName];
    [imageviewName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameView.mas_left).offset(10*scaleX);
        make.centerY.mas_equalTo(userNameView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(23*scaleX, 23*scaleY));
    }];
    
    //密码
    UIView *passWordView=[[UIView alloc]init];
    passWordView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passWordView];
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(227.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 50*scaleY));
    }];
    
    UIImageView *imageviewpass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    
    [passWordView addSubview:imageviewpass];
    [imageviewpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passWordView.mas_left).offset(10*scaleX);
        make.centerY.mas_equalTo(passWordView.center.y);
        make.size.mas_equalTo(CGSizeMake(23*scaleX, 23*scaleY));
    }];
    
    // 获取账户
    NSString *countStr = [UserInfo userCount];
    
    userNameField=[[UITextField alloc]init];
    userNameField.placeholder=@"请输入账号";
    userNameField.delegate=self;
    userNameField.text = countStr;
    userNameField.font=[UIFont systemFontOfSize:16];
    [userNameField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [userNameView addSubview:userNameField];
    [userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameView.mas_left).offset(43*scaleX);
        make.top.mas_equalTo(userNameView.top);
        make.size.mas_equalTo(CGSizeMake(265*scaleX, 50*scaleY));
    }];
    
    //密码
    passWordField=[[UITextField alloc]init];
    passWordField.placeholder=@"密码";
    passWordField.delegate=self;
    passWordField.secureTextEntry=YES;
    passWordField.font=[UIFont systemFontOfSize:16];
    passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [passWordField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [passWordView addSubview:passWordField];
    [passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passWordView.mas_left).offset(43*scaleX);
        make.top.mas_equalTo(passWordView.top);
        make.size.mas_equalTo(CGSizeMake(265*scaleX, 50*scaleY));
    }];
    
    loginBt=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBt.layer.cornerRadius=5;
    loginBt.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    loginBt.userInteractionEnabled = NO;
    [loginBt setTitle:@"登录" forState:UIControlStateNormal];
    loginBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBt addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBt];
    [loginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(320*scaleY);
        make.size.mas_equalTo(CGSizeMake(300*scaleX, 45*scaleY));
    }];
    
    [self addkeyBoardObservew];
    
    
    
}

- (void)editChangeAction:(UITextField *)textField
{
    if (userNameField.text.length > 0 && passWordField.text.length > 0) {
        loginBt.userInteractionEnabled = YES;
        loginBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        loginBt.userInteractionEnabled = NO;
        loginBt.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
}


- (void)initSubviews
{
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-.5)/2, loginBt.bottom+25, .5, 20)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:viewline];
    
    registerBt=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBt.tag=101;
    registerBt.frame = CGRectMake(viewline.left-20-80, loginBt.bottom+27, 80, 17);
    [registerBt setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    [registerBt setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBt addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    registerBt.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:registerBt];
    
    
    
    FindPassWord=[UIButton buttonWithType:UIButtonTypeCustom];
    FindPassWord.frame = CGRectMake(viewline.right+20, loginBt.bottom+27, 80, 17);
    FindPassWord.tag=102;
    FindPassWord.titleLabel.font=[UIFont systemFontOfSize:17];
    [FindPassWord setTitle:@"忘记密码" forState:UIControlStateNormal];
    [FindPassWord setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    [FindPassWord addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FindPassWord];
}

-(void)addkeyBoardObservew{
    //监听键盘的出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘的消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardHidden:(NSNotification *)notification
{
    self.view.frame=CGRectMake(0, 64
                               
                               , kScreen_Width, kScreen_Height);
    [UIView commitAnimations];
}
-(void)keyboardShow:(NSNotification *)notification
{
    self.view.frame=CGRectMake(0, -50*scaleY, kScreen_Width, kScreen_Height);
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:userNameField]&&![textField.text isEqualToString:@""]) {
        
        [passWordField becomeFirstResponder];
        
    }else if ([textField isEqual:passWordField]){
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}
#pragma mark --注册 找回密码
-(void)jump:(UIButton*)bt{
    
    [self.view endEditing:YES];
    GetVerificationCodeVC *Re = [[GetVerificationCodeVC alloc]init];

    if (bt.tag==101) {
        Re.title = @"注册";
    }else if (bt.tag==102){
        Re.title = @"忘记密码";
        
    }
    [self.navigationController pushViewController:Re animated:YES];

    
}
#pragma mark --登录
//登录按钮
-(void)login:(UIButton*)bt{
    
    [self.view endEditing:YES];
    
     AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (!([RegexTool validateUserPhone:userNameField.text] || [RegexTool validateEmail:userNameField.text])){
        
        [MBProgressHUD showMessage:@"用户名格式错误"];
        return;
    }
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *imei=[user objectForKey:@"UUID"];
    
    
    if([RegexTool validateUserPhone:userNameField.text] || [RegexTool validateEmail:userNameField.text]){
    
        LOGIN = [NSString stringWithFormat:@"%@username=%@&password=%@&imei=%@",Login, userNameField.text,passWordField.text,imei];
        
        //登录中
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"登录中...";
        
        //登录的方法
        [AFNetClient POST_Path:LOGIN completed:^(NSData *stringData, id JSONDict) {
            
            [hud  hide:YES];
            
            UserDic = JSONDict;
            
            NSString *Code = [NSString stringWithFormat:@"%@",[JSONDict objectForKey:@"Code"]];
            
            if ([Code isEqualToString:@"0"]) {

//                NSString *account = [UserInfo userCount];
//      NSLog(@"-----------------------------------%@",JSONDict );

                // 保存账户
                [UserInfo saveUserCount:userNameField.text];
                
                //保存Token的值
                [UserInfo saveToken:[[JSONDict objectForKey:@"Data"] objectForKey:@"Token"]];
                [UserInfo saveUserID:[[[JSONDict objectForKey:@"Data"] objectForKey:@"Profile"] objectForKey:@"ProfileId"]];
                
                //处于登录状态
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setObject:@"1" forKey:@"YESORNOTLOGIN"];
                
                //获取个人信息并保存到本地
                [self getMyMessage];

                // 连接socket通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KSocketConnectNotification" object:nil];

                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"LoadedRegion"]) {
                    //请求地区数据并保存到本地
                    [self requestRegionData];
                }
                
                // 存储用户设备信息
                [self dataCollect];
                
//                // 二维码字符串
//                [self postGencode];
                
                app.tabvc = [[LoginTabVC alloc] init];
                app.tabvc.selectedIndex = 1;
                app.window.rootViewController = app.tabvc;
                
            } else if ([Code isEqualToString:@"1"]){
                
                [MBProgressHUD showMessage:[JSONDict  objectForKey:@"Message"]];
                
            }
        } failed:^(NSError *error) {
            
            NSLog(@"%@",error);
            [hud  hide:YES];
            [MBProgressHUD showMessage:@"网络似乎已经断开!"];
            
        }];
        
    }
    
    
}

-(void)postGencode{
    
    [AFNetClient POST_Path:FriendGencode completed:^(NSData *stringData, id JSONDict) {
        NSString *str = [JSONDict objectForKey:@"Data"];
        [UserInfo saveCode:str];
        
        NSLog(@"%@",str);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

// 存储用户设备信息
- (void)dataCollect
{
    // 设备令牌
    NSString *key=@"DeviceToken";
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    NSMutableDictionary  *paramDic = [[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:@"" forKey:@"appIp"];
    [paramDic  setValue:@"" forKey:@"appMac"];
    [paramDic  setValue:@1 forKey:@"systemType"];
    [paramDic  setValue:CurrentSystemVersion forKey:@"appSysVersion"];
    [paramDic  setValue:XiaoYingVersion forKey:@"appVersion"];
    [paramDic  setValue:@"" forKey:@"producer"];
    [paramDic  setValue:@1 forKey:@"deviceType"];
    [paramDic  setValue:@"" forKey:@"deviceVersion"];
    [paramDic  setValue:token forKey:@"deviceToken"];
    
    [AFNetClient  POST_Path:DataCollect params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        
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
                
                ProfileMyModel * model1 = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
                
                // 当前登录的用户的用户信息
                RCUserInfo * user =[[RCUserInfo alloc]init];
                user.userId = model1.ProfileId;
                user.name = model1.Nick;
                NSString *iconURL = [NSString replaceString:model1.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
                user.portraitUri = iconURL;
                [RCIM sharedRCIM].currentUserInfo = user;
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


//-(void)receiveFriendArray:(NSNotification *)noti{
//    friendArr =noti.object;
//    
//}

//请求地区数据
- (void)requestRegionData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:Region parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadedRegion"];

        
        NSArray *regionArr = responseObject[@"Data"];
//        NSMutableArray *regionArr = [responseObject[@"Data"] mutableCopy];
//        [regionArr removeObjectsInRange:NSMakeRange(regionArr.count-2, 2)];
        
        //保存到本地
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/region.plist"];
        [regionArr writeToFile:filePath atomically:YES];
        //        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
        
        //请求融云token和连接融云服务器
        [self connectRongyunServie];
        
    } failed:^(NSError *error) {
        
        NSLog(@"  %@",error);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end



