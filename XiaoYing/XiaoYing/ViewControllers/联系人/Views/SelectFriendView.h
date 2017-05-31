//
//  SelectFriendView.h
//  XiaoYing
//
//  Created by ZWL on 16/11/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendView : UIView


// 选中的人
@property (nonatomic, strong)NSMutableArray *selectedArr;
@property (nonatomic, strong) UITableView * myFriendtab; // 好友表视图
// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;

@end
