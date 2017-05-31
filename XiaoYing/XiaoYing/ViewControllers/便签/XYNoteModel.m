//
//  XYNoteModel.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYNoteModel.h"

@implementation XYNoteModel

+ (instancetype)modelWith:(NSInteger )NoteID content:(NSString *)NoteContent time:(NSString *)NoteTime
{
    XYNoteModel *model = [[XYNoteModel alloc] init];
    model.NoteID = NoteID;
    model.NoteContent = NoteContent;
    model.NoteTime = NoteTime;
    return model;
}

@end
