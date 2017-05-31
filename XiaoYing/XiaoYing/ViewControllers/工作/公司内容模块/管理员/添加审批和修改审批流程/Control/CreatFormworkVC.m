//
//  CreatFormworkVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CreatFormworkVC.h"
#import "TempModel.h"

@interface CreatFormworkVC ()<UITextViewDelegate>
{
    AppDelegate *app;
}

@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong) UITextView *textFView;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic, strong)UILabel *label;


@end

@implementation CreatFormworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishWay)];
    
    [self initUI];
    if ([self.title isEqualToString:@"新建范文"]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitWay)];
    }
    else {
        //返回按钮
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];// 加这个view为了限制点击的范围
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 30);
        //    backButton.backgroundColor = [UIColor redColor];
        [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
        //    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:backButton];
        //    [self.navigationController.navigationBar addSubview:backButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
        
        [self textViewDidChange:_textFView];
    }
    
    if (!_model) {
        _model = [[TempModel alloc] init];

    }
}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    
//    //隐藏标签栏
//    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app.tabvc hideCustomTabbar];
//}

//初始化UI控件
- (void)initUI{
    
    
    UIView *baseView;//标题
    UILabel *contentLab;//内容
    
    
    baseView = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(12, 12, 300, 44)];
    _titleField.placeholder = @"请输入范文标题";
    _titleField.text = _model.Title;
    _titleField.font = [UIFont systemFontOfSize:14];
    _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_titleField addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_titleField];
    
    self.textFView=[[UITextView alloc]initWithFrame:CGRectMake(0, baseView.bottom+12, kScreen_Width, 150)];
    self.textFView.delegate = self;
    self.textFView.text = _model.Content;
    self.textFView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textFView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(self.textFView.width-60-12, self.textFView.height-12-17, 60, 17)];
    _label.textAlignment = NSTextAlignmentRight;
    _label.text = @"300";
    _label.font = [UIFont systemFontOfSize:17];
    _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.textFView addSubview:_label];
    
    contentLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, 200, 26)];
    contentLab.text = @"请输入内容";
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.textColor = [UIColor colorWithHexString:@"#cccccc"];// 输入后#333333
    [self.textFView addSubview:contentLab];
    self.contentLab = contentLab;
    
    
}
//退出
- (void)exitWay{
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 返回
- (void)backAction {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


//完成
- (void)finishWay{
    
    [self.view endEditing:YES];
    
    if (_titleField.text.length == 0) {
        [MBProgressHUD showMessage:@"标题不能为空"];
        return;
    }
    if (_textFView.text.length == 0) {
        [MBProgressHUD showMessage:@"内容不能为空"];
        return;
    }

    //上传中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"上传中...";
    
    NSMutableDictionary *paramDic = [NSMutableDictionary  dictionary];
    NSString *tempStr = nil;
    if ([self.title isEqualToString:@"新建范文"]) {
        [paramDic  setValue:_titleField.text forKey:@"Title"];
        [paramDic  setValue:_textFView.text forKey:@"Content"];
        
        tempStr = AddTemp;
    }
    else {
        [paramDic  setValue:_model.Id forKey:@"iD"];
        [paramDic  setValue:_titleField.text forKey:@"Title"];
        [paramDic  setValue:_textFView.text forKey:@"Content"];
        
        tempStr = ModifyTemp;

    }
    
    
    [AFNetClient  POST_Path:tempStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            

            if ([self.title isEqualToString:@"新建范文"]) {
                _model.Id = JSONDict[@"Data"][@"Id"];
                _model.Title = _titleField.text;
                _model.Content = _textFView.text;

                if (_sendTempBlock) {
                    _sendTempBlock(_model);
                }
                [self dismissViewControllerAnimated:YES completion:nil];

            }
            else {
                _model.Title = _titleField.text;
                _model.Content = _textFView.text;
                [self.navigationController popViewControllerAnimated:YES];

            }

        }
        
    } failed:^(NSError *error) {
        
        [hud hide:YES];

        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
    
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
//    _model.Content = textView.text;
    if (textView.text.length > 0) {
        _contentLab.hidden = YES;
    } else {
        _contentLab.hidden = NO;
    }
    
    NSInteger count = 300 - textView.text.length;
    [_label setText:[NSString stringWithFormat:@"%ld",(long)count]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
