//
//  StepsVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "StepsVC.h"
#import "FrameManagerVC.h"
#import "StepsView.h"
@interface StepsVC ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong)StepsView *tableView;

@end

@implementation StepsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initBasic];
    
    [self initBottomView];
    
}

- (void)initBasic {

    self.title = @"组织架构管理";
    
    _tableView = [[StepsView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    
 
}


- (void)initBottomView {
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:topView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    [btn setTitle:@"添加子单元" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(addChildUnitAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:btn];
}






- (void)addChildUnitAction {
    NSLog(@"添加子单元");
    FrameManagerVC *frameVC = [[FrameManagerVC alloc]init];
    frameVC.type = @"隐藏删除按钮";
    [self.navigationController pushViewController:frameVC animated:YES];
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
