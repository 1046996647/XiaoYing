//
//  AttendantVC.m
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "QuestionChangePassword3VC.h"


@interface QuestionChangePassword3VC ()

//设定管理员密码的时候调用
@property (nonatomic,strong)UITextField *ManagePassWord;//管理密码输入框1
@property (nonatomic,strong)UITextField *ReManagePassWord;//确认管理密码输入框2


@property (nonatomic,strong) UIButton *nextBt;


@end

@implementation QuestionChangePassword3VC

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
    imgView.image = [UIImage imageNamed:@"step3"];
    [self.view addSubview:imgView];
    
    
    UILabel *remindLab;//提醒
    UILabel *ManagePassLab;//设定管理密码
    UIView *viewline;//线1
    UILabel *ConfirmManagePassLab;//设定管理密码


    
    remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+20, kScreen_Width, 48)];
    remindLab.text = @"请在下面输入您的密保问题的答案\n点击下一步修改密码";
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    remindLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:remindLab];
    
    UILabel *questionLab = [[UILabel alloc] initWithFrame:CGRectMake(12, remindLab.bottom+29, kScreen_Width-12, 16)];
    questionLab.text = @"问题   北京烤鸭?";
    questionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    questionLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:questionLab];
    // 富文本
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"问题   北京烤鸭?"]];
    NSRange contentRange = {content.length-5,5};
    [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:contentRange];
    questionLab.attributedText = content;
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, remindLab.bottom+15, kScreen_Width, 88.5)];
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
    
    viewline = [[UIView alloc] initWithFrame:CGRectMake(0, _ManagePassWord.bottom, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [baseView addSubview:viewline];
    
    
    ConfirmManagePassLab = [[UILabel alloc] initWithFrame:CGRectMake(12, viewline.bottom, 80, 44)];
    ConfirmManagePassLab.text = @"确认密码";
    ConfirmManagePassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ConfirmManagePassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ConfirmManagePassLab];
    
    _ReManagePassWord = [[UITextField alloc] initWithFrame:CGRectMake(85, viewline.bottom, kScreen_Width-85-12, 44)];
    _ReManagePassWord.font = [UIFont systemFontOfSize:16];
    _ReManagePassWord.secureTextEntry = YES;
    _ReManagePassWord.placeholder = @"请再次输入密码";
    _ReManagePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ReManagePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ReManagePassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ReManagePassWord];
    
    
    _nextBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBt.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    _nextBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _nextBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_nextBt setTitle:@"确定" forState:UIControlStateNormal];
    _nextBt.titleLabel.font = [UIFont systemFontOfSize:14];
    _nextBt.clipsToBounds = YES;
    _nextBt.layer.cornerRadius = 5.0;
    [_nextBt addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (_ManagePassWord.text.length > 0 && _ReManagePassWord.text.length > 0) {
        _nextBt.userInteractionEnabled = YES;
        _nextBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    } else {
        _nextBt.userInteractionEnabled = NO;
        _nextBt.backgroundColor=[UIColor colorWithHexString:@"#cccccc"];
    }
    
}

-(void)nextAction:(UIButton *)bt{
    
    if (![RegexTool judgePassWordLegal:_ManagePassWord.text]) {
        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
        
        return;
    }
    
    if (![_ManagePassWord.text isEqualToString:_ReManagePassWord.text]) {
        [MBProgressHUD showMessage:@"两次密码输入不一致" toView:self.view];
        
        return;
    }
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:self.queueId forKey:@"queueId"];
    [paramDic  setValue:self.validateCode forKey:@"validateCode"];
    [paramDic  setValue:_ManagePassWord.text forKey:@"password"];
    
    [AFNetClient  POST_Path:ResetAuthPassword params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            [self popViewController:@"ManagerOperateVC"];

        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showError:@"网络似乎已断开!" toView:self.view];
        
    }];

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
