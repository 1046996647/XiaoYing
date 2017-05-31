//
//  MakeDeleteAction.m
//  XiaoYing
//
//  Created by GZH on 16/8/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "MakeDeleteAction.h"

@implementation MakeDeleteAction



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeview)];
    [self.view addGestureRecognizer:tap];
}

- (void)removeview {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)initView {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 3;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:lab];
    
    baseView.frame = CGRectMake((kScreen_Width-270)/2.0, (kScreen_Height - 200) / 2, 270, 100);
    lab.frame = CGRectMake(12, 12, baseView.width - 12 * 2, baseView.height - 12 - 44 - .5);
    
    lab.text = @"是否确定删除 '新建介绍'? ";
    
    NSArray *titleArr = @[@"确定", @"取消"];
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
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2 - 0.5, baseView.height - 44, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView2];
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.frame.size.height - 44, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
    
}

- (void)btnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteSectionAndRow" object:_labelTitle];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
