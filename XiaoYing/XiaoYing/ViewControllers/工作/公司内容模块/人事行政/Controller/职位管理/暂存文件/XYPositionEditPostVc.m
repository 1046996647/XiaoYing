//
//  XYPositionEditPostVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYPositionEditPostVc.h"

#import "XYPositionDeletePositionReminderVc.h"

#import "XYPositionCanDeletePositionVc.h"

@interface XYPositionEditPostVc ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation XYPositionEditPostVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)initUI{
    
    UIView  * view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kScreen_Width, 44)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    
    NSString  *content = @"名称";
    CGSize contentSize = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, (44 - contentSize.height)/2, contentSize.width, contentSize.height)];
    [view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = content;
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake((contentSize.width + 24), 0, 100, 44)];
    [view addSubview:textField];
    textField.textColor = [UIColor lightGrayColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = self;
    textField.placeholder = @"输入职位名称";
    
    
    content = @"岗位职责";
    contentSize = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 100, contentSize.width, contentSize.height)];
    [view addSubview:secondLabel];
    secondLabel.font = [UIFont systemFontOfSize:16];
    secondLabel.textColor = [UIColor blackColor];
    secondLabel.text = content;
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 220, kScreen_Width, 145)];
    [self.view addSubview:textView];
    textView.backgroundColor = [UIColor orangeColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor blackColor];
    textView.textContainerInset = UIEdgeInsetsMake(12, 12, 0, 12);
    textView.delegate = self;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 20, 20)];
    [textView addSubview:numberLabel];
    numberLabel.text = @"12";
    numberLabel.font = [UIFont systemFontOfSize:10];
    
    UIButton * deleteBtn = [[UIButton alloc]init];
    [self.view addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@44);
    
    }];
    
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor redColor];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
}

-(void)clickDeleteBtn:(UIButton*)btn{
    
    
    //判断类别里面是否有人 有.删除不了 无.删除
    
    XYPositionDeletePositionReminderVc * deletePositionVc = [[XYPositionDeletePositionReminderVc alloc]init];
    deletePositionVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    deletePositionVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    deletePositionVc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self presentViewController:deletePositionVc animated:YES completion:nil];
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
