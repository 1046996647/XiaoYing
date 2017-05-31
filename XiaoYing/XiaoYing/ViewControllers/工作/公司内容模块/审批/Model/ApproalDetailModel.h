//
//  ApproalDetailModel.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApproalDetailModel : NSObject

@property(nonatomic,copy)NSString *typeName;//申请种类名称
@property(nonatomic,assign)NSInteger tagType;//附加信息类型，金额，天数，无
@property(nonatomic,strong)NSDictionary *creator;//申请人基本信息
@property(nonatomic,copy)NSString *departmentName;//申请人所在部门名称
@property(nonatomic,copy)NSString *categoryId;//审批类别ID
@property(nonatomic,copy)NSString *categroyName;//审批类别
@property(nonatomic,copy)NSString *typeId;//审批种类ID
@property(nonatomic,copy)NSString *requestSerialNumber;//审批申请的序号
@property(nonatomic,copy)NSString *remark;//申请说明
@property(nonatomic,copy)NSString *approvalTag;//附加信息值
@property(nonatomic,strong)NSDate *sendDateTime;//申请发出的时间
@property(nonatomic,strong)NSArray *images;//图片URL数组
@property(nonatomic,strong)NSArray *voices;//语音URL数组
@property(nonatomic,strong)NSArray *flows;//各个流程节点的批复状态与说明

//通过字典给Model的各属性赋值
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
