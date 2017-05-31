//
//  taskDatabase.m
//  SQLiteDemo
//
//  Created by ZWL on 15/10/14.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "taskDatabase.h"
#import "StateItem.h"
#import "StringChangeDate.h"
#import "DateTool.h"
#import "taskModel.h"
#import "ConnectModel.h"

#define LVSQLITE_NAME @"task.sqlite"

static FMDatabase *_fmdb;

//用于在选择语句的时候用这个数组
static NSMutableArray *arrM;

//用来存储本周的信息的数组
static NSMutableArray *arrN;
static NSMutableArray *arrT;

@implementation taskDatabase

//在第一次调用这一个类的时候调用这个函数
+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    
    NSLog(@"%@",filePath);
    _fmdb = [FMDatabase databaseWithPath:filePath];
  
    
    [_fmdb open];
    
    if ([_fmdb open] == 1) {
        /**********************已经上传到服务器的任务*******************/
        [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(TaskId INTEGER NOT NULL PRIMARY KEY,TaskAddTime TEXT, TaskExpiresTime TEXT,TaskFlag  INTEGER,TaskRemark TEXT,TaskState INTEGER NOT NULL,TaskTime TEXT,TaskTitle TEXT,TaskDay TEXT,TaskUpAndDown INTEGER);"];
//       创建好友页面的表
        [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS connect_friend(ProfileId TEXT NOT NULL PRIMARY KEY,FaceUrl TEXT, Nick TEXT, FaceImage BLOB);"];
        
        [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS connect_workmate(ProfileId TEXT NOT NULL PRIMARY KEY,FaceUrl TEXT, Nick TEXT, OrgId TEXT,FaceImage BLOB);"];

    }else{
         NSLog(@"数据库表创建失败");
    }

}
//打开数据库
+(BOOL)openDatabase{
    return [_fmdb open];
}
//关闭数据库
+(BOOL)closeDatabase{
    return [_fmdb close];
}
// 联系人 同事
//********************************************
//插入同事
+(BOOL)insertWorkmate:(ConnectWithMyFriend *)friend{
    [_fmdb open];
    
    return [_fmdb executeUpdate:@"INSERT INTO connect_workmate (ProfileId, FaceUrl, Nick , OrgId, FaceImage) VALUES (?, ?, ?, ?, ?);",friend.ProfileId==NULL?@"NULL":friend.ProfileId, friend.FaceUrl==NULL?@"NULL":friend.FaceUrl, friend.Nick==NULL?@"NULL":friend.Nick, friend.OrgId==NULL?@"NULL":friend.OrgId,friend.FaceImage==NULL?@"NULL":friend.FaceImage];
}

//查询某位同事，如果传空，则查询所有同事
+(NSArray *)queryWorkmate:(NSString *)querySql{
    [_fmdb open];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    FMResultSet *set;
    if (querySql == nil) {
        set = [_fmdb executeQuery:@"SELECt *from connect_workmate;"];
    }else{
        set = [_fmdb executeQuery:@"SELECT *from connect_workmate Where ProfileId= ?",querySql];
    
    }
   
    while ([set next]) {
//        ConnectWithMyFriend *friend= [[ConnectWithMyFriend alloc]init];
//        friend.ProfileId = [set stringForColumn:@"ProfileId"];
//        friend.OrgId = [set stringForColumn:@"OrgId"];
//        friend.Nick = [set stringForColumn:@"Nick"];
//        friend.FaceUrl = [set stringForColumn:@"FaceUrl"];
//        friend.FaceImage = [set dataForColumn:@"FaceImage"];
//        [array addObject:friend];
        
    }
    [set close];
    return array;
    
}
//联系人 好友页面
//*********************************************
//插入数据
+(BOOL)insertFriendModal:(ConnectWithMyFriend *)friend{
    [_fmdb open];
     return   [_fmdb executeUpdate:@"INSERT INTO connect_friend(ProfileId, FaceUrl, Nick, FaceImage) VALUES (?, ?, ?, ?);", friend.ProfileId,friend.FaceUrl,friend.Nick,friend.FaceImage];
    
}

//查询某位好友，如果传空，则查询所有好友
+(NSMutableArray *)queryFriend:(NSString *)querySql{
    [_fmdb open];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    FMResultSet *set;
    if (querySql == nil) {
        set = [_fmdb executeQuery:@"SELECt *from connect_friend"];
    }else{
        set = [_fmdb executeQuery:@"SELECT *from connect_friend Where ProfileId= ?",querySql];
        
    }

    while ([set next]) {
        ConnectWithMyFriend *friend= [[ConnectWithMyFriend alloc]init];
        friend.ProfileId = [set stringForColumn:@"ProfileId"];
        friend.Nick = [set stringForColumn:@"Nick"];
        friend.FaceUrl = [set stringForColumn:@"FaceUrl"];
        friend.FaceImage = [set dataForColumn:@"FaceImage"];
        [array addObject:friend];
    }
    [set close];
    return array;
    
}

//删除某个好友
+(void)deleteFriend:(ConnectWithMyFriend *)friend{
    if([_fmdb open]){
        [_fmdb executeUpdate:@"DELETE FROM connect_friend WHERE ProfileId = ?",friend.ProfileId];
    }
}
//不是同一用户时，删除表中所有用户信息
+(void)deleteFriendTableAllMessage{
    if([_fmdb open]){
        [_fmdb executeUpdate:@"DELETE FROM connect_friend"];
    }
}

//  任务
//************ *********************************
// 插入模型数据
+(BOOL)insertModal:(taskModel *)modal{
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_modals(TaskId, TaskAddTime, TaskExpiresTime,TaskFlag,TaskRemark,TaskState,TaskTime,TaskTitle,TaskDay,TaskUpAndDown) VALUES ('%zd', '%@', '%@','%zd','%@','%zd','%@','%@','%@','%zd');", modal.TaskId, modal.TaskAddTime, modal.TaskExpiresTime,modal.TaskFlag,modal.TaskRemark,modal.TaskState,modal.TaskTime,modal.TaskTitle,modal.TaskDay,modal.TaskUpAndDown];
    
    return [_fmdb executeUpdate:insertSql];
}
/** 查询数据,如果 传空 默认会查询表中所有数据 */
+(NSArray *)queryData:(NSString *)querySql{
    
    NSString *mark;
    
    arrM = [NSMutableArray array];
    if ([querySql isEqualToString:@"所有任务"]) {
        querySql = @"SELECT * FROM t_modals;";
        
        mark=querySql;

        [self GetSQL:mark];
        
    }else if([querySql isEqualToString:@"本周任务"]){

         //本周的任务
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd&(EEEE)"];
        
        formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        NSLog(@"%@",currentTime);
        NSArray *curArr=[currentTime componentsSeparatedByString:@"&"];
       
        int daybyday = 0;
        if ([curArr[1] isEqualToString:@"(星期日)"]) {
            daybyday=-6;
        }else if ([curArr[1] isEqualToString:@"(星期六)"]){
            daybyday=-5;
        }else if ([curArr[1] isEqualToString:@"(星期五)"]){
            daybyday=-4;
        }else if ([curArr[1] isEqualToString:@"(星期四)"]){
            daybyday=-3;
        }else if ([curArr[1] isEqualToString:@"(星期三)"]){
            daybyday=-2;
        }else if ([curArr[1] isEqualToString:@"(星期二)"]){
            daybyday=-1;
        }else if ([curArr[1] isEqualToString:@"(星期一)"]){
            daybyday=0;
        }
        NSInteger i=0;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay fromDate:[NSDate date]];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        while (i<7) {
            i++;
            [adcomps setDay:daybyday];
            daybyday++;
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
            NSString *newData=[formatter stringFromDate:newdate];
            NSArray *newArr=[newData componentsSeparatedByString:@"&"];
            mark=[NSString stringWithFormat:@"SELECT * FROM t_modals WHERE TaskDay LIKE '%%%@%%'",newArr[0]];
            [self GetSQL:mark];

        }
    }else if([querySql isEqualToString:@"今日任务"]){

        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd&(EEEE)"];
        
        formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        NSArray *curArr=[currentTime componentsSeparatedByString:@"&"];
        //今天的任务
        mark=[NSString stringWithFormat:@"SELECT * FROM t_modals WHERE TaskDay LIKE '%%%@%%'",curArr[0]];
        [self GetSQL:mark];
    }else{
        //选择指定的任务
        mark=[NSString stringWithFormat:@"SELECT * FROM t_modals WHERE TaskTime LIKE '%%%@%%'",querySql];
        [self GetSQL:mark];
    }
    return arrM;
}
+(void)GetSQL:(NSString*)mark{
    
    FMResultSet *set = [_fmdb executeQuery:mark];
    
    while ([set next]) {
        NSString *TaskAddTime = [set stringForColumn:@"TaskAddTime"];
        NSString *TaskExpiresTime = [set stringForColumn:@"TaskExpiresTime"];
        NSInteger TaskFlag = [set intForColumn:@"TaskFlag"];
        NSInteger TaskId = [set intForColumn:@"TaskId"];
        NSString *TaskRemark = [set stringForColumn:@"TaskRemark"];
        NSInteger TaskState=[set intForColumn:@"TaskState"];
        NSString *TaskTime=[set stringForColumn:@"TaskTime"];
        NSString *TaskTitle=[set stringForColumn:@"TaskTitle"];
        NSString *TaskDay=[set stringForColumn:@"TaskDay"];
        NSInteger TaskUpAndDown = [set intForColumn:@"TaskUpAndDown"];
        if (TaskState == 1) {
            taskModel *modal=[[taskModel alloc]init];
            modal.TaskAddTime=TaskAddTime;
            modal.TaskExpiresTime=TaskExpiresTime;
            modal.TaskFlag=TaskFlag;
            modal.TaskId=TaskId;
            modal.TaskState=TaskState;
            modal.TaskTime=TaskTime;
            modal.TaskTitle=TaskTitle;
            modal.TaskRemark=TaskRemark;
            modal.TaskDay=TaskDay;
            modal.TaskUpAndDown=TaskUpAndDown;
            
            [arrM addObject:modal];
        }
        
    }
}
/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql{
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_modals";
        
        return [_fmdb executeUpdate:deleteSql];
    }
    return [_fmdb executeUpdate:@"delete from t_modals where TaskTime=?",deleteSql];
    
}

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql WithFlag:(NSInteger)flag{
    
    return [_fmdb executeUpdate:@"UPDATE t_modals SET TaskFlag ='%zd' WHERE TaskTime ='%%%@%%'",flag,modifySql];
}
/**
 *  用来筛选数据来写入Plist文件中
 */
+(NSArray *)queryPrifile{
    //在数据库中来找到需要写的Plist文件中
    NSMutableArray *arrPrifile = [[NSMutableArray alloc] init];
    
    [arrPrifile addObject:[self getSQLPrifile:@"1"]];
    [arrPrifile addObject:[self getSQLPrifile:@"2"]];
    [arrPrifile addObject:[self getSQLPrifile:@"9"]];
    
    return arrPrifile;
}
+(StateItem*)getSQLPrifile:(NSString*)str{
    StateItem *item=[[StateItem alloc]init];
    arrN = [[NSMutableArray alloc]init];
    arrT = [[NSMutableArray alloc] init];
    if ([str isEqualToString:@"1"]) {
       NSString * querySql = @"SELECT * FROM t_modals;";
        NSString * mark=querySql;
        BOOL sucess = [self GetSQL1:mark];
        if (sucess) {
            item.Type = @9;
            item.CurrentTaskCount = [[NSNumber alloc]initWithInteger:arrN.count];
            item.TotalCount = [[NSNumber alloc]initWithInteger:arrT.count];
            
        }else{
            
        }
    }else if ([str isEqualToString:@"2"]){
        //本周的任务
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd&(EEEE)"];
        
        formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        NSLog(@"%@",currentTime);
        NSArray *curArr=[currentTime componentsSeparatedByString:@"&"];
        
        int daybyday = 0;
        if ([curArr[1] isEqualToString:@"(星期日)"]) {
            daybyday=-6;
        }else if ([curArr[1] isEqualToString:@"(星期六)"]){
            daybyday=-5;
        }else if ([curArr[1] isEqualToString:@"(星期五)"]){
            daybyday=-4;
        }else if ([curArr[1] isEqualToString:@"(星期四)"]){
            daybyday=-3;
        }else if ([curArr[1] isEqualToString:@"(星期三)"]){
            daybyday=-2;
        }else if ([curArr[1] isEqualToString:@"(星期二)"]){
            daybyday=-1;
        }else if ([curArr[1] isEqualToString:@"(星期一)"]){
            daybyday=0;
        }
        NSInteger i=0;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay fromDate:[NSDate date]];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        while (i<7) {
            i++;
            [adcomps setDay:daybyday];
            daybyday++;
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
            NSString *newData=[formatter stringFromDate:newdate];
            NSArray *newArr=[newData componentsSeparatedByString:@"&"];
            NSString *mark=[NSString stringWithFormat:@"SELECT * FROM t_modals WHERE TaskDay LIKE '%%%@%%'",newArr[0]];
            [self GetSQL1:mark];
            
        }
        
        item.Type = @2;
        item.CurrentTaskCount = [[NSNumber alloc]initWithInteger:arrN.count];
        item.TotalCount = [[NSNumber alloc]initWithInteger:arrT.count];

        
    }else if ([str isEqualToString:@"9"]){
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd&(EEEE)"];
        
        formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        NSArray *curArr=[currentTime componentsSeparatedByString:@"&"];
        //今天的任务
        NSString * mark=[NSString stringWithFormat:@"SELECT * FROM t_modals WHERE TaskDay LIKE '%%%@%%'",curArr[0]];
        BOOL sucess = [self GetSQL1:mark];
        if (sucess) {
            item.Type = @1;
            item.CurrentTaskCount = [[NSNumber alloc]initWithInteger:arrN.count];
            item.TotalCount = [[NSNumber alloc]initWithInteger:arrT.count];
        }
        
    }
    return item;
}
+(BOOL)GetSQL1:(NSString*)mark{
    
    FMResultSet *set = [_fmdb executeQuery:mark];
    
    while ([set next]) {
        NSString *TaskAddTime = [set stringForColumn:@"TaskAddTime"];
        NSString *TaskExpiresTime = [set stringForColumn:@"TaskExpiresTime"];
        NSInteger TaskFlag = [set intForColumn:@"TaskFlag"];
        NSInteger TaskId = [set intForColumn:@"TaskId"];
        NSString *TaskRemark = [set stringForColumn:@"TaskRemark"];
        NSInteger TaskState=[set intForColumn:@"TaskState"];
        NSString *TaskTime=[set stringForColumn:@"TaskTime"];
        NSString *TaskTitle=[set stringForColumn:@"TaskTitle"];
        NSString *TaskDay=[set stringForColumn:@"TaskDay"];
        NSInteger TaskUpAndDown = [set intForColumn:@"TaskUpAndDown"];
        if (TaskState == 1) {
            taskModel *modal=[[taskModel alloc]init];
            modal.TaskAddTime=TaskAddTime;
            modal.TaskExpiresTime=TaskExpiresTime;
            modal.TaskFlag=TaskFlag;
            modal.TaskId=TaskId;
            modal.TaskState=TaskState;
            modal.TaskTime=TaskTime;
            modal.TaskTitle=TaskTitle;
            modal.TaskRemark=TaskRemark;
            modal.TaskDay=TaskDay;
            modal.TaskUpAndDown=TaskUpAndDown;
            
            [arrN addObject:modal];
            
            
            [arrT addObject:modal];

        }else{
            taskModel *modal=[[taskModel alloc]init];
            modal.TaskAddTime=TaskAddTime;
            modal.TaskExpiresTime=TaskExpiresTime;
            modal.TaskFlag=TaskFlag;
            modal.TaskId=TaskId;
            modal.TaskState=TaskState;
            modal.TaskTime=TaskTime;
            modal.TaskTitle=TaskTitle;
            modal.TaskRemark=TaskRemark;
            modal.TaskDay=TaskDay;
            modal.TaskUpAndDown=TaskUpAndDown;
            
            [arrT addObject:modal];
        }
        
        
    }
    
    return YES;
}
@end
