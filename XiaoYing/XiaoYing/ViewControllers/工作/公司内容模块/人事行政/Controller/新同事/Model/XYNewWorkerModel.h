//
//  XYNewWorkerModel.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/22.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYNewWorkerModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,strong)UIImage * image;
+(instancetype)memberWithName:(NSString *)name andTime:(NSString *)time andImage:(UIImage*)image;

@end
