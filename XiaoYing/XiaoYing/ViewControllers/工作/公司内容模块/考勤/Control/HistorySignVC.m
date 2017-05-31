//
//  HistorySignVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "HistorySignVC.h"
#import "HistorySignCell.h"
#import "StatisticHeadView.h"
#import "HistorySignDetailVC.h"
@interface HistorySignVC ()
{
    NSInteger lowFlag;
}
@property (nonatomic,strong)UIView *headView;//按照时间签到的头
@property (nonatomic,strong)UITableView *table1;//列表
@property (nonatomic,strong)UILabel *fromTimeToTimeLab;//从什么时间到什么时间
@property (nonatomic,strong)UILabel *alreadyLab;//已签
@property (nonatomic,strong)UILabel *eailyLab;//早签
@property (nonatomic,strong)UILabel *leakLab;//漏签
@property (nonatomic,strong)StatisticHeadView *statisticView;//下拉框

@end

@implementation HistorySignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lowFlag = 0;
    
    [self initUI];
}
- (void)initUI{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
    self.headView.layer.borderWidth = 1;
    self.headView.userInteractionEnabled = YES;
    [self.view addSubview:self.headView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lowHead)];
    
    [self.headView addGestureRecognizer:tap];
    
    self.statisticView = [[StatisticHeadView alloc] initWithFrame:CGRectMake(0, 70, kScreen_Width, kScreen_Height-70-64)];
    self.statisticView.backgroundColor = [UIColor whiteColor];
    

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
    
    self.table1 =[[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreen_Width, kScreen_Height-70-64)];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.table1];

}
- (void)lowHead{
    if (lowFlag == 0) {
        [self.view addSubview:self.statisticView];
        lowFlag = 1;
    }else{
        lowFlag = 0;
        [self.statisticView removeFromSuperview];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistorySignDetailVC *vc = [[HistorySignDetailVC alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.title = @"2016年01月21日";
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistorySignCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[HistorySignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
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
