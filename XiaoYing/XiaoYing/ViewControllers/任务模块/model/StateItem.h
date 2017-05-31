//
//  StateItem.h
//  XiaoYing
//
//  Created by ZWL on 15/11/5.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateItem : NSObject<NSCoding>
@property (nonatomic,retain)NSNumber *CurrentTaskCount;
@property (nonatomic,retain)NSNumber *TotalCount;
@property (nonatomic,retain)NSNumber *Type;
@end
