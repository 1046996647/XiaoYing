//
//  FileNewController.m
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NewViewVC.h"


@interface NewViewVC ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *field;



@end

@implementation NewViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    
    
}

- (void)initViews
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
    titleLabel.text = self.markText;
    [baseView addSubview:titleLabel];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(8, titleLabel.bottom + 12, baseView.width-8*2, 30)];
    field.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    field.delegate = self;
    field.layer.cornerRadius = 5;
    field.clipsToBounds = YES;
    field.placeholder = self.placeholderText;
    field.text = self.content;
    field.clearButtonMode = UITextFieldViewModeAlways;
    [field becomeFirstResponder];
    field.font = [UIFont systemFontOfSize:16];
    field.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:field];
    self.field = field;
    
//    if ([self.markText isEqualToString:@"新建文件夹"]) {
//        titleLabel.text = @"新建文件夹";
//        field.placeholder = @"请输入文件夹名";
//        
//    }
//    else {
//        titleLabel.text = @"重命名";
//        field.placeholder = @"请重命名";
//        field.text = self.currentText;
//    }
    
    NSArray *titleArr = @[@"确定",@"取消"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(baseView.width/2.0), baseView.height-44, baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
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
    [self.view endEditing:YES];
    if (btn.tag == 0) {
        
        if (self.clickBlock) {
            self.clickBlock(self.field.text);
        }

    }
    else {
        
        [self.field resignFirstResponder];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - UITextFieldDelegate


//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    return NO;
//}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
////    [textField selectAll:self];
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    return YES;
//}

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
