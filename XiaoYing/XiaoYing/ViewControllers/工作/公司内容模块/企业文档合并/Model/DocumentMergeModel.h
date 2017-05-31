//
//  DocumentMergeModel.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/12.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface DocumentMergeModel : BaseModel

@property (nonatomic, copy) NSString *documentId;           //文档id
@property (nonatomic, copy) NSString *documentName;         //文档名
@property (nonatomic, copy) NSString *documentUrl;          //文档url
@property (nonatomic, assign) NSInteger documentType;       //文档类型
@property (nonatomic, copy) NSString *documentCreateTime;   //文档创建时间
@property (nonatomic, strong) NSArray *departmentIds;       //文档可见部门ids
@property (nonatomic, assign) NSInteger documentSize;       //文档大小
@property (nonatomic, copy) NSString *documentCreatorId;    //文档创建人id
@property (nonatomic, copy) NSString *thumbnailUrl;       //缩略图的url
@property (nonatomic, copy) NSString *documentDepartment; //文档所在的部门名称
@property (nonatomic, copy) NSString *deocumentDepartmentId; //文档所在部门id

// 搜索添加的
@property (nonatomic, copy) NSString *Catalog; //文档所在路径
@property (nonatomic, assign) NSInteger DocType;       //0 个人文档，1 公司文档，2 部门文档


- (instancetype)initWithDict:(NSDictionary*)dict;

+ (DocumentMergeModel*)modelFromDict:(NSDictionary*)dict;
+ (NSMutableArray*)getModelArrayFromModelArray:(NSArray*)array;

@end
