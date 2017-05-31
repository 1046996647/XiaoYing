//
//  XYEditModel.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCategoryModel : NSObject

@property(nonatomic, copy) NSString * categoryName;
@property(nonatomic, assign) NSInteger positionCount;
@property(nonatomic, copy) NSString *categoryId;

-(instancetype)initWithDict:(NSDictionary*)dict;
+ (XYCategoryModel *)modelFromDict:(NSDictionary*)dict;

@end
