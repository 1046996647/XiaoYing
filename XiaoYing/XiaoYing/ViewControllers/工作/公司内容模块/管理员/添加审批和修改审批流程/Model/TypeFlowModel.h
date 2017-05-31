//
//  TypeFlowModel.h
//  XiaoYing
//
//  Created by ZWL on 16/9/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseModel.h"

@interface TypeFlowModel : BaseModel

@property (nonatomic,strong) NSNumber *Rank;
@property (nonatomic,assign) BOOL Used;


@property (nonatomic,assign) NSInteger level;
@property (nonatomic,assign) NSInteger maxPower;
//@property (nonatomic,assign) BOOL Normal;


@property (nonatomic,assign) NSInteger unLimit;//1:无上限


@end
