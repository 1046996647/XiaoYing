//
//  XYCategoryAndJobModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/11/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYCategoryModel.h"
#import "XYJobModel.h"

@interface XYCategoryAndJobModel : NSObject

@property (nonatomic, strong) XYCategoryModel *categoryModel;
@property (nonatomic, strong) NSMutableArray *jobModelArray;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)getModelArrayFromOriginArray:(NSArray *)array;
+ (XYCategoryAndJobModel *)modelFromDict:(NSDictionary *)dict;

@end
