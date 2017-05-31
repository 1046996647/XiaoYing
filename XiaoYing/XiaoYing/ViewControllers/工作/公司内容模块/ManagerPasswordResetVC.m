//
//  AttendantVC.m
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ManagerPasswordResetVC.h"
#import "QuestionChangePassword1VC.h"


@interface ManagerPasswordResetVC ()

//设定管理员密码的时候调用
@property (nonatomic,strong)UITextField *ManageOringinPassWord;//管理密码输入框0
@property (nonatomic,strong)UITextField *ManagePassWord;//管理密码输入框1
@property (nonatomic,strong)UITextField *ReManagePassWord;//确认管理密码输入框2
@property (nonatomic,strong) UIButton *ApplyBt;


@end

@implementation ManagerPasswordResetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setTitle:@"退出" forState:UIControlStateNormal];
    
    
    self.title = @"修改管理密码";
    [self initPassWordUI];
    
    
    
}

//管理密码
-(void)initPassWordUI{
    
    UILabel *remindLab;//提醒
    UILabel *ManageOringinPassLab;//设定管理密码
    UILabel *ManagePassLab;//设定管理密码
    UILabel *ConfirmManagePassLab;//设定管理密码
    UIView *viewline1;//线1
    UIView *viewline2;//线2
    UIButton *ApplyBt;//申请进入按钮
    
    remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, 48)];
    remindLab.text = @"请在下面输入您的新密码\n点击确定完成修改";
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    remindLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:remindLab];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, remindLab.bottom+15, kScreen_Width, 133)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    
    ManageOringinPassLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    ManageOringinPassLab.text = @"原密码";
    ManageOringinPassLab.textAlignment = NSTextAlignmentRight;
    ManageOringinPassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ManageOringinPassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ManageOringinPassLab];
    
    
    _ManageOringinPassWord = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreen_Width-85-12, 44)];
    _ManageOringinPassWord.font = [UIFont systemFontOfSize:16];
    _ManageOringinPassWord.secureTextEntry = YES;
    _ManageOringinPassWord.placeholder = @"请输入您的原管理密码";
    _ManageOringinPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ManageOringinPassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ManageOringinPassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ManageOringinPassWord];
    
    viewline1 = [[UIView alloc] initWithFrame:CGRectMake(0, _ManageOringinPassWord.bottom, kScreen_Width, 0.5)];
    viewline1.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline1];
    
    
    ManagePassLab = [[UILabel alloc] initWithFrame:CGRectMake(12, viewline1.bottom, 80, 44)];
    ManagePassLab.text = @"管理密码";
    ManagePassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ManagePassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ManagePassLab];
    
    
    _ManagePassWord = [[UITextField alloc] initWithFrame:CGRectMake(85, viewline1.bottom, kScreen_Width-85-12, 44)];
    _ManagePassWord.font = [UIFont systemFontOfSize:16];
    _ManagePassWord.secureTextEntry = YES;
    _ManagePassWord.placeholder = @"6~16位数字和字母组合";
    _ManagePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ManagePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ManagePassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ManagePassWord];
    
    viewline2 = [[UIView alloc] initWithFrame:CGRectMake(0, _ManagePassWord.bottom, kScreen_Width, 0.5)];
    viewline2.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline2];
    
    
    ConfirmManagePassLab = [[UILabel alloc] initWithFrame:CGRectMake(12, viewline2.bottom, 80, 44)];
    ConfirmManagePassLab.text = @"确认密码";
    ConfirmManagePassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ConfirmManagePassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ConfirmManagePassLab];
    
    _ReManagePassWord = [[UITextField alloc] initWithFrame:CGRectMake(85, viewline2.bottom, kScreen_Width-85-12, 44)];
    _ReManagePassWord.font = [UIFont systemFontOfSize:16];
    _ReManagePassWord.secureTextEntry = YES;
    _ReManagePassWord.placeholder = @"请再次输入密码";
    _ReManagePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ReManagePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ReManagePassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ReManagePassWord];
    
    
    ApplyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    ApplyBt.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    ApplyBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    //    ApplyBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [ApplyBt setTitle:@"确定" forState:UIControlStateNormal];
    ApplyBt.titleLabel.font = [UIFont systemFontOfSize:14];
    ApplyBt.clipsToBounds = YES;
    ApplyBt.layer.cornerRadius = 5.0;
    ApplyBt.userInteractionEnabled = NO;
    [ApplyBt addTarget:self action:@selector(ApplyWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ApplyBt];
    self.ApplyBt = ApplyBt;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"用密保问题修改密码?"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#848484"] range:contentRange];
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.frame = CGRectMake(0, ApplyBt.bottom+25, kScreen_Width, 17);
    [questionBtn setTitle:@"用密保问题修改密码?" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [questionBtn setAttributedTitle:content forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(changePasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];

    
    
}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (_ManageOringinPassWord.text.length > 0 &&_ManagePassWord.text.length > 0 && _ReManagePassWord.text.length > 0) {
        self.ApplyBt.userInteractionEnabled = YES;
        self.ApplyBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        self.ApplyBt.userInteractionEnabled = NO;
        self.ApplyBt.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
}

//确定
-(void)ApplyWay:(UIButton *)bt{

    
    if (![RegexTool judgePassWordLegal:_ManagePassWord.text]) {
        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
        
        return;
    }
    
    if (![_ManagePassWord.text isEqualToString:_ReManagePassWord.text]) {
        [MBProgressHUD showMessage:@"两次密码输入不一致" toView:self.view];
        
        return;
    }
    
    //    NSMutableDictionary  *paramDic = [[NSMutableDictionary  alloc]initWithCapacity:0];
    //
    //    [paramDic  setValue:PassField.text forKey:@"password"];
    //    [paramDic  setValue:self.queueId forKey:@"queueId"];
    NSString *strURL = [NSString stringWithFormat:@"%@&OldPassword=%@&NewPassword=%@",ModifyManangerPassword, _ManageOringinPassWord.text, _ManagePassWord.text];
    
    [AFNetClient  POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            //            [WLRemindView showIcon:@"success"];
            [self.navigationController popViewControllerAnimated:YES];

        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        
    }];

//    [self.navigationController pushViewController:[[ManagerLoginVC alloc] init] animated:YES];
    
}

-(void)changePasswordAction
{
    [self.navigationController pushViewController:[[QuestionChangePassword1VC alloc] init] animated:YES];

}

#pragma mark - 重写返回事件
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
