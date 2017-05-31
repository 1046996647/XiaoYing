//
//  SearchView.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/8.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "SearchFriendView.h"
#import "DetailTableViewCell.h"
#import "ConnectModel.h"
#import "FriendDetailMessageVC.h"

@interface SearchFriendView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UILabel *remindLab;


@end



@implementation SearchFriendView

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
    DetailTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell =[[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.sendFriendBlock = ^(ConnectWithMyFriend *model)
        {
            
            if (model.isSelected) {
                
                if (![_selectedArr containsObject:model.ProfileId]) {
                    [_selectedArr addObject:model.ProfileId];
                    
                }
            }
            else {
                if ([_selectedArr containsObject:model.ProfileId]) {
                    [_selectedArr removeObject:model.ProfileId];
                    
                }
            }
            if (self.searchBlock) {
                self.searchBlock();
            }
            // 数据刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataRefreshNotification" object:nil];
        };
        
    }
    cell.section = 1;
    cell.type = 1;
    ConnectWithMyFriend * myfriend =self.approveArr[indexPath.row];
    if ([_selectedArr containsObject:myfriend.ProfileId]) {
        myfriend.isSelected = YES;
    }
    else {
        myfriend.isSelected = NO;
    }

    if (self.clickAction == FriendViewClickActionOne) {
        cell.type = 0;
        
    }
    else {
        cell.type = 1;
        
    }
    cell.myfriend = myfriend;

    if ([_iDArr containsObject:myfriend.ProfileId]) {
        [cell.selectedControl setImage:[UIImage imageNamed:@"choice_gray"] forState:UIControlStateNormal];
        cell.selectedControl.userInteractionEnabled = NO;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.viewController.view endEditing:YES];

    ConnectWithMyFriend *friend = self.approveArr[indexPath.row];

    if (self.clickAction == FriendViewClickActionOne) {
        FriendDetailMessageVC *friendDetailMessageVC = [[FriendDetailMessageVC alloc] init];
        friendDetailMessageVC.model = friend;
        [self.viewController.navigationController pushViewController:friendDetailMessageVC animated:YES];
        if (self.searchBlock) {
            self.searchBlock();
        }
    }

}


-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
    UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}



@end
