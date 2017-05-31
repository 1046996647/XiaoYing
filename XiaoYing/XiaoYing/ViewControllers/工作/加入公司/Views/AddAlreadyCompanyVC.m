//
//  AddAlreadyCompanyVC.m
//  XiaoYing
//
//  Created by GZH on 16/8/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "AddAlreadyCompanyVC.h"
#import "AddAlreadyCompanyView.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CompanyOfApplyVC.h"
#import "MBProgressHUD.h"
@interface AddAlreadyCompanyVC ()
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic, strong)AddAlreadyCompanyView *addAlreadyCompany;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *searchButton;
@property (nonatomic, strong)UIButton *sendNumButton;
@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UIImageView *moveImage;//推出的图片
@property (nonatomic, strong)UIView *textBackView;
@property (nonatomic)BOOL keyboardIsVisible;
@end

@implementation AddAlreadyCompanyVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBasic];
    [self initUI];
    
    _addAlreadyCompany = [[AddAlreadyCompanyView alloc]init];
    
    
}

- (void)keyboardLisition {
    // 键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)initBasic {
    self.title = @"加入已有公司";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[backItem];
}


- (void)initUI {
    
    _textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 44)];
    _textBackView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_textBackView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width, 44)];
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.placeholder = @"请输入公司ID";
    _textField.backgroundColor = [UIColor clearColor];
    
    [_textField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    [_textBackView addSubview:_textField];
    
    _searchButton = [self Z_createButtonWithTitle:@"搜索" buttonFrame:CGRectMake(12, _textBackView.bottom + 15, kScreen_Width - 24, 44)];
    [_searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.tag = 88;
    [self.view addSubview:_searchButton];
    
    _sendNumButton = [self Z_createButtonWithTitle:@"发送请求" buttonFrame:CGRectMake(12, _textBackView.bottom + 50 + 255, kScreen_Width - 24, 44)];
    _sendNumButton.hidden = YES;
    [_sendNumButton addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendNumButton];
    
    //搜索框上边的遮盖
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 44)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.2;
    _coverView.hidden = YES;
    [self.view addSubview:_coverView];
    
}


- (void)searchAction:(UIButton *)sender {
    if ([_textField.text isEqual:@""]) {
//        _searchButton.userInteractionEnabled = NO;
        [self sendCodeAction:sender];
    }else{
        
        [self SearchCompanyWithIDAction];
    }
}

//搜索公司ID   
- (void)SearchCompanyWithIDAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"搜索中...";
    NSString *URLstr = [SearchCompanyURl stringByAppendingFormat:@"&CompanyCode=%@",self.textField.text];

    [AFNetClient GET_Path:URLstr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if ([code isEqual:@0]) {
          NSLog(@"搜索公司ID>>成功>>%@",JSONDict);
            
            //textField取消第一响应
            [_textField resignFirstResponder];
          
            [self ParserNetData:JSONDict];
            
            //界面的重新布局
            [self uiOfAfterSearchAction];
            [self keyboardLisition];
            
        }else {
            [_hud setHidden:YES];
            [MBProgressHUD showMessage:@"对不起,没有这个公司" toView:self.view];
        }
    } failed:^(NSError *error) {
          NSLog(@">>>>>>%@",error);
    }];
}

//数据解析  ;
- (void)ParserNetData:(id)respondseData {
    NSMutableDictionary *Dic = respondseData[@"Data"];
    if (![Dic[@"CompanyName"] isKindOfClass:[NSNull class]]) {
       _addAlreadyCompany.companyLabel.text = Dic[@"CompanyName"];
    }
    if (![Dic[@"BossName"] isKindOfClass:[NSNull class]]) {
        _addAlreadyCompany.label.text = [NSString stringWithFormat:@"创建者 :  %@",Dic[@"BossName"]];
    }
    if (![Dic[@"CompanyLOGFormatUrl"] isKindOfClass:[NSNull class]]) {
        NSString *iconStr = [NSString replaceString:Dic[@"CompanyLOGFormatUrl"] Withstr1:@"100" str2:@"100" str3:@"c"];
        [_addAlreadyCompany.imageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    }
    [_hud setHidden:YES];
}

- (void)uiOfAfterSearchAction {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"重新搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAgainAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
    
    _coverView.hidden = NO;
    
    _searchButton.hidden = YES;
    
    _sendNumButton.hidden = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToDetailView)];
    _addAlreadyCompany.frame = CGRectMake((kScreen_Width - 270) / 2, _textBackView.bottom + 25, 270, 255);
    [_addAlreadyCompany addGestureRecognizer:tap];
    [self.view addSubview:_addAlreadyCompany];
}

- (void)pushToDetailView {
    CompanyOfApplyVC *companyVC = [[CompanyOfApplyVC alloc]init];
    companyVC.companyCode = self.textField.text;
    companyVC.title = @"我申请加入的公司";
    [self.navigationController pushViewController:companyVC animated:YES];
}

-(void)searchAgainAction {
    if (_keyboardIsVisible == YES) {
        self.view.frame = CGRectMake(0, 0+64, kScreen_Width, kScreen_Height);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    self.navigationItem.rightBarButtonItem = nil;
    
    _textField.text = @"";
    
    _addAlreadyCompany.textView.text = @"";
    _addAlreadyCompany.placeholder.hidden = NO;
    
    _coverView .hidden = YES;
    
    _searchButton.hidden = NO;
    
    _sendNumButton.hidden = YES;
    
    [_addAlreadyCompany removeFromSuperview];
    
}

- (void)sendRequestAction {
    [_moveImage setHidden:YES];
    if ([_refershOrNo isEqualToString:@"YES"]) {

        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefershTabelViewOfApply" object:nil];
    }
    self.requestSuccess(_textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

//发送请求
- (void)sendRequestWithURLAction {

    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"发送中...";
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_textField.text forKey:@"companyCode"];
    [paraDic setObject:_addAlreadyCompany.textView.text forKey:@"remark"];
    [AFNetClient POST_Path:SendRequestURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        [_hud setHidden:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            NSLog(@"发送验证>>成功__>>%@",JSONDict);
            
            
            _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sended2"]];
            [_moveImage setFrame:CGRectMake((kScreen_Width - 125) / 2, (kScreen_Height - 110) / 2 - 100, 125, 110)];
            [self imageAnimalAction];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendRequestAction) userInfo:nil repeats:nil];
            
            
        }else {
            
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];

        }

    } failed:^(NSError *error) {
         NSLog(@">>>>>>%@",error);
    }];
}


- (void)sendCodeAction:(UIButton *)sender {
    if (sender.tag == 88) {
        //搜索不能为空
        
        [MBProgressHUD showMessage:@"公司ID不可为空！" toView:self.view];
        /*------------------暂时没有合适图片，后期有图片再改-------------------*/
//        _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noverification"]];
//        [_moveImage setFrame:CGRectMake((kScreen_Width - 190) / 2, (kScreen_Height - 90) / 2 - 100, 190, 90)];
//        [self imageAnimalAction];
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(toMakePhotoHiddenAction) userInfo:nil repeats:nil];
        
        
    }else {
        //发送请求
        [self sendRequestWithURLAction];
    }
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
    _searchButton.userInteractionEnabled = YES;
    [_moveImage setHidden:YES];
//    [self popViewController:@"JoinInTheCompany"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    if (_addAlreadyCompany.textView.text.length == 0) {
        _addAlreadyCompany.placeholder.hidden = NO;
    }
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

//- (void)changeContentViewPosition:(NSNotification *)notification{
//    NSDictionary *userInfo = [notification userInfo];
////    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
////    CGFloat keyBoardEndY = value.CGRectValue.origin.y / 2;
//    
//    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
////  NSLog(@"-------------------------------------------------------%f", keyBoardEndY);
//    [UIView animateWithDuration:duration.doubleValue animations:^{
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationCurve:[curve intValue]];
//        if ([notification.name isEqual:UIKeyboardWillShowNotification] ) {
//            NSLog(@"--------00" );
//            self.view.frame = CGRectMake(0, -85, kScreen_Width, kScreen_Height);
//        }else {
//            NSLog(@"--------11" );
//        }
//        
//    }];
//}

#pragma mark - keyboard
- (void)keyboardWillHide:(NSNotification *)noti {
    
    self.view.frame = CGRectMake(0, 0+64, kScreen_Width, kScreen_Height);

}

- (void)keyboardWillShow:(NSNotification *)noti {
    self.view.frame = CGRectMake(0, -90, kScreen_Width, kScreen_Height);

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

- (id) init {
    self = [super init];
    if (self)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
        _keyboardIsVisible = NO;
    }
    return self;
}

- (void)keyboardDidShow
{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    _keyboardIsVisible = NO;
}




@end
