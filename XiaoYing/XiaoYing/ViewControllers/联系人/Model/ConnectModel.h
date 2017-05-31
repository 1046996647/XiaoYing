//
//  ConnectModel.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/2.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ConnectWithMyFriend : BaseModel <NSCoding>

@property (nonatomic,assign) BOOL isEmployee;// 是否是好友关系
@property (nonatomic,assign) BOOL isSelected;


@property (nonatomic, copy) NSString *Fullname; // 好友姓名
@property (nonatomic,copy) NSString * OrgId; // 所在部门
@property (nonatomic,copy) NSString * FaceUrl; // 头像
@property (nonatomic,copy) NSString * Nick; // 昵称
@property (nonatomic,copy) NSString * ProfileId; // 个人id 表示该人
@property (nonatomic,copy) NSString * DepartmentId; // 所在部门id
@property (nonatomic,copy) NSString * RequestTime; // 请求时间
@property (nonatomic,copy) NSString * Signature; // 个性签名
@property (nonatomic,copy) NSString * Birthday; // 生日RegionName
@property (nonatomic,copy) NSString * RegionName; 
@property (nonatomic,strong) NSNumber * RelationType; // 关系类型
@property (nonatomic,strong) NSNumber * Gender; // 性别
@property (nonatomic,strong) NSNumber * Status; // 状态
@property (nonatomic,strong) NSNumber * RegionId; // 地区id
@property (nonatomic,copy) NSString * MemberName;
@property (nonatomic,copy) NSString * RemarkName;


@property (nonatomic,copy)NSData *FaceImage;//头像

@property (nonatomic,strong) NSString *pinyin;//拼音

// 员工的
@property (nonatomic,copy) NSString *FaceUrl2; // 头像
@property (nonatomic,copy) NSString *Name; // 名字
@property (nonatomic,copy) NSString *XiaoYingCode;


@end



@interface ConnectModel : NSObject



@end



