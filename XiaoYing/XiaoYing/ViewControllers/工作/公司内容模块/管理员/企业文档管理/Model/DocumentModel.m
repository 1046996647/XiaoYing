//
//  DocumentModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/11/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DocumentModel.h"

@implementation DocumentModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        
        self.documentId = dict[@"Id"];
        self.documentName = dict[@"Name"];
        self.documentUrl = [dict[@"Url"] isEqual:[NSNull null]]? @"" : dict[@"Url"];
        self.documentType = [dict[@"Type"] integerValue];
        self.documentCreateTime = dict[@"CreateTime"];
        self.departmentIds = dict[@"DepartmentIds"];
        self.documentSize = [dict[@"Size"] floatValue];
        self.documentCreatorId = dict[@"Creator"];
        
    }
    return self;
}

+ (DocumentModel*)modelFromDict:(NSDictionary*)dict
{
    DocumentModel *documentModel = [[DocumentModel alloc] initWithDict:dict];
    return documentModel;
}

+ (NSMutableArray*)getModelArrayFromModelArray:(NSArray*)array
{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        DocumentModel *model = [DocumentModel modelFromDict:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return mutableArray;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\ndocumentId:%@, \ndocumentName:%@, \ndocumentUrl:%@, \ndocumentType:%ld, \ndocumentCreateTime:%@, \ndepartmentIds:%@, \ndocumentSize:%ldkb, \ndocumentCreatorId:%@", self.documentId, self.documentName, self.documentUrl, self.documentType, self.documentCreateTime, self.departmentIds, self.documentSize, self.documentCreatorId];
}

@end
