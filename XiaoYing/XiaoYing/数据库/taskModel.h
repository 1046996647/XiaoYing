//
//  taskModel.h
//  SQLiteDemo
//
//  Created by ZWL on 15/10/14.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface taskModel : NSObject

//任务添加时间
@property (nonatomic,copy)NSString *TaskAddTime;
//任务的过期的时间
@property (nonatomic,copy)NSString *TaskExpiresTime;
//任务的重要程度
@property (nonatomic,assign)NSInteger TaskFlag;
//任务的ID
@property (nonatomic,assign)NSInteger TaskId;
//任务的内容
@property (nonatomic,copy)NSString *TaskRemark;
//任务是否完成的状态
@property (nonatomic,assign)NSInteger TaskState;
//任务时间提醒时间
@property (nonatomic,copy)NSString *TaskTime;
//任务的标题
@property (nonatomic,copy)NSString *TaskTitle;


//添加任务的时间:(在哪一天)
@property (nonatomic,copy)NSString *TaskDay;
//小旗图片
@property (nonatomic,copy)NSString *TaskImageName;
//标记任务是否上传到服务器 （0代表未上传到服务器1代表上传到服务器）
@property (nonatomic,assign)NSInteger TaskUpAndDown;


//标记任务的状态
@property (nonatomic,assign)NSInteger TaskMarkFlag;

+(NSString *)cutTimeString:(NSString *)str;

@end
