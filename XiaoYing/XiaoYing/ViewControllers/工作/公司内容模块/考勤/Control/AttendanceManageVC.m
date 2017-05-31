//
//  AttendanceManageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AttendanceManageVC.h"
#import "CreateAttendanceVC.h"
#import "DoStatisticsVC.h"
@interface AttendanceManageVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *attendaceTable;
@property (nonatomic,copy) NSMutableArray *attendanceArr;
@property (nonatomic,strong) UIView *footview;

@end

@implementation AttendanceManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(tongjiWay)];
    
    _attendanceArr = [[NSMutableArray alloc] init];
    [_attendanceArr addObject:@"考勤1"];
    [_attendanceArr addObject:@"考勤2"];
    [self initUI];
}

- (void)tongjiWay{
    DoStatisticsVC *vc = [[DoStatisticsVC alloc] init];
    vc.title = @"统计";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateAttendanceVC *creatvc = [[CreateAttendanceVC alloc] init];
    creatvc.title = self.attendanceArr[indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:creatvc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.attendanceArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.attendanceArr[indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (void)initUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    self.attendaceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    self.attendaceTable.delegate = self;
    self.attendaceTable.dataSource = self;
    self.attendaceTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.attendaceTable];
    
    self.footview = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    self.footview.backgroundColor = [UIColor whiteColor];
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.footview addSubview:viewline];
    
    UIButton *creatBt = [UIButton buttonWithType:UIButtonTypeCustom];
    creatBt.frame = CGRectMake(0, 1, kScreen_Width, 44);
    [creatBt setTitle:@"新建考勤" forState:UIControlStateNormal];
    [creatBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    creatBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [creatBt addTarget:self action:@selector(creatWay) forControlEvents:UIControlEventTouchUpInside];
    [self.footview addSubview:creatBt];
    
    [self.view addSubview:self.footview];
    
    

}
- (void)creatWay{
    CreateAttendanceVC *creatvc = [[CreateAttendanceVC alloc] init];
    creatvc.title = @"新建考勤";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:creatvc animated:YES];
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
