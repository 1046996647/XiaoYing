//
//  CreatorModel.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatorModel : NSObject

@property(nonatomic,copy)NSString *profileId;//账户编号
@property(nonatomic,copy)NSString *employeeId;//员工编号
@property(nonatomic,copy)NSString *departmentId;//所在部门ID
@property(nonatomic,copy)NSString *employeeName;//职工名称
@property(nonatomic,copy)NSString *mastJobName;//主要职务
@property(nonatomic,copy)NSString *faceURL;//头像地址-格式
@property(nonatomic,copy)NSString *nick;//昵称

//通过字典给model赋值
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
