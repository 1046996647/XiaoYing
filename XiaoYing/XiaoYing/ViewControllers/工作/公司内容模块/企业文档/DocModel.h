//
//  DocModel.h
//  XiaoYing
//
//  Created by 王思齐 on 16/12/13.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocModel : NSObject
@property(nonatomic,strong)NSString *CatID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *creatTime;
@property(nonatomic,assign)NSInteger size;
@property(nonatomic,assign)BOOL isSelected;
// 得到model数组
+ (NSArray*)getModelArrayFromModelArray:(NSArray*)array;

// 从字典中得到model
+ (DocModel*)modelFromDic:(NSDictionary*)dic;
@end
