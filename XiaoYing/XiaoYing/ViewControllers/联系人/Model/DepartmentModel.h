//
//  DepartmentModel.h
//  XiaoYing
//
//  Created by ZWL on 16/6/6.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseModel.h"

@interface DepartmentModel : BaseModel

@property (nonatomic,assign) BOOL isExpend;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,copy) NSString *ParentID;
@property (nonatomic,copy) NSString *DepartmentId;
@property (nonatomic,copy) NSString *superTitle;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,strong) NSNumber *superRanks;
@property (nonatomic,strong) NSNumber *Ranks;

@property (nonatomic,copy) NSString *ManagerProfileId;
@property (nonatomic,strong) NSNumber *OrderID;
@property (nonatomic,strong) NSNumber *NodeLevel;

// 测试
@property (nonatomic,copy) NSString *comanyName;


@end
