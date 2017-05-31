//
//  SelectExcutePeopleVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "RecordVC.h"
#import "RecordCell.h"
#import "RecordModel.h"

@interface RecordVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataList;
}

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"记录";
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        RecordModel *model = [[RecordModel alloc] init];
        [mArr addObject:model];
    }
    
    _dataList = mArr;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataList.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordModel *model = _dataList[indexPath.row];
    if (model.isSelected) {
        return 226;

    } else {
        return 127;

    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataList[indexPath.row];
    return cell;
}

- (void)relodTableView
{
    [_tableView reloadData];
}

@end
