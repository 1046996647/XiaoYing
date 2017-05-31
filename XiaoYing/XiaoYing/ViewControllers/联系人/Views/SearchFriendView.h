//
//  SearchView.h
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/8.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FriendViewClickAction) {
    FriendViewClickActionOne,//默认从0开始,进入好友详细资料
    FriendViewClickActionTwo,//选人
//    ClickActionThree,// 选人
//    ClickActionFour// 权限管理
};

typedef void(^SearchBlock)(void);

@interface SearchFriendView : UIView
@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) NSMutableArray *approveArr;

@property (nonatomic,assign) FriendViewClickAction clickAction;
@property (nonatomic,copy) SearchBlock searchBlock;

// 选中的人
@property (nonatomic, strong)NSMutableArray *selectedArr;
@property (nonatomic, strong)UISearchBar *searchBar;

// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;

@end
