//
//  TaskItem.h
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

//用来存储主页面数据的数据模型

@interface TaskItem : NSObject
//图片的名字
@property (nonatomic,copy)NSString *ImageName_;
//分组的标题
@property (nonatomic,copy)NSString *TitleName_;
//任务的个数
@property (nonatomic,copy)NSString *TaskCount_;
//正在进行的任务个数
@property (nonatomic,copy)NSString *ProccedCount_;
@end
