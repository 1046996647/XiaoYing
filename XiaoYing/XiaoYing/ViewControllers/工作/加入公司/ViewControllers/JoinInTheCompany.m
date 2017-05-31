//
//  JoinInTheCompany.m
//  XiaoYing
//
//  Created by GZH on 16/8/8.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "JoinInTheCompany.h"
#import "CreateMyCompanyView.h"
#import "JoinTheCompanyView.h"

@interface JoinInTheCompany ()

@property (nonatomic, strong)CreateMyCompanyView *createVC;
@property (nonatomic, strong)JoinTheCompanyView *joinVC;

@end

@implementation JoinInTheCompany




- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBasic];
    
}



- (void)initBasic {
    self.title = @"加入公司";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    
    _createVC = [[CreateMyCompanyView alloc]initWithFrame:self.view.bounds];
    _createVC.joinVC.frame = CGRectMake(12, _createVC.backView.top + 10, kScreen_Width - 24, kScreen_Height - _createVC.backView.top - 64 - 12);
    [self.view addSubview:_createVC];

}









- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
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
