//
//  AttendanceVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AttendanceVC.h"
#import "AttendanceSignCell.h"
#import "AttendanceSignModel.h"
#import "AttendanceManageVC.h"
@interface AttendanceVC ()
{
    UIView *headView;
    NSMutableArray *modelArr;
    //背景
    UIView *backgroundView;
    UIView *headgroundView;
    UIView *whiteView;//白色
}
@property (nonatomic,strong) UILabel *timeLab;//当前时间
@property (nonatomic,strong) UILabel *dayLab;//年月日 星期
@property (nonatomic,strong) UILabel *monthSignLab;//本月签到
@property (nonatomic,strong) UILabel *leakSignLab;//漏签
@property (nonatomic,strong) UILabel *aheadSignLab;//早签
@property (nonatomic,strong) UIImageView *mapImageView;//地图
@property (nonatomic,strong) UIImageView *meterImageView;//表
@property (nonatomic,strong) UITableView *SignListTable;//签到列表


@property (nonatomic,strong) UILabel *titleLab;//超过签到时间段
@property (nonatomic,strong) UILabel *orTitleLab;//是否进行补签
@property (nonatomic,strong) UITextView *contentText;//说明
@property (nonatomic,strong) UIButton *leftBt;//补签
@property (nonatomic,strong) UIButton *rightBt;//取消
@property (nonatomic,strong) UIView *viewline;//细线
@property (nonatomic,strong) UIView *lineView;//细线

@end

@implementation AttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考勤";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //有考勤管理的显示“管理”，  没有的什么都不显示
    if ([_havePermission isEqual:@"havePermission"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(manageWay)];
    }
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
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
    
    
    //阴影
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(25, 144-64, kScreen_Width-50, 12+16+16+12+100+12+0.5+44)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.clipsToBounds = YES;
    whiteView.layer.cornerRadius = 5;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    backgroundView.alpha = 0.3;
    backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureway)];
    [backgroundView addGestureRecognizer:tap];
    
    headgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 100-64, kScreen_Width, kScreen_Height)];
    headgroundView.backgroundColor = [UIColor lightGrayColor];
    headgroundView.alpha = 0.3;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureway)];
    [headgroundView addGestureRecognizer:tap1];
    
   
    [self initWhileUI];
    
    [self initUI];
}


//管理
- (void)manageWay{
    AttendanceManageVC *vc = [[AttendanceManageVC alloc] init];
    vc.title = @"考勤管理";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)initWhileUI{
 
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, whiteView.frame.size.width, 16)];
    self.titleLab.text = @"超过签到时间段";
    self.titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:self.titleLab];
    
    self.orTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12+16, whiteView.frame.size.width, 16)];
    self.orTitleLab.text = @"是否进行补签";
    self.orTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.orTitleLab.font = [UIFont systemFontOfSize:16];
    self.orTitleLab.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:self.orTitleLab];
    
    
    self.contentText = [[UITextView alloc] initWithFrame:CGRectMake(10, 12+16+16+12, whiteView.frame.size.width-20, 100)];
    self.contentText.layer.cornerRadius = 3;
    self.contentText.clipsToBounds = YES;
    self.contentText.layer.borderWidth =0.5;
    self.contentText.layer.borderColor = [[UIColor colorWithHexString:@"#cccccc"] CGColor];
    self.contentText.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.contentText.text = @"说明";
    self.contentText.font = [UIFont systemFontOfSize:14];
    [whiteView addSubview:self.contentText];
    
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(whiteView.frame.size.width/2, 12+16+16+12+100+12+11, 0.5, 20)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [whiteView addSubview:self.lineView];
    
    self.viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 12+16+16+12+100+12, whiteView.frame.size.width, 0.5)];
    self.viewline.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [whiteView addSubview:self.viewline];
    
    
    self.leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBt.frame = CGRectMake(0, 12+16+16+12+100+12+0.5, whiteView.frame.size.width/2-1, 44);
    [self.leftBt setTitle:@"补签" forState:UIControlStateNormal];
    self.leftBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leftBt setTitleColor:[UIColor colorWithHexString:@"#f75d5c"] forState:UIControlStateNormal];
    [whiteView addSubview:self.leftBt];
    
    self.rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBt.frame = CGRectMake(whiteView.frame.size.width/2, 12+16+16+12+100+12+0.5, whiteView.frame.size.width/2-1, 44);
    [self.rightBt setTitle:@"取消" forState:UIControlStateNormal];
    self.rightBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBt setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [whiteView addSubview:self.rightBt];
    
    
}
//初始化UI控件
- (void)initUI{
    //头
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 18+10+30+16+13+10+20+16)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.view addSubview:headView];
    
    //时间
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, kScreen_Width, 30)];
    self.timeLab.text = @"21:09";
    self.timeLab.font = [UIFont systemFontOfSize:40];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.timeLab];
    
    //年月日  星期
    self.dayLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 18+10+30, kScreen_Width, 16)];
    self.dayLab.text = @"2016年01月22日   星期五";
    
    self.dayLab.font = [UIFont systemFontOfSize:16];
    self.dayLab.textAlignment = NSTextAlignmentCenter;
    self.dayLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.dayLab];
    
    //本月签到
    self.monthSignLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-100)/2, 18+10+30+16+13, 100, 12)];
    self.monthSignLab.text = @"本月签到  16/31";
    
    self.monthSignLab.font = [UIFont systemFontOfSize:12];
    self.monthSignLab.textAlignment = NSTextAlignmentCenter;
    self.monthSignLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.monthSignLab];
    
    //本月漏签
    self.leakSignLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-100)/2, 18+10+30+16+13+12+6, 50, 12)];
    self.leakSignLab.text = @"漏签  2";
    self.leakSignLab.font = [UIFont systemFontOfSize:12];
    self.leakSignLab.textAlignment = NSTextAlignmentLeft;
    self.leakSignLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.leakSignLab];
    
    //本月早签
    self.aheadSignLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2, 18+10+30+16+13+12+6, 50, 12)];
    self.aheadSignLab.text = @"早签  2";
    self.aheadSignLab.font = [UIFont systemFontOfSize:12];
    self.aheadSignLab.textAlignment = NSTextAlignmentRight;
    self.aheadSignLab.textColor = [UIColor whiteColor];
    [headView addSubview:self.aheadSignLab];
    
    //地图定位
    self.mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18+10+30+16+13+10, 16, 20)];
    self.mapImageView.image = [UIImage imageNamed:@"position_attendance"];
    [headView addSubview:self.mapImageView];
    
    //表
    self.meterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-18-20, 18+10+30+16+13+8, 20, 20)];
    self.meterImageView.image = [UIImage imageNamed:@"history"];
    [headView addSubview:self.meterImageView];
    
    //列表
    self.SignListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 133, kScreen_Width, kScreen_Height-133-64)];
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
    cell.signBt.tag = indexPath.section;
    [cell.signBt addTarget:self action:@selector(signWay:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//添加阴影
- (void)signWay:(UIButton *)bt{
    AppDelegate *app =(AppDelegate *) [UIApplication sharedApplication].delegate;
    
    
    [app.window addSubview:backgroundView];
     [self.view addSubview:headgroundView];
    [self.view addSubview:whiteView];
    
}
//手势取消阴影
- (void)gestureway{
    [backgroundView removeFromSuperview];
    [headgroundView removeFromSuperview];
    [whiteView removeFromSuperview];
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
