//
//  ApplyVoucherDetailVC.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/1.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplyVoucherDetailVC.h"
#import "ApplyVoucherDetailView.h"
@interface ApplyVoucherDetailVC ()

@end

@implementation ApplyVoucherDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"凭证详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    ApplyVoucherDetailView *detailView = [[ApplyVoucherDetailView alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width - 20, 100)];
    [self.view addSubview:detailView];
    detailView.model = self.model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
