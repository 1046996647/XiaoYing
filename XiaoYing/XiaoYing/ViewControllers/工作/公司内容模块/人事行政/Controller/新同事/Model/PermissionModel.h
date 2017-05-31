//
//  PermissionModel.h
//  XiaoYing
//
//  Created by GZH on 16/9/23.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionModel : NSObject

@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *Name;
@property (nonatomic, strong)NSString *ParentID;
@property (nonatomic, strong)NSString *Enable;
@property (nonatomic, strong)NSString *FuncList;
@end
