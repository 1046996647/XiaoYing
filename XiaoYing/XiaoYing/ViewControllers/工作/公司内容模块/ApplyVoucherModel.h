//
//  ApplyVoucherModel.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/26.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyVoucherModel : NSObject
@property(nonatomic,copy)NSString *serialNumber;//申请单号
@property(nonatomic,copy)NSString *createrName;//申请创建者
@property(nonatomic,copy)NSString *approvalTypeName;//申请/审批类别
@property(nonatomic,copy)NSString *approvalCategoryName;//申请种类
@property(nonatomic,copy)NSString *approvalTag;//附加信息
@property(nonatomic,assign)NSInteger tagtype;//附加数据类型
@property(nonatomic,copy)NSString *passingTime;//通过时间
@property(nonatomic,copy)NSString *faceUrl;//申请人的头像
@property(nonatomic,copy)NSString *applyContent;//申请的内容
@property(nonatomic,copy)NSString *role;//申请人身份

//从字典中获取模型数组
+(NSArray*)getApplyVoucherModelArrayFromArray:(NSArray*)array;

//从字典中获取模型
+(ApplyVoucherModel*)getApplyVoucherModelFromDic:(NSDictionary*)dic;
@end
