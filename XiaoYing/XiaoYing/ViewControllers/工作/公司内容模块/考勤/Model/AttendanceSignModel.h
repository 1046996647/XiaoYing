//
//  AttendanceSignModel.h
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceSignModel : NSObject

@property (nonatomic,copy) NSString *morningStr;
@property (nonatomic,copy) NSString *distanceStr;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,assign) NSInteger modelFlag;

@end
