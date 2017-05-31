//
//  AddFriendModel.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/3.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "AddFriendModel.h"

@implementation AddFriendModel

- (instancetype)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        
        self.Viewed = dic[@"Viewed"];
    }
    return self;
}

@end
