//
//  EmployeeModel.h
//  XiaoYing
//
//  Created by ZWL on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseModel.h"

/*
 
 "ProfileId": "sample string 1",
 "EmpolyeeId": "sample string 2",
 "DepartmentId": "sample string 3",
 "EmployeeName": "sample string 4",
 "MastJobName": "sample string 5",
 "FaceURL": "sample string 6",
 "Nick": "sample string 7"
 */

@interface EmployeeModel : BaseModel

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isLeader;// 是否有领导者
@property (nonatomic,assign) BOOL isBelongToCurrentDepartment;

@property (nonatomic,assign) BOOL isMastLeader;// 在当前层且是领导者
@property (nonatomic,assign) BOOL isConcurrentLeader;// 不在当前层但是领导者
@property (nonatomic,assign) BOOL isFriend;// 是否是好友关系

@property (nonatomic,assign) BOOL isMain;// 是否是群聊创建者

//@property (nonatomic,copy) NSString *ManagerProfileId;

@property (nonatomic,copy) NSString *EmployeeName;
//@property (nonatomic,copy) NSString *EmployeeId;
@property (nonatomic, strong) NSString *EmployeeNo;
@property (nonatomic, strong) NSString *DepartmentId;
@property (nonatomic, strong) NSString *DepartmentName;
@property (nonatomic, strong) NSArray *Jobs;

@property (nonatomic, strong) NSString *EmployeeID;
@property (nonatomic, strong) NSString *FaceURL;
@property (nonatomic, strong) NSString *EmployeeFaceUrl;// 与FaceURL相同
@property (nonatomic, strong) NSString *RoleType;
@property (nonatomic, strong) NSString *Mobile;
@property (nonatomic, strong) NSString *Signer;
@property (nonatomic, strong) NSString *RealAddress;
@property (nonatomic, strong) NSString *Birthday;
@property (nonatomic, strong) NSString *ProfileId;
@property (nonatomic, strong) NSNumber *Gender;
@property (nonatomic, strong) NSString *xiaoYingHao;

@end
