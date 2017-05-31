//
//  SecurityManageMent.m
//  XiaoYing
//
//  Created by GZH on 16/8/10.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "SecurityManageMent.h"
#import "MBProgressHUD.h"
#import "PushViewOfSecretManageView.h"
@interface SecurityManageMent ()<UITextFieldDelegate>

@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, strong)UITextField *textfield1;
@property (nonatomic, strong)UITextField *textfield2;
@property (nonatomic, strong)UITextField *textfield3;
@property (nonatomic, strong)UITextField *textfield4;


@end

@implementation SecurityManageMent

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initUI];
    [self initBasic];
    [self initData];
    
}

- (void)initData {

}

- (void)initBasic {
    self.title = @"设置管理密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    

}

- (void)initUI {
    UILabel *upLabel = [self Z_createLabelWithTitle:@"安全问题有助于找回管理里密码" buttonFrame:CGRectMake(0, 20, kScreen_Width, 12) textFont:12 colorStr:@"#848484" aligment:NSTextAlignmentCenter];
    [self.view addSubview:upLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + 12 + 15, kScreen_Width, 44.5 * 4)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    NSArray *array = @[@"安全问题", @"答案", @"管理密码", @"确认密码"];
    NSArray *array1 = @[@"请输入12字以内安全问题", @"请输入12字以内回答", @"请输入6位以上管理密码", @"请重新输入管理密码"];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [self Z_createLabelWithTitle:array[i] buttonFrame:CGRectMake(12, 44.5 * i, 70, 44) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
        [backView addSubview:label];
        
        UILabel *lineLabel = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake(0, 44 + 44.5 * i, kScreen_Width, 0.5) textFont:0.5 colorStr:@"#d5d7dc" aligment:NSTextAlignmentLeft];
        //lineLabel.backgroundColor = [UIColor redColor];
        [backView addSubview:lineLabel];
        

    }
  
    _textfield1 = [self Z_createTextlFieldWithPlaceHolder:array1[0] buttonFrame:CGRectMake(82 + 12, 0, kScreen_Width - 82 - 24 , 44)];
    _textfield1.delegate = self;
    [backView addSubview:_textfield1];
    
    _textfield2 = [self Z_createTextlFieldWithPlaceHolder:array1[1] buttonFrame:CGRectMake(82 + 12, 44.5, kScreen_Width - 82 - 24, 44)];
    _textfield2.delegate = self;
    [backView addSubview:_textfield2];
    
    _textfield3 = [self Z_createTextlFieldWithPlaceHolder:array1[2] buttonFrame:CGRectMake(82 + 12, 44.5 * 2, kScreen_Width - 82 - 24, 44)];
    _textfield3.delegate = self;
    _textfield3.secureTextEntry = YES;
    [backView addSubview:_textfield3];
    
    _textfield4 = [self Z_createTextlFieldWithPlaceHolder:array1[3] buttonFrame:CGRectMake(82 + 12, 44.5 * 3, kScreen_Width - 82 - 24, 44)];
    _textfield4.delegate = self;
    _textfield4.secureTextEntry = YES;
    [backView addSubview:_textfield4];
    
    _sureButton = [self Z_createButtonWithTitle:@"确定" buttonFrame:CGRectMake(12, backView.bottom + 25 , kScreen_Width - 24, 44) colorStr:@"#f99740"];
    _sureButton.layer.cornerRadius = 5.0;
    _sureButton.layer.masksToBounds = YES;
    [_sureButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];

}


- (void)makeSureAction {
    NSLog(@"确定");

    [self.view endEditing:YES];
    [self makeSureRightOrWrong];

    
}

- (void)makeSureRightOrWrong {
    if ([_textfield1.text isEqualToString:@""]||[_textfield2.text isEqualToString:@""]||[_textfield3.text isEqualToString:@""]||[_textfield4.text isEqualToString:@""]) {
        
        [MBProgressHUD showMessage:@"请您输入完信息，谢谢" toView:self.view];
        return;
    }
    if (![RegexTool judgePassWordLegal:_textfield3.text]) {
        [MBProgressHUD showMessage:@"密码不符合要求" toView:self.view];
        return;
    }
    if (![_textfield3.text isEqualToString:_textfield4.text]) {
        [MBProgressHUD showMessage:@"两次密码输入不一致" toView:self.view];
        return;
    }
    [self sendRequestWithURLAction];
    
}

//创建公司和默认部门
- (void)sendRequestWithURLAction {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"创建中...";
    
//     NSLog(@"++++++++++++++++++++++++%@+++++%@+++%lu++%lu", _arrayDescriptionID, _cardIDArray, _arrayDescriptionID.count, _cardIDArray.count);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];

    [paraDic setValue:@"" forKey:@"parentId"];
    [paraDic setValue:_logoURL forKey:@"lOGFormatUrl"];
    [paraDic setValue:_name forKey:@"name"];
    [paraDic setValue:_stockholders forKey:@"stockholders"];
    [paraDic setValue:_mastPhones forKey:@"mastPhones"];
    [paraDic setValue:_reservePhones forKey:@"reservePhones"];
    [paraDic setValue:_url forKey:@"url"];
    [paraDic setValue:_address forKey:@"address"];
    [paraDic setValue:_textfield1.text forKey:@"question"];
    [paraDic setValue:_textfield2.text forKey:@"answer"];
    [paraDic setValue:_textfield3.text forKey:@"password"];
    [paraDic setValue:@"" forKey:@"province"];
    [paraDic setValue:@"" forKey:@"city"];
    [paraDic setValue:_arrayDescriptionID forKey:@"descriptions"];
    [paraDic setValue:_cardIDArray forKey:@"certificates"];

    [AFNetClient POST_Path:CreateCompanyURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        NSLog(@"++++++++++创建公司>>成功——————%@", JSONDict);
        if ([code isEqual:@0]) {
          
            
            [UserInfo saveCompanyId:JSONDict[@"Data"][@"CompanyCode"]];
            [UserInfo savecompanyName:JSONDict[@"Data"][@"CompanyName"]];
            [UserInfo saveTopLeaderOfCompany:JSONDict[@"AdminProfileId"]];
            [UserInfo saveUserRole:JSONDict[@"Data"][@"Role"]];
            
            [UserInfo saveJoinCompany_YesOrNo:@"0"];

            [self switchCompany:JSONDict[@"Data"][@"CompanyCode"]];
            PushViewOfSecretManageView *pushView = [[PushViewOfSecretManageView alloc]init];
            NSString *companyID = [NSString stringWithFormat:@"创建成功 , 您的公司ID是 : %@ , 是否前往综合管理完善企业信息 ?", JSONDict[@"Data"][@"CompanyCode"]];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: companyID];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#02bb00"] range:NSMakeRange(17 , 5)];
            pushView.upLabel.attributedText = str;
            [self.view addSubview:pushView];
         
            [hud hide:YES];
        }else {
            [hud hide:YES];
            [MBProgressHUD showError:@"创建公司失败" toView:self.view];

        }
    } failed:^(NSError *error) {
        NSLog(@"---------------------->>>>>>%@",error);
    }];
}

// 切换公司
- (void)switchCompany:(NSString *)companyCode {
    NSString *strURL = [SwitchCompany stringByAppendingFormat:@"&TargetCompanyId=%@", companyCode];
    [AFNetClient  POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        //          NSLog(@"---------------------------%@+++",JSONDict);
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
        }
        
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark --button--  --label--
- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame
                           textFont:(CGFloat)font
                           colorStr:(NSString *)colorStr
                           aligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithHexString:colorStr];
    label.textAlignment = aligment;
    return label;
}

- (UIButton *)Z_createButtonWithTitle:(NSString *)title
                          buttonFrame:(CGRect)frame
                             colorStr:(NSString *)colorStr{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithHexString:colorStr];
    return button;
}

- (UITextField *)Z_createTextlFieldWithPlaceHolder:(NSString *)placeHolder
                                       buttonFrame:(CGRect)frame {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textColor = [UIColor colorWithHexString:@"#333333"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleNone;
    
    return textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 12) {
        
        textField.text = [toBeString substringToIndex:12];
        
        return NO;
    }
    return  YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"--------00" );
    [self.view endEditing:YES];
}

- (void)goBackAction {
    [self.navigationController popViewControllerAnimated:YES];
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
