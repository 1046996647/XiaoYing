//
//  KeepAccountVC.m
//  XiaoYing
//
//  Created by ZWL on 16/3/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "KeepAccountVC.h"
#import "FinancialAllModel.h"
#import "KeepAccountCell.h"
@interface KeepAccountVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *DataArr;//数据
    UITableView *keepAccountTable;
}
@end

@implementation KeepAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"记账";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:nil];
    
    DataArr = [[NSMutableArray alloc] init];
    
    FinancialAllModel *model1 = [[FinancialAllModel alloc] init];
    model1.leftStr = @"公司";
    model1.rightStr = @"杭州赢萊金融信息服务有限公司";
    
    FinancialAllModel *model2 = [[FinancialAllModel alloc] init];
    model2.leftStr = @"部门";
    model2.rightStr = @"科技产业部";
    
    FinancialAllModel *model3 = [[FinancialAllModel alloc] init];
    model3.leftStr = @"时间";
    model3.rightStr = @"2016-02-24";
    
    FinancialAllModel *model4 = [[FinancialAllModel alloc] init];
    model4.leftStr = @"类型";
    model4.rightStr = @"采购电脑";
    
    [DataArr addObject:model1];
    [DataArr addObject:model2];
    [DataArr addObject:model3];
    [DataArr addObject:model4];
    
    
    [self initUI];
}
- (void)initUI{
    keepAccountTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    keepAccountTable.delegate = self;
    keepAccountTable.dataSource = self;
    [self.view addSubview:keepAccountTable];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KeepAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KeepAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        cell.model = DataArr[indexPath.row];
    }else{
        
    }
    
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
