//
//  XYWorkAddPositionVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYWorkAddPositionVc.h"

#import "XYPositionViewController.h"

#import "XYWorkShowWrongVc.h"

#import "XYAddPositionSecondWrongVc.h"
#import "XYAddListVc.h"
#import "CompanyJobViewModel.h"

#import "XYExtend.h"

#define MAX_TEXTVIEW_LENGTH 140
#define MAX_TEXTFIELD_LENGTH 15

@interface XYWorkAddPositionVc ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)GCPlaceholderTextView * textView;

@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation XYWorkAddPositionVc
{
    MBProgressHUD *_waitHUD;  //waitHUD
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加职位";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self setupNav];
    [self setupUI];
    
    [self setupMonitor];
}


/**
 设置导航栏右按钮
 (saveButton)
 */
- (void)setupNav{
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * btnView = [[UIView alloc]initWithFrame:rightButton.frame];
    [btnView addSubview:rightButton];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)setupUI{
    
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
    self.textField.placeholder = @"输入职位名称";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:self.textField];
    
    

    UILabel * sectionLabel = [[UILabel alloc]init];
    [self.view addSubview:sectionLabel];
    sectionLabel.text = @"岗位职责";
    sectionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLabel.font = [UIFont systemFontOfSize:12];
    CGSize sectionSize = CGSizeMake(kScreen_Width, MAXFLOAT);
    CGSize sectionLabelSize = [sectionLabel sizeThatFits:sectionSize];
    sectionLabel.frame = CGRectMake(12, baseView.bottom + 15, sectionLabelSize.width, sectionLabelSize.height);
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionLabel.bottom + 7, kScreen_Width, 145)];
    [self.view addSubview:secondView];
    secondView.backgroundColor = [UIColor whiteColor];
    
    
    self.textView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(12, 12, kScreen_Width - 24, 145 - 38 )];
    self.textView.placeholder = @"输入内容";
    self.textView.delegate = self;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.placeholderColor = [UIColor colorWithHexString:@"#cccccc"];
    self.textView.realTextColor = [UIColor colorWithHexString:@"#333333"];
    self.textView.font = [UIFont systemFontOfSize:14];
    [secondView addSubview:self.textView];
    
    //到时候进行判断根据
    self.numberLabel = [[UILabel alloc]init];
    [secondView addSubview:self.numberLabel];
    self.numberLabel.text = @"140";
    self.numberLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(secondView.mas_right).offset(-12);
        make.bottom.equalTo(secondView.mas_bottom).offset(-12);
    }];
}

//通知中心的观察者注册
- (void)setupMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
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

#pragma mark method
-(void)saveButton{
    
    if ([self.textField.text isEqual:@""] ) {
        
        [MBProgressHUD showMessage:@"名称不能为空"];

    }else if ([self contransDataWithDelegate]){

        XYAddPositionSecondWrongVc * secondWrongVc = [[XYAddPositionSecondWrongVc alloc]init];
        secondWrongVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        secondWrongVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

        secondWrongVc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [self presentViewController:secondWrongVc animated:YES completion:nil];
        
    }else{
        
        //点击保存时，确保键盘已经收起
        [self.view endEditing:YES];
        
        //waitHUD
        _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSString *categoryIdStr = [NSString stringWithFormat:@"%@", self.categoryModel.categoryId];
        
        [CompanyJobViewModel addJobMessageWithCategoryId:categoryIdStr jobName:self.textField.text jobDescription:self.textView.text success:^(NSString *newJobId) {
            
            NSLog(@"新添加的职位ID为:%@", newJobId);
            
            NSArray  *controlArray = self.navigationController.childViewControllers;
            for (UIViewController * vc in controlArray) {
                
                if ([vc isKindOfClass:[XYAddListVc class]]) {
                    
                    XYAddListVc *addListVc = (XYAddListVc *)vc;
                    [addListVc refreshTableViewDataAndUI];
                    
                    //waitHUD
                    [_waitHUD hide:YES];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        } failed:^(NSError *error) {
            
            NSArray  *controlArray = self.navigationController.childViewControllers;
            for (UIViewController * vc in controlArray) {
                
                if ([vc isKindOfClass:[XYAddListVc class]]) {
                    
                    //waitHUD
                    [_waitHUD hide:YES];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        }];
 
    }
    
}

- (BOOL)contransDataWithDelegate
{
    if ([self.delegate respondsToSelector:@selector(contranstWithJobMessageByJobName:)]) {
        return [self.delegate contranstWithJobMessageByJobName:self.textField.text];
    }
    return NO;//如果委托对象那个没有实现这个方法，暂时默认可以添加
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
