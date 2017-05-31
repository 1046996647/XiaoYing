//
//  SendMemoryModel.h
//  Memory
//
//  Created by ZWL on 16/8/24.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BaseModel.h"

@interface SendMemoryModel : NSObject

/*
"Id": 1,
"Content": "sample string 2",
"CreateTime": "2016-08-24T15:58:53.0129905+08:00"
 */

@property (nonatomic,assign) NSInteger Id;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,assign) NSInteger HasImage;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,strong) NSString *urlStr;

//@property (nonatomic,assign) NSInteger ProfileId;
@property (nonatomic,strong) NSArray *dataArr;


- (instancetype)initWithContentsOfDic:(NSDictionary *)dic;

@end
