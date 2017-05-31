//
//  ApplicationMessageModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationMessageModel : NSObject

@property (nonatomic, copy) NSString *requestSerialNumber; //审批编号
@property (nonatomic, copy) NSString *typeName; //审批种类名称
@property (nonatomic, copy) NSString *typeId; //审批种类ID
@property (nonatomic, assign)NSInteger tagType; //附加值种类
@property (nonatomic, copy) NSString *approvalTag; //附加信息值
@property (nonatomic, copy) NSString *passDateTime; //显示已用时间
@property (nonatomic, copy) NSString *remark; //审批说明
@property (nonatomic, strong) NSMutableArray *imagesArray; //图片数组，已经解码

@property (nonatomic, strong) NSArray *originImagesUrlArray;
@property (nonatomic, strong) NSArray *originImagesIdArray;

- (instancetype)initWithDict:(NSDictionary*)dict;

+ (ApplicationMessageModel*)modelFromDict:(NSDictionary*)dict;

@end
