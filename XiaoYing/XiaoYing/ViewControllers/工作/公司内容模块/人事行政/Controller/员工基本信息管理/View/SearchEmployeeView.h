//
//  SearchEmployeeView.h
//  XiaoYing
//
//  Created by ZWL on 16/11/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"

typedef NS_ENUM(NSInteger, ClickAction) {
    ClickActionOne,//默认从0开始,进入员工详细信息(人事管理)
    ClickActionTwo,//进入员工详细资料(聊天-同事)
    ClickActionThree,// 选人
    ClickActionFour// 权限管理
};

typedef void(^SearchBlock)(void);
typedef void(^ReferMember)(NSMutableArray *array, NSMutableArray *array1);

@interface SearchEmployeeView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) NSMutableArray *approveArr;

@property (nonatomic,copy) SearchBlock searchBlock;
@property (nonatomic, copy) ReferMember referMember;

@property (nonatomic, strong) NSNumber *superRanks;
//@property (nonatomic, strong) NSString *ManagerProfileId;

@property (nonatomic,strong) DepartmentModel *model;
@property (nonatomic,assign) ClickAction clickAction;

@property (nonatomic, strong)NSMutableArray *selectedEmpArr;

@property (nonatomic, strong) NSMutableArray *ManagerProfileIdArray;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSMutableArray *selectedArr;

// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;

@end
