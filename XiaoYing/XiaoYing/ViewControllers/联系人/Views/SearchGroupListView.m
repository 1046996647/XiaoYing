//
//  SearchGroupListView.m
//  XiaoYing
//
//  Created by ZWL on 16/11/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SearchGroupListView.h"
#import "GroupListCell.h"
#import "ChatViewController.h"

@interface SearchGroupListView() <UITableViewDataSource,UITableViewDelegate>



@end

@implementation SearchGroupListView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 表视图
        self.approveTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.approveTable.tableFooterView = [UIView new];
        self.approveTable.delegate = self;
        self.approveTable.dataSource = self;
        self.approveTable.backgroundColor = [UIColor clearColor];
        [self addSubview:self.approveTable];
        
    }
    
    return self;
}

#pragma mark --UITableViewDelegate 协议方法
//每区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _approveArr.count;
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
// cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str =@"cell";
    GroupListCell * cell =[tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell =[[GroupListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    cell.model = self.approveArr[indexPath.row];

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.viewController.view endEditing:YES];
    
    GroupListModel *model = self.approveArr[indexPath.row];
    
    //讨论组
    ChatViewController * chatVC =[[ChatViewController alloc]init];
    chatVC.conversationType = ConversationType_DISCUSSION;
    chatVC.targetId = model.RongCloudChatRoomId;
    chatVC.title = model.Name;
    //        chatVC.unreadMessageCount = model.unreadMessageCount;
    //    chatVC.model = model;
    [self.viewController.navigationController pushViewController:chatVC animated:YES];
    if (self.searchBlock) {
        self.searchBlock();
    }
    
}


-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
    UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}

@end
