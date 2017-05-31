//
//  FirstStartData.m
//  XiaoYing
//
//  Created by ZWL on 15/12/1.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "FirstStartData.h"

#import "FirstModel.h"
#import "StateItem.h"

static FirstStartData *firststartdata = nil;

@implementation FirstStartData

+(FirstStartData*)shareFirstStartData{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        firststartdata = [[FirstStartData alloc]init];
    });
    return firststartdata;
}
/*****************创建数据库列表*****************/
-(void)creatSQL{
    [taskDatabase initialize];
}
/*************当前任务的Plist文件************/
-(void)InfoTaskWayPlist:(NSArray*)arr{
    if (arr==nil) {
        NSArray *arrType=@[@1,@2,@9];
        NSMutableArray *infowayArr=[[NSMutableArray alloc]init];
        for (NSInteger i = 0; i<3; i++) {
            StateItem *item=[[StateItem alloc]init];
            item.CurrentTaskCount=@0;
            item.TotalCount=@0;;
            item.Type=arrType[i];
            [infowayArr addObject:item];
        }
        //将数据写入plist文件
        [[DataHandle shareHandleData]storeObjectToPlist:infowayArr forFileName:@"TaskInfo.plist"];
    }else{
        [[DataHandle shareHandleData]storeObjectToPlist:arr forFileName:@"TaskInfo.plist"];
    }
}
-(NSArray *)getInfoTaskWayPlist{
   return [[DataHandle shareHandleData]getDataAccordingToFileName:@"TaskInfo.plist"];
}
/*************个人中心的Plist文件**************/
-(void)PersonCentrePlist:(ProfileMyModel *)model{
    if (model == nil) {
        ProfileMyModel *model1=[[ProfileMyModel alloc]init];
        model1.Email=@"未设置";
        model1.Mobile=@"未设置";
        model1.Signature=@"未设置";
        model1.RegionId=0;
        model1.RegionName=@"未设置";
        model1.Address=@"未设置";
        model1.ProfileId=@"未设置";
        model1.FaceUrl=@"ying";
        model1.Nick=@"未设置";
        model.Gender=0;
        model1.Fullname=@"未设置";
        [NSKeyedArchiver archiveRootObject:model1 toFile:[self getdocumentPath:@"PersonCentre.plist"]];
    }else{
        [NSKeyedArchiver archiveRootObject:model toFile:[self getdocumentPath:@"PersonCentre.plist"]];
    }
    
    
}
-(ProfileMyModel*)getPersonCentrePlist{
    
    ProfileMyModel *p=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getdocumentPath:@"PersonCentre.plist"]];
    return p;
}
-(NSString *)getdocumentPath:(NSString *)plistName{
    //获取Documents路径
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentPath = [documentPath stringByAppendingPathComponent:plistName];
    
    
    return documentPath;
}
/*************用户信息的Plist文件**************/
-(void)UserPersonCenterModelPlist:(NSArray *)arr{
    if (arr==nil) {
        UserPersonCenterModel *model=[[UserPersonCenterModel alloc]init];
        //用户头像
        model.UserHeadUrl=@"默认图片";
        //用户姓名
        model.UserName=@"";
        //用户密码
        model.UserPassword=@"";
        NSArray *arr1=@[model];
        [NSKeyedArchiver archiveRootObject:arr1 toFile:[self getdocumentPath:@"UserPersonCenterMode.plist"]];

    }else{
        [NSKeyedArchiver archiveRootObject:arr toFile:[self getdocumentPath:@"UserPersonCenterMode.plist"]];
    }
}
-(NSArray *)getUserPersonCenterModelPlist{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getdocumentPath:@"UserPersonCenterMode.plist"]];;
}
/**
 *  用来公司详情的Plist文件
 */
-(void)ProfileCompanyModelPlist:(ProfileCompanyModel *)model{
    if (model==nil) {
        ProfileCompanyModel *model1 = [[ProfileCompanyModel alloc] init];
        model1.companyAddress = @"杭州";
        model1.departmentName = @"科技产业部";
        model1.positionName = @"iOS软件开发";
        model1.companyName = @"杭州赢萊金融信息服务有限公司";
        model1.userName = @"孟凡标";
        model1.companyTelephone = @"0571-2234540";
        [NSKeyedArchiver archiveRootObject:model1 toFile:[self getdocumentPath:@"ProfileCompanyModel.plist"]];
    }else{
        [NSKeyedArchiver archiveRootObject:model toFile:[self getdocumentPath:@"ProfileCompanyModel.plist"]];
    }
}
-(ProfileCompanyModel *)getProfileCompanyModelPlist{
    
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:[self getdocumentPath:@"ProfileCompanyModel.plist"]];;
}
@end
