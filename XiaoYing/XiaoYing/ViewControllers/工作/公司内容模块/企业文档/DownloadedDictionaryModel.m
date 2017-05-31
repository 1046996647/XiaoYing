//
//  DownloadedDictionaryModel.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DownloadedDictionaryModel.h"
#import "ZFSessionModel.h"
@implementation DownloadedDictionaryModel

+(NSDictionary*)getDownloadedDictionaryWithArray:(NSMutableArray *)array{
    NSMutableArray *picArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *musicArray = [NSMutableArray array];
    NSMutableArray *wordArray = [NSMutableArray array];
    NSMutableArray *excelArray = [NSMutableArray array];
    NSMutableArray *pptArray = [NSMutableArray array];
    NSMutableArray *zipArray = [NSMutableArray array];
    NSMutableArray *otherArray = [NSMutableArray array];
    for (ZFSessionModel *model in array) {
        if ([model.fileName hasSuffix:@".JPG"] || [model.fileName hasSuffix:@".PNG"]) {
            [picArray addObject:model];
        }else if ([model.fileName hasSuffix:@".MOV"] || [model.fileName hasSuffix:@".MP4"]){
            [videoArray addObject:model];
        }else if ([model.fileName hasSuffix:@".MP3"]){
            [musicArray addObject:model];
        }else if ([model.fileName hasSuffix:@".DOC"] || [model.fileName hasSuffix:@".DOCX"]){
            [wordArray addObject:model];
        }else if ([model.fileName hasSuffix:@".XLS"] || [model.fileName hasSuffix:@".XLSX"]){
            [excelArray addObject:model];
        }else if ([model.fileName hasSuffix:@".PPT"] || [model.fileName hasSuffix:@".PPTX"]){
            [pptArray addObject:model];
        }else if ([model.fileName hasSuffix:@".ZIP"] || [model.fileName hasSuffix:@".RAR"]){
            [zipArray addObject:model];
        }else{
            [otherArray addObject:model];
        }
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:picArray.copy forKey:@"图片"];
    [dictionary setObject:videoArray.copy forKey:@"视频"];
    [dictionary setObject:musicArray.copy forKey:@"音乐"];
    [dictionary setObject:wordArray.copy forKey:@"Word"];
    [dictionary setObject:excelArray.copy forKey:@"Excel"];
    [dictionary setObject:pptArray.copy forKey:@"PPT"];
    [dictionary setObject:zipArray.copy forKey:@"压缩包"];
    [dictionary setObject:otherArray.copy forKey:@"其他"];
    
    return dictionary.copy;
}


@end
