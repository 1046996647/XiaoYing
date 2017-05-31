
//
//  HistorySignDetailVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "HistorySignDetailVC.h"
#import "AttendanceSignCell.h"
#import "AttendanceSignModel.h"
@interface HistorySignDetailVC ()
{
    UIView *headView;
    NSMutableArray *modelArr;
}
@property (nonatomic,strong) UILabel *timeLab;//当前时间
@property (nonatomic,strong) UILabel *dayLab;//年月日 星期
@property (nonatomic,strong) UILabel *monthSignLab;//本月签到
@property (nonatomic,strong) UILabel *leakSignLab;//漏签
@property (nonatomic,strong) UILabel *aheadSignLab;//早签
@property (nonatomic,strong) UIImageView *mapImageView;//地图
@property (nonatomic,strong) UIImageView *meterImageView;//表
@property (nonatomic,strong) UITableView *SignListTable;//签到列表
@end

@implementation HistorySignDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    modelArr = [[NSMutableArray alloc] init];
    
    AttendanceSignModel *model = [[AttendanceSignModel alloc] init];
    model.morningStr = @"上午上班";
    model.distanceStr = @"距离签到点100米";
    model.timeStr = @"00:00-00:30";
    model.modelFlag = 1;
    [modelArr addObject:model];
    
    AttendanceSignModel *model1 = [[AttendanceSignModel alloc] init];
    model1.morningStr = @"上午下班";
    model1.distanceStr = @"距离签到点100米";
    model1.timeStr = @"11:30-13:30";
    model1.modelFlag = 2;
    [modelArr addObject:model1];
    
    AttendanceSignModel *model2 = [[AttendanceSignModel alloc] init];
    model2.morningStr = @"下午上班";
    model2.distanceStr = @"距离签到点100米";
    model2.timeStr = @"11:30-13:30";
    model2.modelFlag = 3;
    [modelArr addObject:model2];
    
    AttendanceSignModel *model3 = [[AttendanceSignModel alloc] init];
    model3.morningStr = @"下午下班";
    model3.distanceStr = @"距离签到点100米";
    model3.timeStr = @"17:30-18:30";
    model3.modelFlag = 4;
    [modelArr addObject:model3];
    
    AttendanceSignModel *model4 = [[AttendanceSignModel alloc] init];
    model4.morningStr = @"上午上班";
    model4.distanceStr = @"距离签到点100米";
    model4.timeStr = @"00:00-00:30";
    model4.modelFlag = 1;
    [modelArr addObject:model4];
    
    AttendanceSignModel *model5 = [[AttendanceSignModel alloc] init];
    model5.morningStr = @"上午下班";
    model5.distanceStr = @"距离签到点100米";
    model5.timeStr = @"11:30-13:30";
    model5.modelFlag = 2;
    [modelArr addObject:model5];
    
    AttendanceSignModel *model6 = [[AttendanceSignModel alloc] init];
    model6.morningStr = @"下午上班";
    model6.distanceStr = @"距离签到点100米";
    model6.timeStr = @"00:00-00:30";
    model6.modelFlag = 3;
    [modelArr addObject:model6];
    
    AttendanceSignModel *model7 = [[AttendanceSignModel alloc] init];
    model7.morningStr = @"下午下班";
    model7.distanceStr = @"距离签到点100米";
    model7.timeStr = @"00:00-00:30";
    model7.modelFlag = 4;
    [modelArr addObject:model7];
    
    [self initUI];//初始化UI控件
}
//初始化UI控件
- (void)initUI{
    //头
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 18+30+13+12+6+12+12)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.view addSubview:headView];
    
    //时间
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, kScreen_Width, 30)];
    self.timeLab.text = @"星期五";
    self.timeLab.font = [UIFont systemFontOfSize:40];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.timeLab];
    
    //本月签到
    self.monthSignLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-100)/2, 18+30+13, 100, 12)];
    self.monthSignLab.text = @"本日签到  16/31";
    
    self.monthSignLab.font = [UIFont systemFontOfSize:12];
    self.monthSignLab.textAlignment = NSTextAlignmentCenter;
    self.monthSignLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.monthSignLab];
    
    //本月漏签
    self.leakSignLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-100)/2, 18+30+13+12+6, 50, 12)];
    self.leakSignLab.text = @"漏签  2";
    self.leakSignLab.font = [UIFont systemFontOfSize:12];
    self.leakSignLab.textAlignment = NSTextAlignmentLeft;
    self.leakSignLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.leakSignLab];
    
    //本月早签
    self.aheadSignLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2, 18+30+13+12+6, 50, 12)];
    self.aheadSignLab.text = @"早签  2";
    self.aheadSignLab.font = [UIFont systemFontOfSize:12];
    self.aheadSignLab.textAlignment = NSTextAlignmentRight;
    self.aheadSignLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.aheadSignLab];
    
   
    
    //列表
    self.SignListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 18+30+13+12+6+12+12, kScreen_Width, kScreen_Height-(18+30+13+12+6+12+12)-64)];
    self.SignListTable.delegate = self;
    self.SignListTable.dataSource = self;
    self.SignListTable.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.SignListTable];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [modelArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendanceSignCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[AttendanceSignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = modelArr[indexPath.section];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor whiteColor];
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
