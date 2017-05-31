//
//  NewMemoryModel.h
//  Memory
//
//  Created by ZWL on 16/8/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FileType)
{
    FileTypeText,
    FileTypeImage
};

@interface NewMemoryModel : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSData *imgData;
@property (nonatomic,assign) float cellHeight;

//@property (nonatomic,strong) NSString *urlStr;


@property (nonatomic,assign) FileType fileType;
@property(nonatomic,strong)NSDictionary *dic;
@end
