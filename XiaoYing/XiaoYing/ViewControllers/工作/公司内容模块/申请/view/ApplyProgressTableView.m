//
//  ApprovalProgressTableView.m
//  XiaoYing
//
//  Created by ZWL on 15/12/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyProgressTableView.h"
#import "ApplicationModel.h"
#import "ApplyProgressCell.h"
#import "ApplyStatusCell.h"

@interface ApplyProgressTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _statusCellHeight;
}

@end

@implementation ApplyProgressTableView
@synthesize approvalNodeModelArray = _approvalNodeModelArray;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        // 设置一些属性
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setApprovalNodeModelArray:(NSArray *)approvalNodeModelArray
{
    _approvalNodeModelArray = approvalNodeModelArray;
    
    [self reloadData];
    
}

#pragma mark - tableViewDataSource,UITableViewDelegate
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.approvalNodeModelArray.count == 0) {
        return 0;
    }
    return self.approvalNodeModelArray.count +1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.approvalNodeModelArray.count) {
        
        ApplyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APPLYPROGRESSCELL"];
        
        if (cell == nil) {
            cell = [[ApplyProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"APPLYPROGRESSCELL"];
        }
        
        ApprovalNodeModel *approvalNodeModel = [self.approvalNodeModelArray objectAtIndex:indexPath.row];
        cell.approvalNodeModel = approvalNodeModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //隐藏cell的语音按钮
        cell.voiceBtn.hidden = YES;
        return cell;
    }else {
        
        ApplyStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APPLYSTATUSCELL"];
        
        if (cell == nil) {
            cell = [[ApplyStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"APPLYSTATUSCELL"];
        }
        
        ApprovalNodeModel *approvalNodeModel = self.approvalNodeModelArray.lastObject;
        cell.statusName = approvalNodeModel.statusName;
        
        return cell;
    }
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"heightForRowAtIndexPath~~");
    
    if (indexPath.row < self.approvalNodeModelArray.count) {
        
        ApprovalNodeModel *approvalNodeModel = [self.approvalNodeModelArray objectAtIndex:indexPath.row];
        NSString *text = approvalNodeModel.comment;
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreen_Width-60-12-30, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]}context:nil];
        
        if (approvalNodeModel.isExpand) {
            
            if ([text isEqualToString:@""]) {
                return (58+24+0+7+20+10);
            }
            
            return (58+24+rect.size.height+7+20+10);
            
        } else {
            return 58 + 24;
            
        }
        
    }else {
        
        return 58 + 24;
        
    }
    
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.applyProgressDelegate respondsToSelector:@selector(scroll)]) {
        [self.applyProgressDelegate scroll];
    }
}




@end
