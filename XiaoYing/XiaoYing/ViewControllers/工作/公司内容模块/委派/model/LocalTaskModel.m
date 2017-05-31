//
//  LocalTaskModel.m
//  Demo
//
//  Created by ZWL on 16/6/14.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "LocalTaskModel.h"

@implementation FileModel

@end


@implementation DelegateTaskModel

@end

@implementation LocalTaskModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 数组首先需要个空的数组对象，不实例化会崩溃
        self.imagesArr = [NSMutableArray array];
        self.voicesArr = [NSMutableArray array];

    }
    return self;
}

@end
