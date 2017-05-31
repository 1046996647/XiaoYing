//
//  AttendantVC.m
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "QuestionChangePassword1VC.h"
#import "QuestionChangePassword2VC.h"
#import "ManagerPasswordResetVC.h"
#import "ManagerOperateVC.h"


@interface QuestionChangePassword1VC ()

//设定管理员密码的时候调用
@property (nonatomic,strong)UITextField *ManagePassWord;//管理密码输入框1
@property (nonatomic,strong) UIButton *nextBt;
@property (nonatomic,strong) UILabel *questionContentLab;


@end

@implementation QuestionChangePassword1VC

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
    imgView.image = [UIImage imageNamed:@"step1"];
    [self.view addSubview:imgView];

    
    UILabel *remindLab;//提醒
    UILabel *ManagePassLab;//设定管理密码
    
    remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+20, kScreen_Width, 48)];
    remindLab.text = @"请在下面输入您的密保问题的答案\n点击下一步修改密码";
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    remindLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:remindLab];
    
    UILabel *questionLab = [[UILabel alloc] initWithFrame:CGRectMake(12, remindLab.bottom+29, 40, 16)];
    questionLab.text = @"问题";
    questionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    questionLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:questionLab];
    
    UILabel *questionContentLab = [[UILabel alloc] initWithFrame:CGRectMake(questionLab.right + 12, remindLab.bottom+29, kScreen_Width-(questionLab.right + 12)-12, 16)];
    questionContentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    questionContentLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:questionContentLab];
    self.questionContentLab = questionContentLab;

    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, questionLab.bottom+15, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
 
    
    ManagePassLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 40, 44)];
    ManagePassLab.text = @"答案";
    ManagePassLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ManagePassLab.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:ManagePassLab];
    
    
    _ManagePassWord = [[UITextField alloc] initWithFrame:CGRectMake(57, 0, kScreen_Width-57-12, 44)];
    _ManagePassWord.font = [UIFont systemFontOfSize:16];
    _ManagePassWord.secureTextEntry = YES;
    _ManagePassWord.placeholder = @"请输入你的答案";
    _ManagePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ManagePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_ManagePassWord addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:_ManagePassWord];
    
    
    _nextBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBt.frame = CGRectMake(12, baseView.bottom+25, kScreen_Width-24, 44);
    _nextBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _nextBt.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_nextBt setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBt.titleLabel.font = [UIFont systemFontOfSize:14];
    _nextBt.clipsToBounds = YES;
    _nextBt.layer.cornerRadius = 5.0;
    _nextBt.userInteractionEnabled = NO;
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
    
    [self adminQuestion];
}

//  获取密保问题
- (void)adminQuestion {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    [AFNetClient GET_Path:AdminQuestion completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            self.questionContentLab.text = [JSONDict objectForKey:@"Data"];
            
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
            
        }
    } failed:^(NSError *error) {
        
        [hud hide:YES];
        
        NSLog(@"------------->>>>>>%@",error);
    }];
}

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


-(void)nextAction:(UIButton *)bt{
    
    NSString *strURL = [NSString stringWithFormat:@"%@&Ask=%@&answer=%@",Validateanswer, self.questionContentLab.text, _ManagePassWord.text];
    
    [AFNetClient  POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            //            [WLRemindView showIcon:@"success"];
            QuestionChangePassword2VC *questionChangePassword2VC =[QuestionChangePassword2VC alloc];
            questionChangePassword2VC.mailText = [JSONDict objectForKey:@"Data"];
            [self.navigationController pushViewController:questionChangePassword2VC animated:YES];

            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        
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
