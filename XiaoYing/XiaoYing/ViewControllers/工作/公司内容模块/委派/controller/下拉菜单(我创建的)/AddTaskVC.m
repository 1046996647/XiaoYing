//
//  AddTaskVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AddTaskVC.h"
#import "EditCell.h"
#import "CheckVC.h"

@interface AddTaskVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSInteger _count;
    NSInteger _picCount;

}

@end

@implementation AddTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加任务";
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _count = 1;
    
    //导航栏的保存按钮
    [self initRightBtn];
    
    
}

//导航栏的保存按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

- (void)saveAction
{
    
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 1) {
        return 56+16;
    } else {
        return (44+40+312/2.0+44+12+60+16);

    }
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < 1) {
        CheckVC *checkVC = [[CheckVC alloc] init];
        checkVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        checkVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        checkVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:checkVC animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCell *cell = nil;
    if (indexPath.row < 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];

    }
    
    
    if (cell == nil) {
        
        if (indexPath.row < 1) {
            cell = [[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];

        } else {
            cell = [[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];

        }
        
    }
    
    cell.row = indexPath.row + 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 31;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 31)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(12, 0, kScreen_Width-24, 30);
    [btn setTitle:@"添加任务" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"f99740"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.clipsToBounds = YES;
    btn.layer.borderWidth = .5;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

- (void)addAction
{
    _count++;
    [_tableView reloadData];
    
    if (_count >= 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
