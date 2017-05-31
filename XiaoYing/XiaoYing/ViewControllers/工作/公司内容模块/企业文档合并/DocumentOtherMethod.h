//
//  DocumentOtherMethod.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/2/13.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentOtherMethod : NSObject

//通过文件名称得到其对应的默认缩略图名称
+ (UIImage *)getDocumentThumImageWithfileName:(NSString *)name;

@end
