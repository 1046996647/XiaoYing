//
//  ManagerLoginVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ManagerOperateVC.h"
#import "ManageVC.h"
#import "ManagerPasswordResetVC.h"

@interface ManagerOperateVC ()

@property (nonatomic,strong)UITextField *ManagePassWord;//管理密码输入框1
@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,strong)UIButton *changePasswordBtn;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation ManagerOperateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"综合管理";
    
    UILabel *ManagePassLab;//设定管理密码
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    ManagePassLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 44)];
    ManagePassLab.text = @"管理密码";
    ManagePassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ManagePassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ManagePassLab];
    
    
    _ManagePassWord = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreen_Width-85-12, 44)];
    _ManagePassWord.font = [UIFont systemFontOfSize:16];
    _ManagePassWord.secureTextEntry = YES;
    _ManagePassWord.placeholder = @"6~16位数字和字母组合";
    _ManagePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ManagePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ManagePassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ManagePassWord];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    //    ApplyBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _loginBtn.clipsToBounds = YES;
    _loginBtn.layer.cornerRadius = 5.0;
    _loginBtn.userInteractionEnabled = NO;
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _changePasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changePasswordBtn.frame = CGRectMake(12, _loginBtn.bottom+12, kScreen_Width-24, 44);
//    _changePasswordBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _changePasswordBtn.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_changePasswordBtn setTitle:@"修改管理密码" forState:UIControlStateNormal];
    _changePasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _changePasswordBtn.clipsToBounds = YES;
    _changePasswordBtn.layer.cornerRadius = 5.0;
    [_changePasswordBtn addTarget:self action:@selector(changePasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changePasswordBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (_ManagePassWord.text.length > 0) {
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
}

- (void)loginAction
{
    
    if (![RegexTool judgePassWordLegal:_ManagePassWord.text]) {
        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
        
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    
    NSString *strURL = [NSString stringWithFormat:@"%@&Password=%@",AuthLogin, _ManagePassWord.text];
    
    [AFNetClient  POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        _hud.hidden = YES;
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            //            [WLRemindView showIcon:@"success"];
            [self.navigationController pushViewController:[[ManageVC alloc] init] animated:YES];
            
            
        }
        
    } failed:^(NSError *error) {
        _hud.hidden = YES;
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        
    }];


}

- (void)changePasswordAction
{
    [self.navigationController pushViewController:[[ManagerPasswordResetVC alloc] init] animated:YES];

}


@end
