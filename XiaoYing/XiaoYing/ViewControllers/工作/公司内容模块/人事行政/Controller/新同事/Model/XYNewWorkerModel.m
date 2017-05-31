//
//  XYNewWorkerModel.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/22.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYNewWorkerModel.h"

@implementation XYNewWorkerModel

+(instancetype)memberWithName:(NSString *)name andTime:(NSString *)time andImage:(UIImage*)image
{
    XYNewWorkerModel * model = [[XYNewWorkerModel alloc]init];
    model.name = name;
    model.time = time;
    model.image = image;
    
    return model;
}

@end
