//
//  FirstStartData.h
//  XiaoYing
//
//  Created by ZWL on 15/12/1.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileMyModel;
@class ProfileCompanyModel;

@interface FirstStartData : NSObject
//第一次启动APP初始化数据,返回一个单例对象
+(FirstStartData*)shareFirstStartData;

-(void)creatSQL;

/*当前任务的Plist文件*/
-(void)InfoTaskWayPlist:(NSArray*)arr;
/*得到任务Plist文件*/
-(NSArray *)getInfoTaskWayPlist;

/*存储个人中心的plist文件*/
-(void)PersonCentrePlist:(ProfileMyModel *)model;
/*得到个人中心的Plist文件信息*/
-(ProfileMyModel*)getPersonCentrePlist;

/*用户账号密码以及用户头像的Plist文件*/
-(void)UserPersonCenterModelPlist:(NSArray *)arr;

-(NSArray *)getUserPersonCenterModelPlist;

/**
 *  公司信息的Plist文件
 */
-(void) ProfileCompanyModelPlist:(ProfileCompanyModel *)model;
-(ProfileCompanyModel*)getProfileCompanyModelPlist;
@end
