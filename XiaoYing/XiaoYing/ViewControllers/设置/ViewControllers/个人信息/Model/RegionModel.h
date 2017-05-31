//
//  RegionModel.h
//  XiaoYing
//
//  Created by yinglaijinrong on 16/3/29.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseModel.h"

@interface RegionModel : BaseModel

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *ParentId;
@property (nonatomic,strong) NSString *RegionName;
@property (nonatomic,strong) NSNumber *RegionType;
@property (nonatomic,strong) NSNumber *IsCapital;

// 完整的地名
@property (nonatomic,strong) NSString *TotalRegionName;

@end
