//
//  XYNoteTool.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class XYNoteModel;

@interface XYNoteTool : NSObject


// 插入模型数据
+ (BOOL)insertModel:(XYNoteModel *)model;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(XYNoteModel *)deleteModel;

/** 修改数据 */
+ (BOOL)modifyData:(XYNoteModel *)modifyModel;

@end
