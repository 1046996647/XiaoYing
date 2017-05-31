//
//  CreatorModel.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "CreatorModel.h"

@implementation CreatorModel

//通过字典给model赋值
-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        if (dic[@"ProfileId"]) {
            self.profileId = dic[@"ProfileId"];
        }
        self.employeeId = dic[@"EmployeeId"];
        self.departmentId = dic[@"DepartmentId"];
        self.employeeName = dic[@"EmployeeName"];
        self.mastJobName = dic[@"MastJobName"];
        self.faceURL = dic[@"FaceURL"];
        self.nick = dic[@"Nick"];
    }
    return self;
}
@end
