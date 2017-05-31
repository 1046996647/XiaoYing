//
//  ApproalPocessTableView.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApproalPocessTableView.h"
#import "ApplicationModel.h"
//#import "ApplyProgressCell.h"
#import "ApproalPocessCell.h"
//#import "ApprovalPeopleModel.h"
#import "ApproalStateCell.h"
@interface ApproalPocessTableView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,copy)NSString *profileID;
@property(nonatomic,assign)NSInteger indexRow;
@end

@implementation ApproalPocessTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        //self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.tableFooterView = [UIView new];
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        // 设置一些属性
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = NO;
        _profileID = [UserInfo userID];
        _indexRow = 10000;
    }
    return self;
}

#pragma mark - tableViewDataSource,UITableViewDelegate
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count + 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataList.count) {
        ApproalPocessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APPLYPROGRESSCELL"];
        
        if (cell == nil) {
            cell = [[ApproalPocessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"APPLYPROGRESSCELL"];
        }
        
        // ApprovalPeopleModel *people = self.dataList[indexPath.row];
        FlowModel *flowModel = self.dataList[indexPath.row];
        NSString *userID = flowModel.commenterProfileId;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index = indexPath.row;
        cell.applyTime = self.applyTime;
        cell.flowModels = self.flows;
        cell.flowModel = flowModel;
        if ([_profileID isEqualToString:userID]) {
            _indexRow = indexPath.row;
            cell.showComment = YES;
        }else{
            if (indexPath.row > _indexRow) {//如果审批在下一级
                cell.showComment = NO;
            }else{
                cell.showComment = YES;
            }
        }
        //cell.approvalPeople = people;
        return cell;
    }else{
        ApproalStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lastCell"];
        
        if (cell == nil) {
            cell = [[ApproalStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lastCell"];
        }
        cell.flows = self.flows;
        return cell;
    }
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ApprovalPeopleModel *people = self.dataList[indexPath.row];
//    NSString *text = people.suggestion;
    
    if (indexPath.row < self.dataList.count) {
        FlowModel *flowModel = self.dataList[indexPath.row];
        NSString *text = flowModel.comment;
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreen_Width-60-12-30, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]}context:nil];
        
        if (flowModel.isExpand) {
            
            //如果没有审批意见，没有图片
            if (flowModel.photos.count == 0 && [flowModel.comment isEqualToString:@""]) {

                return (58+24);
            }
            //如果有审批意见，没有图片
           else if (flowModel.photos.count == 0 && ![flowModel.comment isEqualToString:@""]) {

                 return (58+24+rect.size.height+5);
            }
            //如果没有审批意见，有图片
            else if (flowModel.photos.count !=0 && [flowModel.comment isEqualToString:@""]) {

                return (58+24+7+20+5);
            }
            //有审批意见，有图片
            else{
                return (58+24+rect.size.height+7+20+5);
            }
        } else {
            return 58 + 24;
        }
    }else{
        return 58 + 24 ;
    }
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.ApproalPocessTableViewDelegate respondsToSelector:@selector(scroll)]) {
        [self.ApproalPocessTableViewDelegate scroll];
    }
}

@end
