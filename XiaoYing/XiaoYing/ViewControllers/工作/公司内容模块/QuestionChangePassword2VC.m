//
//  AttendantVC.m
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "QuestionChangePassword2VC.h"
#import "QuestionChangePassword3VC.h"
#import "CountDownServer.h"


#define kCountDownForVerifyCode @"CountDownForVerifyCode"



@interface QuestionChangePassword2VC ()
{
    
    // 获取验证码
    UIButton *verificateBtn;
}
//设定管理员密码的时候调用
@property (nonatomic,strong)UITextField *ManagePassWord;//管理密码输入框1
@property (nonatomic,strong) UIButton *nextBt;


@end

@implementation QuestionChangePassword2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setTitle:@"退出" forState:UIControlStateNormal];
    
    
    self.title = @"设置管理密码";
    [self initPassWordUI];
    
    
    
}

//管理密码
-(void)initPassWordUI{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-580/2)/2, 20, 580/2, 24)];
    imgView.image = [UIImage imageNamed:@"step2"];
    [self.view addSubview:imgView];
    
    
    UILabel *remindLab;//提醒
    UILabel *ManagePassLab;//设定管理密码
    
    remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+20, kScreen_Width, 48)];
    remindLab.text = @"请向您的注册邮箱发送验证码\n输入验证码进行验证";
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    remindLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:remindLab];
    
    NSString *contentStr = [NSString stringWithFormat:@"邮箱   %@",[UserInfo userCount]];
    UILabel *questionLab = [[UILabel alloc] initWithFrame:CGRectMake(27, remindLab.bottom+29, kScreen_Width-12, 16)];
    questionLab.text = contentStr;
    questionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    questionLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:questionLab];
    // 富文本
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", contentStr]];
    NSRange contentRange = {5,content.length-5};
    [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:contentRange];
    questionLab.attributedText = content;

    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, questionLab.bottom+15, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];

    
    ManagePassLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 44)];
    ManagePassLab.text = @"验证码";
    ManagePassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ManagePassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ManagePassLab];
    
    
    _ManagePassWord = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, kScreen_Width-85-12-41-6, 44)];
    _ManagePassWord.font = [UIFont systemFontOfSize:16];
    _ManagePassWord.secureTextEntry = YES;
    _ManagePassWord.placeholder = @"请输入验证码";
    _ManagePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ManagePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ManagePassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ManagePassWord];
    
    //发送验证码按钮
    verificateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    verificateBtn.frame = CGRectMake(kScreen_Width-100, 0, 100, 44);
//    verificateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    verificateBtn.titleLabel.lineBreakMode = 0 ;
    verificateBtn.backgroundColor=[UIColor colorWithHexString:@"f99740"];
    [verificateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verificateBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [verificateBtn addTarget:self action:@selector(GetRegistNum:) forControlEvents:UIControlEventTouchUpInside];
    verificateBtn.tag = 100;
    [baseView addSubview:verificateBtn];
    
    
    
    _nextBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBt.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    _nextBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _nextBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_nextBt setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBt.titleLabel.font = [UIFont systemFontOfSize:14];
    _nextBt.clipsToBounds = YES;
    _nextBt.layer.cornerRadius = 5.0;
    _nextBt.userInteractionEnabled = NO;
    [_nextBt addTarget:self action:@selector(ApplyWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBt];
    
    
    NSMutableAttributedString *content1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"用原密码修改密码?"]];
    NSRange contentRange1 = {0,[content1 length]};
    [content1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange1];
    [content1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#848484"] range:contentRange1];
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.frame = CGRectMake(0, _nextBt.bottom+25, kScreen_Width, 17);
    [questionBtn setTitle:@"用原密码修改密码?" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [questionBtn setAttributedTitle:content1 forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(changePasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
    
    //通知中心监测通知事件
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(countDownUpdate:) name:@"CountDownUpdate" object:nil];
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    if ([CountDownServer isCountDowning:kCountDownForVerifyCode]) {
//        [CountDownServer cancelCountDowning:kCountDownForVerifyCode];
//    }
//}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (_ManagePassWord.text.length > 0) {
        _nextBt.userInteractionEnabled = YES;
        _nextBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        _nextBt.userInteractionEnabled = NO;
        _nextBt.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
}


//申请进入的方法
-(void)ApplyWay:(UIButton *)bt{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:self.mailText forKey:@"account"];
    [paramDic  setValue:_ManagePassWord.text forKey:@"Code"];

    [AFNetClient  POST_Path:validateAuthSendcode params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            QuestionChangePassword3VC *questionChangePassword3VC =[QuestionChangePassword3VC alloc];
            questionChangePassword3VC.queueId = JSONDict[@"Data"][@"QueueId"];
            questionChangePassword3VC.validateCode = _ManagePassWord.text;
            [self.navigationController pushViewController:questionChangePassword3VC animated:YES];
            
            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showError:@"网络似乎已断开!" toView:self.view];
        
    }];
    
}

#pragma mark ---获取验证码
-(void)GetRegistNum:(UIButton *)btn
{
    
    // 开始计时
    [CountDownServer startCountDown:5 identifier:kCountDownForVerifyCode];

    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:self.mailText forKey:@"account"];
    [paramDic  setValue:_ManagePassWord.text forKey:@"code"];
    
    [AFNetClient  POST_Path:AuthSendcode params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
//            loginBt.tag = 101;
            
            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        
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
        [verificateBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        verificateBtn.enabled = YES;
    }else{
        [verificateBtn setTitle:[NSString stringWithFormat:@"重新获取验证码（%@S）",num] forState:UIControlStateNormal];
        verificateBtn.enabled = NO;
        
        
    }
}

- (void)changePasswordAction
{
    
    [self popViewController:@"ManagerPasswordResetVC"];
    
}

#pragma mark - 重写返回事件
- (void)backAction:(UIButton *)button
{
    [self popViewController:@"ManagerOperateVC"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
