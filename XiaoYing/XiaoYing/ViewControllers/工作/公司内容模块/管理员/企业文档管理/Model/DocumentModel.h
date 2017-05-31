//
//  DocumentModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/11/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentModel : NSObject

@property (nonatomic, copy) NSString *documentId;           //文档id
@property (nonatomic, copy) NSString *documentName;         //文档名
@property (nonatomic, copy) NSString *documentUrl;          //文档url
@property (nonatomic, assign) NSInteger documentType;       //文档类型
@property (nonatomic, copy) NSString *documentCreateTime;   //文档创建时间
@property (nonatomic, strong) NSArray *departmentIds;       //文档可见部门ids
@property (nonatomic, assign) NSInteger documentSize;       //文档大小
@property (nonatomic, copy) NSString *documentCreatorId;    //文档创建人id

- (instancetype)initWithDict:(NSDictionary*)dict;

+ (DocumentModel*)modelFromDict:(NSDictionary*)dict;
+ (NSMutableArray*)getModelArrayFromModelArray:(NSArray*)array;

@end
