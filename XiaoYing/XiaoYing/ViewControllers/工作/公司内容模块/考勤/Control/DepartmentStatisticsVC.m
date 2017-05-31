//
//  DepartmentStatisticsVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DepartmentStatisticsVC.h"
#import "StatisticHeadView.h"
@interface DepartmentStatisticsVC ()
{
    NSInteger tapFlag;
}
@property (nonatomic,strong)StatisticHeadView *statistHeadView;
@property (nonatomic,strong)UIView *headView;//按照时间签到的头
@property (nonatomic,strong)UITableView *table1;//按照时间签到的列表
@property (nonatomic,strong)UILabel *fromTimeToTimeLab;//从什么时间到什么时间
@property (nonatomic,strong)UILabel *alreadyLab;//已签
@property (nonatomic,strong)UILabel *eailyLab;//早签
@property (nonatomic,strong)UILabel *leakLab;//漏签

@end

@implementation DepartmentStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tapFlag = 0;
    [self initUI];
}
- (void)initUI{
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
    self.headView.layer.borderWidth = 1;
    self.headView.userInteractionEnabled = YES;
    [self.view addSubview:self.headView];
    
    self.statistHeadView = [[StatisticHeadView alloc] initWithFrame:CGRectMake(0, 70, kScreen_Width, 12+30+12+30+12+30+15+0.5+50)];
    self.statistHeadView.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LowHead)];
    [self.headView addGestureRecognizer:tap];
    
    self.fromTimeToTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 14)];
    self.fromTimeToTimeLab.text = @"2016-01-01~2016-01-21";
    self.fromTimeToTimeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.fromTimeToTimeLab.font = [UIFont systemFontOfSize:14];
    self.fromTimeToTimeLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:self.fromTimeToTimeLab];
    
    self.alreadyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12+14+12, kScreen_Width/2-60, 12)];
    self.alreadyLab.text = @"已签 96";
    self.alreadyLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.alreadyLab.font = [UIFont systemFontOfSize:12];
    self.alreadyLab.textAlignment = NSTextAlignmentRight;
    [self.headView addSubview:self.alreadyLab];
    
    self.eailyLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2-60, 12+14+12, 120, 12)];
    self.eailyLab.text = @"早签 1";
    self.eailyLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.eailyLab.font = [UIFont systemFontOfSize:12];
    self.eailyLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:self.eailyLab];
    
    self.leakLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2+60, 12+14+12, kScreen_Width/2-60, 12)];
    self.leakLab.text = @"漏签 1";
    self.leakLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.leakLab.font = [UIFont systemFontOfSize:12];
    self.leakLab.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.leakLab];
}
//下拉框
- (void)LowHead{
    if (tapFlag == 0) {
        [self.view addSubview:self.statistHeadView];
        tapFlag = 1;
    }else{
        [self.statistHeadView removeFromSuperview];
        tapFlag = 0;
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
