//
//  SearchView.m
//  XiaoYing
//
//  Created by ZWL on 16/10/14.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SearchResultView.h"
#import "NewApprovalModel.h"
#import "ManageCell.h"
#import "DetailApproveVC.h"
#import "EditApproveFlowVC.h"

@implementation SearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 表视图
        self.approveTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        //    self.approveTable.tableHeaderView = self.humanSearch;
        self.approveTable.tableFooterView = [UIView new];
        self.approveTable.delegate = self;
        self.approveTable.dataSource = self;
        self.approveTable.backgroundColor = [UIColor clearColor];
        [self addSubview:self.approveTable];
            }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewController.view endEditing:YES];
    
    NewApprovalModel *model = self.approveArr[indexPath.row];
    
    if (self.tag == 100) {
        DetailApproveVC *detailApproveVC = [[DetailApproveVC alloc] init];
        detailApproveVC.title = model.Name;
        detailApproveVC.model = model;
        [self.viewController.navigationController pushViewController:detailApproveVC animated:YES];
    }
    else {
        EditApproveFlowVC *editVC = [[EditApproveFlowVC alloc] init];
        
        editVC.title = @"编辑审批种类";
        editVC.TypeId = model.ObjectID;
        [self.viewController.navigationController pushViewController:editVC animated:YES];
        editVC.refreshBlock = self.refreshBlock;
    }
    if (self.searchBlock) {
        self.searchBlock();
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[ManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NewApprovalModel *model = _approveArr[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.text = model.Name;
    cell.model = model;
    //    cell.selected = NO;
    return cell;
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _approveArr.count;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewController.view endEditing:YES];
}


@end
