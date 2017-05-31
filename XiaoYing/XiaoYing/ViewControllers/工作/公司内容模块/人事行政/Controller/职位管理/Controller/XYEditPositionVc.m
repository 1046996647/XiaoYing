//
//  XYEditPositionVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYEditPositionVc.h"

#import "XYPositionCanDeletePositionVc.h"
#import "XYAddListVc.h"
#import "CompanyJobViewModel.h"

#import "XYExtend.h"

#define MAX_TEXTVIEW_LENGTH 140
#define MAX_TEXTFIELD_LENGTH 15

@interface XYEditPositionVc ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UITextView * textView;

@property(nonatomic,strong)UIButton * deleteBtn;

@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation XYEditPositionVc
{
    MBProgressHUD *_waitHUD; //waitHUD
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑职位";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self setupNav];
    [self setupUI];
    
    [self setupMonitor];
}

- (void)setupMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popTheSuperViewController) name:@"popTheSuperViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HSWordLimit computeWordCountWithTextView:self.textView warningLabel:self.numberLabel maxNumber:MAX_TEXTVIEW_LENGTH];
}

/**
 设置导航栏右按钮
 (clickSaveButton)
 */
- (void)setupNav{
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * btnView = [[UIView alloc]initWithFrame:rightButton.frame];
    [btnView addSubview:rightButton];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = right;
    
}

//加载ui界面
- (void)setupUI{
    
    //职位名称
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    NSString *content = @"名称";
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = content;
    titleLabel.font = [UIFont systemFontOfSize:16];
    CGSize size = CGSizeMake(kScreen_Width, MAXFLOAT);
    CGSize titleSize = [titleLabel sizeThatFits:size];
    
    titleLabel.frame = CGRectMake(12, 0, titleSize.width, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:titleLabel];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+ 12, 0, kScreen_Width - titleLabel.width - 12, 44)];
    self.textField.text = self.jobModel.jobName;
    self.textField.placeholder = @"输入职位名称";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:self.textField];
    
    
    //岗位职责
    UILabel * sectionLabel = [[UILabel alloc]init];
    sectionLabel.text = @"岗位职责";
    sectionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLabel.font = [UIFont systemFontOfSize:12];
    CGSize sectionSize = CGSizeMake(kScreen_Width, MAXFLOAT);
    CGSize sectionLabelSize = [sectionLabel sizeThatFits:sectionSize];
    sectionLabel.frame = CGRectMake(12, baseView.bottom + 15, sectionLabelSize.width, sectionLabelSize.height);
    [self.view addSubview:sectionLabel];
    
    
    //用于放置UITextView的白色背景
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionLabel.bottom + 7, kScreen_Width, 145)];
    secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondView];
    
    //岗位职责描述
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 12, kScreen_Width - 24, 145 - 38 )];
    self.textView.text = self.jobModel.jobDescription? : @"";
    self.textView.delegate = self;
    self.textView.textColor = [UIColor colorWithHexString:@"#333333"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [secondView addSubview:self.textView];
    
    //到时候进行判断根据
    self.numberLabel = [[UILabel alloc]init];
    [secondView addSubview:self.numberLabel];
    self.numberLabel.text = [NSString stringWithFormat:@"%d",MAX_TEXTVIEW_LENGTH];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(secondView.mas_right).offset(-12);
        make.bottom.equalTo(secondView.mas_bottom).offset(-12);
    }];
    
    
    //删除按钮(clickDeleteBtn)
    NSInteger y = (kScreen_Height -44 - 64);
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, y, kScreen_Width, 44)];
    [self.deleteBtn setBackgroundColor:[UIColor redColor]];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
     self.deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];

    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.deleteBtn];

    
}

//点击保存按钮
-(void)clickSaveButton{
    
    //点击保存时，确保键盘已经收起
    [self.view endEditing:YES];
    
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *jobIdStr = [NSString stringWithFormat:@"%@", self.jobModel.jobId];
    NSString *categoryIdStr = [NSString stringWithFormat:@"%@", self.categoryModel.categoryId];
    
    [CompanyJobViewModel editJobMessageWithcategoryId:categoryIdStr jobId:jobIdStr newJobName:self.textField.text newJobDescription:self.textView.text success:^(id JSONDict) {
        
        NSArray  *controlArray = self.navigationController.childViewControllers;
        for (UIViewController * vc in controlArray) {
            
            if ([vc isKindOfClass:[XYAddListVc class]]) {
                
                XYAddListVc *addListVc = (XYAddListVc *)vc;
                [addListVc refreshTableViewDataAndUI];
            }
        }
        
        //waitHUD
        [_waitHUD hide:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(NSError *error) {
        
        //waitHUD
        [_waitHUD hide:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

//通知方法
-(void)popTheSuperViewController{
    
    NSArray  *controlArray = self.navigationController.childViewControllers;
    for (UIViewController * vc in controlArray) {
        
        if ([vc isKindOfClass:[XYAddListVc class]]) {
            
            XYAddListVc *addListVc = (XYAddListVc *)vc;
            [addListVc refreshTableViewDataAndUI];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Notification Method
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
    [HSWordLimit computeWordCountWithTextView:textView warningLabel:self.numberLabel maxNumber:MAX_TEXTVIEW_LENGTH];
}

- (void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    [HSWordLimit computeWordCountWithTextField:textField maxNumber:MAX_TEXTFIELD_LENGTH];
}

//删除
-(void)clickDeleteBtn{

    XYPositionCanDeletePositionVc * deletePositionVc = [[XYPositionCanDeletePositionVc alloc]init];
    deletePositionVc.jobModel = self.jobModel;
    
    deletePositionVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    deletePositionVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    deletePositionVc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self presentViewController:deletePositionVc animated:YES completion:nil];
    
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

