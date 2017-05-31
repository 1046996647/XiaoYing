//
//  CompanyDetailModel.h
//  XiaoYing
//
//  Created by GZH on 16/10/5.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDetailModel : NSObject

@property (nonatomic, strong)NSString *Content;
@property (nonatomic, strong)NSString *CreateTime;
@property (nonatomic, strong)NSString *Creator;
@property (nonatomic, strong)NSString *Id;
@property (nonatomic, strong)NSArray *Rangs;
@property (nonatomic, strong)NSString *Title;
-(instancetype)initWithDic:(NSDictionary*)dic;
+ (NSArray*)getModelArrayFromModelArray:(NSArray*)array;
+ (CompanyDetailModel*)modelFromDic:(NSDictionary*)dic;
@end
