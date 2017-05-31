//
//  XYNoteModel.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYNoteModel : NSObject

@property (nonatomic, assign) NSInteger NoteID; // 备忘录编号
@property (nonatomic, copy) NSString *NoteContent; // 备忘录内容
@property (nonatomic, copy) NSString *NoteTime; // 备忘录时间
@property(nonatomic,copy)NSString * NoteSecond;

+ (instancetype)modelWith:(NSInteger )NoteID content:(NSString *)NoteContent time:(NSString *)NoteTime;

@end
