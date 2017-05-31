//
//  AddChildCompanyVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AddChildCompanyVC.h"
#import "DetailOfChildCompany.h"
#import "GetSecretNumVC.h"
#import "MBProgressHUD.h"
@interface AddChildCompanyVC ()

@property (nonatomic, strong)DetailOfChildCompany *childCompanyView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *searchButton;
@property (nonatomic, strong)UIButton *sendNumButton;
@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UIImageView *moveImage;//推出的图片
@property (nonatomic, strong)UIView *textBackView;

@end

@implementation AddChildCompanyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self searchAgainAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _childCompanyView = [[DetailOfChildCompany alloc]init];
    
    [self initBasic];
    [self initUI];
   
}



- (void)initBasic {
    self.title = @"添加其他公司为子公司";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];

    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setTitle:@"取消" forState:UIControlStateNormal];

}


- (void)initUI {

    _textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 44)];
    _textBackView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_textBackView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width, 44)];
    _textField.placeholder = @"请输入对方公司邀请码";
    _textField.backgroundColor = [UIColor clearColor];
   
    [_textField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    [_textBackView addSubview:_textField];
    
    _searchButton = [self Z_createButtonWithTitle:@"搜索" buttonFrame:CGRectMake(12, _textBackView.bottom + 15, kScreen_Width - 24, 44)];
    [_searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
    _sendNumButton = [self Z_createButtonWithTitle:@"发送验证" buttonFrame:CGRectMake(12, _textBackView.bottom + 50 + 142, kScreen_Width - 24, 44)];
    _sendNumButton.hidden = YES;
    [_sendNumButton setTitle:@"发送验证" forState:UIControlStateNormal];
    [_sendNumButton addTarget:self action:@selector(PostCodeToCompanyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendNumButton];
    
    //搜索框上边的遮盖
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 44)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.2;
    _coverView.hidden = YES;
    [self.view addSubview:_coverView];

    
}
//输入验证码，搜索公司
- (void)SearchCompanyWithCodeAction {
    NSString *strURL = [SearchCompanyWithCodeURl stringByAppendingFormat:@"&CompanyCode=%@",_textField.text];
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
            
            [self ParserNetData:JSONDict];
            //界面的重新布局
            [self uiOfAfterSearchAction];
        }else {
            [MBProgressHUD showMessage:@"对不起，没有这个公司" toView:self.view];
        }
    } failed:^(NSError *error) {
         NSLog(@"---------------%@",error);
    }];
    
    
}


//数据解析
- (void)ParserNetData:(id)respondseData {
    NSMutableDictionary *Dic = respondseData[@"Data"];
    _childCompanyView.companyLabel.text = Dic[@"CompanyName"];
    _childCompanyView.label.text = Dic[@"BossName"];
    [_childCompanyView.imageView sd_setImageWithURL:[NSURL URLWithString:Dic[@"CompanyLOGFormatUrl"]]];
}





- (void)searchAction:(UIButton *)sender {
    if ([_textField.text isEqual:@""]) {
        
        [self sendCodeAction:sender];
    }else{
    
        //textField取消第一响应
        [_textField resignFirstResponder];
    
        [self SearchCompanyWithCodeAction];
        
    }
}

//搜索成功之后界面的重新布局
- (void)uiOfAfterSearchAction {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"重新搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAgainAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
    

        
        _coverView.hidden = NO;
        
        _searchButton.hidden = YES;
        
        _sendNumButton.hidden = NO;
        
        _childCompanyView.frame = CGRectMake((kScreen_Width - 270) / 2, _textBackView.bottom + 25, 0, 0);
        [self.view addSubview:_childCompanyView];
}


-(void)searchAgainAction {
    self.navigationItem.rightBarButtonItem = nil;

    _textField.text = @"";
    _coverView .hidden = YES;
    
    _searchButton.hidden = NO;
    
    _sendNumButton.hidden = YES;
    
    [_childCompanyView removeFromSuperview];

}

- (void)sendCodeAction:(UIButton *)sender {
     NSLog(@"发送验证");
        _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noverification"]];
         [_moveImage setFrame:CGRectMake((kScreen_Width - 190) / 2, (kScreen_Height - 90) / 2 - 100, 190, 90)];
        [self imageAnimalAction];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(toMakePhotoHiddenAction) userInfo:nil repeats:nil];
}

- (void)PostCodeToCompanyAction {
    NSString *strURL = [PostCodeToCompanyURl stringByAppendingFormat:@"&ComapnyCode=%@",_textField.text];
    [AFNetClient POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@1]) {
    
            _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sended2"]];
            [_moveImage setFrame:CGRectMake((kScreen_Width - 125) / 2, (kScreen_Height - 110) / 2 - 100, 125, 110)];
            [self imageAnimalAction];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(toInputSecretAction) userInfo:nil repeats:nil];
            
        }
        NSLog(@"_______________________%@", JSONDict);
    } failed:^(NSError *error) {
         NSLog(@"_______________________%@", error);
    }];

}


//转移成功之后显示的图片
- (void)imageAnimalAction {
    [self.view addSubview:_moveImage];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:1.0];
    [UIView commitAnimations];
}


- (void)toMakePhotoHiddenAction {
    [_moveImage setHidden:YES];
}

- (void) toInputSecretAction {
    [_moveImage setHidden:YES];
    GetSecretNumVC *getVC = [[GetSecretNumVC alloc]init];
    getVC.tempStr = _textField.text;
    [self.navigationController pushViewController:getVC animated:YES];
}



#pragma mark --button--
- (UIButton *)Z_createButtonWithTitle:(NSString *)title
                          buttonFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    return button;
}


- (void)backAction {
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
