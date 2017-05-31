//
//  DoStatisticsVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DoStatisticsVC.h"
#import "AccordingToDepartmentView.h"
#import "AccordingToTimeView.h"
#import "HistorySignVC.h"
@interface DoStatisticsVC ()
@property (nonatomic,strong)UIView *headView;//头
@property (nonatomic,strong)UIButton *timeBt;//按时间
@property (nonatomic,strong)UIButton *departmentBt;//按照部门
@property (nonatomic,strong)UIView *viewLine;//下面的线
@property (nonatomic,strong)AccordingToDepartmentView *departmentView;
@property (nonatomic,strong)AccordingToTimeView *timeView;
@end

@implementation DoStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(DeriveWay)];
    
    
    [self initUI];
}
//导出的方法
- (void)DeriveWay{
    HistorySignVC *historyVC = [[HistorySignVC alloc] init];
    historyVC.title = @"历史签到";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:historyVC animated:YES];
}
//初始化UI控件
- (void)initUI{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreen_Width, 1)];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.headView addSubview:lineview];
    
    self.timeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeBt.frame = CGRectMake(0, 0, kScreen_Width/2, 42);
    [self.timeBt setTitle:@"按照时间" forState:UIControlStateNormal];
    [self.timeBt setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    self.timeBt.titleLabel.font = [UIFont systemFontOfSize:16];
    self.timeBt.tag = 1;
    [self.timeBt addTarget:self action:@selector(moveWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.timeBt];
    
    self.departmentBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.departmentBt.frame = CGRectMake(kScreen_Width/2, 0, kScreen_Width/2, 42);
    [self.departmentBt setTitle:@"按部门" forState:UIControlStateNormal];
    [self.departmentBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    self.departmentBt.tag = 2;
    [self.departmentBt addTarget:self action:@selector(moveWay:) forControlEvents:UIControlEventTouchUpInside];
    self.departmentBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.headView addSubview:self.departmentBt];
    
    self.viewLine = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2, 42, kScreen_Width/2, 2)];
    self.viewLine.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.headView addSubview:self.viewLine];
    
    self.departmentView = [[AccordingToDepartmentView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height)];
    [self.view addSubview:self.departmentView];
    
    self.timeView = [[AccordingToTimeView alloc] initWithFrame:CGRectMake(-kScreen_Width, 44, kScreen_Width, kScreen_Height)];
    [self.view addSubview:self.timeView];
}
- (void)moveWay:(UIButton *)bt{
    [self.departmentBt setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.timeBt setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    if (bt.tag == 1) {
        [self.timeBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        self.departmentView.frame = CGRectMake(kScreen_Width, 44, kScreen_Width, kScreen_Height);
        self.timeView.frame = CGRectMake(0, 44, kScreen_Width, kScreen_Height);
        self.viewLine.frame = CGRectMake(0, 42, kScreen_Width/2, 2);
    }else if (bt.tag == 2){
        [self.departmentBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        self.departmentView.frame = CGRectMake(0, 44, kScreen_Width, kScreen_Height);
        self.timeView.frame = CGRectMake(-kScreen_Width, 44, kScreen_Width, kScreen_Height);
        self.viewLine.frame = CGRectMake(kScreen_Width/2, 42, kScreen_Width/2, 2);
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
