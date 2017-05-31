//
//  AttendanceBFVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AttendanceBFVC.h"
#import "AttendanceObjectCell.h"
@interface AttendanceBFVC ()
{
    NSMutableArray *modelArr;//数据
}
@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UIView *footView;

@end

@implementation AttendanceBFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(allSelectWay)];
    if ([self.sssStr isEqualToString:@"1"]) {
        
        modelArr = [[NSMutableArray alloc] init];
        [modelArr addObject:@"杭州赢萊金融信息服务有限公司"];
        [modelArr addObject:@"子公司"];
        [modelArr addObject:@"子公司"];
        
    }else if([self.sssStr isEqualToString:@"2"]){
        
        
        modelArr = [[NSMutableArray alloc] init];
        [modelArr addObject:@"科技产业部"];
        [modelArr addObject:@"人事行政部"];
        [modelArr addObject:@"财务部"];
    }else if([self.sssStr isEqualToString:@"3"]){
         
      
        modelArr = [[NSMutableArray alloc] init];
        [modelArr addObject:@"应俊俊"];
        [modelArr addObject:@"孟凡标"];
        [modelArr addObject:@"李恒"];
    }
    //初始化UI控件
    [self initUI];
}
- (void)allSelectWay{
    NSLog(@"全选");
}
- (void)initUI{
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.table1];
    
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footView];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.footView addSubview:viewline];
    
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0.5, kScreen_Width, 43.5);
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.footView addSubview:bt];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.sssStr isEqualToString:@"1"]) {
        AttendanceBFVC *attvc = [[AttendanceBFVC alloc] init];
        attvc.sssStr =@"2";
        attvc.title = @"选择考勤对象";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:attvc animated:YES];
    }else if ([self.sssStr isEqualToString:@"2"]){
        AttendanceBFVC *attvc = [[AttendanceBFVC alloc] init];
        attvc.sssStr =@"3";
        attvc.title = @"选择考勤对象";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:attvc animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.5;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.sssStr isEqualToString:@"1"]) {
        
    }else if ([self.sssStr isEqualToString:@"2"]){
        return 36;
    }else if ([self.sssStr isEqualToString:@"3"]){
        return 36;
    }
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([self.sssStr isEqualToString:@"1"]) {
        
    }else if ([self.sssStr isEqualToString:@"2"]){
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-24, 36)];
        lab.text = @"   杭州赢萊金融信息服务有限公司";
        lab.textColor = [UIColor colorWithHexString:@"#848484"];
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        return lab;

        
    }else if ([self.sssStr isEqualToString:@"3"]){
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-24, 36)];
        lab.text = @"   杭州赢萊金融信息服务有限公司科技产业部";
        lab.textColor = [UIColor colorWithHexString:@"#848484"];
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        return lab;

    }
    
    return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AttendanceObjectCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[AttendanceObjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.str = modelArr[indexPath.row];
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
