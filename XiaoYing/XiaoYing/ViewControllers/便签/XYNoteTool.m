//
//  XYNoteTool.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYNoteTool.h"
#import "XYNoteModel.h"
#define BQLSQLITE_NAME @"modals.sqlite"

static FMDatabase *_fmdb;

@implementation XYNoteTool

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:BQLSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, NoteID INTEGER NOT NULL, NoteContent TEXT NOT NULL, NoteTime TEXT NOT NULL);"];
}


//添加数据
+ (BOOL)insertModel:(XYNoteModel *)model {
    
    return [_fmdb executeUpdate:@"INSERT INTO t_modals(NoteID, NoteContent, NoteTime) VALUES (?,?,?)",[NSString stringWithFormat:@"%ld",model.NoteID],[NSString stringWithFormat:@"%@",model.NoteContent],[NSString stringWithFormat:@"%@",model.NoteTime]];
    
}


//获取数据库中的数据
+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_modals;";
        
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *NoteID = [set stringForColumn:@"NoteID"];
        NSString *NoteContent = [set stringForColumn:@"NoteContent"];
        NSString *NoteTime = [set stringForColumn:@"NoteTime"];
        
        XYNoteModel *model = [XYNoteModel modelWith:NoteID.intValue content:NoteContent time:NoteTime];
        [arrM addObject:model];
    }
    return arrM;
}

+ (BOOL)deleteData:(XYNoteModel *)deleteModel {
    
    return [_fmdb executeUpdate:@"DELETE FROM t_modals WHERE NoteID = ?",[NSString stringWithFormat:@"%ld",deleteModel.NoteID]];
    
    //删除所有数据
    /*
     if (deleteSql == nil) {
     deleteSql = @"DELETE FROM t_modals";
     }
     return [_fmdb executeUpdate:deleteSql];
     */
}

//修改数据
+ (BOOL)modifyData:(XYNoteModel *)modifyModel {
    
    return [_fmdb executeUpdate:@"UPDATE t_modals SET NoteContent = ? , NoteTime = ? WHERE NoteID = ?",[NSString stringWithFormat:@"%@",modifyModel.NoteContent],[NSString stringWithFormat:@"%@",modifyModel.NoteTime],[NSString stringWithFormat:@"%ld",modifyModel.NoteID]];
    
}

@end



