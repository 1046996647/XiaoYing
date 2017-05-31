//
//  SelectWayVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SelectWayVC.h"
#import "SelectWayCell.h"
#import "SelectExistingPeopleVC.h"

@interface SelectWayVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
}

@end

@implementation SelectWayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择更换执行人路径";

    
    _titleArr = @[@"移交至现有执行人",@"移交新执行人"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //导航栏的下一步按钮
//    [self initRightBtn];
}

//导航栏的下一步按钮
//- (void)initRightBtn
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 50, 20);
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn setTitle:@"下一步" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    [self.navigationItem setRightBarButtonItem:rightBar];
//}

//- (void)nextAction
//{
//    [self.navigationController pushViewController:[[SelectWayVC alloc] init] animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        SelectExistingPeopleVC *selectExistingPeopleVC = [[SelectExistingPeopleVC alloc] init];
        [self.navigationController pushViewController:selectExistingPeopleVC animated:YES];
    } else {
//        SelectNewExcutePeopleVC *selectNewExcutePeopleVC = [[SelectNewExcutePeopleVC alloc] init];
//        [self.navigationController pushViewController:selectNewExcutePeopleVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectWayCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[SelectWayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    cell.way = _titleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
