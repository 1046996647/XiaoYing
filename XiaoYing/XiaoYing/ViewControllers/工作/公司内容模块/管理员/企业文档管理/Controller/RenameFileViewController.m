//
//  RenameFileViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 16/11/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "RenameFileViewController.h"
#import "DocumentViewModel.h"

@interface RenameFileViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *field;

@end

@implementation RenameFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)setupViews
{
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake((kScreen_Width - 270) / 2, (kScreen_Height - 131) / 2 - 100, 270,131);
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 270, 16)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"重命名";
    [baseView addSubview:titleLabel];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(8, titleLabel.bottom + 12, baseView.width-8*2, 30)];
    field.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    field.delegate = self;
    field.layer.cornerRadius = 5;
    field.clipsToBounds = YES;
    field.clearButtonMode = UITextFieldViewModeAlways;
    [field becomeFirstResponder];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.font = [UIFont systemFontOfSize:16];
    field.textColor = [UIColor colorWithHexString:@"#333333"];
    field.placeholder = @"请重命名";
    field.text = self.currentFileName;
    [baseView addSubview:field];
    self.field = field;
    
    NSArray *titleArr = @[@"确定", @"取消"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(baseView.width/2.0), baseView.height-44, baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.height-43.5, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2 - 0.5, lineView1.bottom, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView2];
}

//按钮点击事件
- (void)btnAction:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        
        NSLog(@"点击确定按钮");
        if (self.field.text.length <= 0) {
            [MBProgressHUD showMessage:@"文件名称不能为空"];
        }else {
            
            [DocumentViewModel renameFileWithOldFileId:self.oldFileId newFileName:self.field.text success:^(NSDictionary *dataList) {
                
                NSLog(@"文件重命名成功:%@", dataList);
                [self.field resignFirstResponder];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } failed:^(NSError *error) {
                
                NSLog(@"文件重命名失败:%@", error);
            }];
            
        }
        
    }
    else {
        [self.field resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[textField selectAll:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

@end
