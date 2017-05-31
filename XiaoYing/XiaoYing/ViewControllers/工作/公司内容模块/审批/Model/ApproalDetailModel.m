//
//  ApproalDetailModel.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApproalDetailModel.h"

@implementation ApproalDetailModel

//通过字典给Model的各属性赋值
-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.typeName = dic[@"TypeName"];
        self.tagType = [dic[@"TagType"] integerValue];
        self.creator = dic[@"Creator"];
        self.departmentName = dic[@"DepartmentName"];
        self.categoryId = dic[@"CategoryId"];
        self.categroyName = dic[@"CategroyName"];
        self.typeId = dic[@"TypeId"];
        self.requestSerialNumber = dic[@"RequestSerialNumber"];
        self.remark = dic[@"Remark"];
        self.approvalTag = dic[@"ApprovalTag"];
        NSString *dateStr = dic[@"SendDateTime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.sendDateTime = [formatter dateFromString:dateStr];
        self.images = dic[@"Images"];
        self.voices = dic[@"Voices"];
        self.flows = dic[@"Flows"];
    }
    return self;
}
@end
