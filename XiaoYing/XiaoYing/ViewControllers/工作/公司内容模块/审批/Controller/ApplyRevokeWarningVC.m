//
//  ApplyRevokeWarningVC.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplyRevokeWarningVC.h"

@interface ApplyRevokeWarningVC ()
@property(nonatomic,strong)UIView *baseView;
@end

@implementation ApplyRevokeWarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    _baseView = [[UIView alloc] initWithFrame:CGRectZero];
    _baseView.layer.cornerRadius = 5;
    _baseView.clipsToBounds = YES;
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:lab];
    
    _baseView.frame = CGRectMake((kScreen_Width-250)/2.0, (kScreen_Height - 200) / 2, 250,(210+88)/2);
    lab.frame = CGRectMake(16, 10, _baseView.width-16*2, 95);
    lab.text = @"该申请已被撤销";

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _baseView.height-44, _baseView.width, 44);
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:btn];
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.frame.size.height - 44, _baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:lineView1];
    
}


- (void)btnAction:(UIButton *)btn {

     self.sureBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
