//
//  DocumentOtherMethod.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/2/13.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DocumentOtherMethod.h"

@implementation DocumentOtherMethod

+ (UIImage *)getDocumentThumImageWithfileName:(NSString *)name
{
    //取后缀
    long strLength = [name length];
    NSString *tailStr = [[NSString alloc] init];
    for (long i = strLength - 1; i >= 0; i --) {
        if ([name characterAtIndex:i] == '.') {
            tailStr = [[name substringFromIndex:i] lowercaseString];
        }
    }

    //后缀名分类
    NSMutableArray *zipArr = @[@".zip", @".rar"].mutableCopy;
    NSMutableArray *wordArr = @[@".word"].mutableCopy;
    NSMutableArray *pptArr = @[@".ppt"].mutableCopy;
    NSMutableArray *excelArr = @[@".excel"].mutableCopy;
    NSMutableArray *musicArr = @[@".mp3"].mutableCopy;
    NSMutableArray *videoArr = @[@".mp4"].mutableCopy;
    
    NSArray *tailArr = @[zipArr, wordArr, pptArr, excelArr, musicArr, videoArr];
    
    //对应的缩略图
    NSMutableArray *thumImageName = [NSMutableArray array];
    thumImageName = @[@"zip-file", @"word", @"ppt", @"excel", @"music", @"video", @"other"].mutableCopy;
    
    //匹配
    __block NSInteger num;
    [tailArr enumerateObjectsUsingBlock:^(NSMutableArray *tempArr, NSUInteger idx1, BOOL * _Nonnull stop1) {
        
        [tempArr enumerateObjectsUsingBlock:^(NSString *tail, NSUInteger idx2, BOOL * _Nonnull stop2) {
            
            if ([tail isEqualToString:tailStr]) {
                
                num = idx1;
                *stop1 = YES;
                *stop2 = YES;
            }else {
                num = thumImageName.count - 1;
            }
        }];
        
    }];
    
    //返回缩略图
    return [UIImage imageNamed:thumImageName[num]];
}

@end
