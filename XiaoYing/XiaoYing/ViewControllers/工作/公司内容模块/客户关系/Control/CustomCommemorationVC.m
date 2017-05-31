//
//  CustomCommemorationVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CustomCommemorationVC.h"
#import "CommemorationCell.h"
#import "CommermorationHeardView.h"
#import "CustomerDetailVC.h"
@interface CustomCommemorationVC ()
{
    NSInteger cellFlag;
}
@property (nonatomic,strong) CommermorationHeardView *headView;
@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UISearchBar *seaBar;
@end

@implementation CustomCommemorationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellFlag = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllWay)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self initUI];
}
//筛选的方法
- (void)selectAllWay{
    NSLog(@"筛选");
    if (cellFlag == 0) {
        [self.view addSubview:self.headView];
        cellFlag = 1;
    }else if (cellFlag == 1){
        [self.headView removeFromSuperview];
        cellFlag = 0;
    }
    
}
//初始化UI控件
- (void)initUI{
    self.seaBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    self.seaBar.placeholder = @"查找客户";
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.tableHeaderView = self.seaBar;
    self.table1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.table1];
    
    self.headView = [[CommermorationHeardView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    self.headView.backgroundColor = [UIColor whiteColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerDetailVC *detailVC = [[CustomerDetailVC alloc] init];
    detailVC.title = @"详情";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommemorationCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[CommemorationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
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
