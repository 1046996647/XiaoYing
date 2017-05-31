//
//  VisibleRangeVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/4.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "VisibleRangeVC.h"

@interface VisibleRangeVC ()

@end

@implementation VisibleRangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBasic];
}

- (void)setUpBasic {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.title = @"可见范围";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];

}

- (void)saveAction {
     NSLog(@"保存");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
