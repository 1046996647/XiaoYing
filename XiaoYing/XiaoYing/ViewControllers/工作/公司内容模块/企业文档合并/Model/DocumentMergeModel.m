//
//  DocumentMergeModel.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/12.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DocumentMergeModel.h"

@implementation DocumentMergeModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        
        self.documentId = [dict[@"Id"] isEqual:[NSNull null]]? @"" : dict[@"Id"];
        self.documentName = [dict[@"Name"] isEqual:[NSNull null]]? @"" : dict[@"Name"];
        self.documentUrl = [dict[@"Url"] isEqual:[NSNull null]]? @"" : dict[@"Url"];
        self.documentType = [dict[@"Type"] integerValue];
        self.documentCreateTime = dict[@"CreateTime"];
        self.departmentIds = [dict[@"DepartmentIds"] isEqual:[NSNull null]]? @"" : dict[@"DepartmentIds"];
        self.documentSize = [dict[@"Size"] floatValue];
        self.documentCreatorId = dict[@"Creator"];
        self.thumbnailUrl = [dict[@"ThumbnailUrl"] isEqual:[NSNull null]]? @"" : dict[@"ThumbnailUrl"];
        self.documentDepartment = [dict[@"DepartmentName"] isEqual:[NSNull null]]? @"" : dict[@"DepartmentName"];
        self.deocumentDepartmentId = [dict[@"DepartmentId"] isEqual:[NSNull null]]? @"" : dict[@"DepartmentId"];
        
        // 搜索添加的
        self.DocType = [dict[@"DocType"] integerValue];
        self.Catalog = [dict[@"Catalog"] isEqual:[NSNull null]]? @"" : dict[@"Catalog"];
        
        //0 个人文档，1 公司文档，2 部门文档
        if (self.DocType == 0) {
            self.Catalog = [self.Catalog stringByReplacingOccurrencesOfString:@"ROOT" withString:@"个人文档"];
        }
        else if (self.DocType == 1) {
            self.Catalog = [self.Catalog stringByReplacingOccurrencesOfString:@"ROOT" withString:@"公司文档"];

        }
        else {
            self.Catalog = [self.Catalog stringByReplacingOccurrencesOfString:@"ROOT" withString:self.documentDepartment];

        }
    }
    return self;
}

+ (DocumentMergeModel*)modelFromDict:(NSDictionary*)dict
{
    DocumentMergeModel *documentModel = [[DocumentMergeModel alloc] initWithDict:dict];
    return documentModel;
}

+ (NSMutableArray*)getModelArrayFromModelArray:(NSArray*)array
{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        DocumentMergeModel *model = [DocumentMergeModel modelFromDict:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return mutableArray;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\ndocumentId:%@, \ndocumentName:%@, \ndocumentUrl:%@, \ndocumentType:%d, \ndocumentCreateTime:%@, \ndepartmentIds:%@, \ndocumentSize:%dkb, \ndocumentCreatorId:%@, \nthumbnailUrl:%@, \ndocumentDepartment:%@, \ndeocumentDepartmentId:%@", self.documentId, self.documentName, self.documentUrl, self.documentType, self.documentCreateTime, self.departmentIds, self.documentSize, self.documentCreatorId, self.thumbnailUrl, self.deocumentDepartmentId];
}

@end
