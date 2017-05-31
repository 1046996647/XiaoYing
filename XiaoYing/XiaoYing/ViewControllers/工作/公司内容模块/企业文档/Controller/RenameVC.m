//
//  RenameVC.m
//  XiaoYing
//
//  Created by ZWL on 16/7/14.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "RenameVC.h"

@interface RenameVC ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *field;


@end

@implementation RenameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];

}

- (void)initViews
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-250)/2.0, 170/2.0, 250,130)];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, baseView.width, 16)];
    //    titleLab.text = self.markText;
    titleLab.text = @"重命名";
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:titleLab];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(8, titleLab.bottom+12, baseView.width-8*2, 30)];
    field.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    field.placeholder = @"请重命名";
    field.text = self.currentText;
    field.layer.cornerRadius = 5;
    field.clipsToBounds = YES;
    field.clearButtonMode = UITextFieldViewModeAlways;
    [field becomeFirstResponder];
    field.font = [UIFont systemFontOfSize:16];
    field.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:field];
    self.field = field;
    
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
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.height-44, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2.0, lineView1.top, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView2];
}


//按钮点击事件
- (void)btnAction:(UIButton *)btn
{
    
    if (btn.tag == 0) {
        
        if (self.fileRenameBlock) {
            self.fileRenameBlock(self.field.text);
        }
    }
    
    [self.field resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];


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
