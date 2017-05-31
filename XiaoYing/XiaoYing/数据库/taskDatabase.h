//
//  taskDatabase.h
//  SQLiteDemo
//
//  Created by ZWL on 15/10/14.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class taskModel;
@class ConnectWithMyFriend;
@class ConnectWithMyWorkmate;

@interface taskDatabase : NSObject

// 插入模型数据
+(BOOL)insertModal:(taskModel *)modal;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+(NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql WithFlag:(NSInteger)flag;

/**
 *  将数据库里面的数据进行分类，用于写于Plist文件中
 */
+(NSArray *)queryPrifile;

//插入同事
+(BOOL)insertWorkmate:(ConnectWithMyFriend *)friend;

//查询某位同事，如果传空，则查询所有同事
+(NSArray *)queryWorkmate:(NSString *)querySql;

//联系人  好友
//***********************************************

+(BOOL)insertFriendModal:(ConnectWithMyFriend *)friend;
+(NSMutableArray *)queryFriend:(NSString *)querySql;
+(void)deleteFriend:(ConnectWithMyFriend *)friend;
+(void)deleteFriendTableAllMessage;



@end
