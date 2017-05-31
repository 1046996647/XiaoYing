//
//  LocalFileForUpload.h
//  XiaoYing
//
//  Created by GZH on 2017/1/17.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFSessionModel;

typedef void(^DocumentIDBlock)(ZFSessionModel *);

@interface LocalFileForUpload : UITableViewController

@property (nonatomic, copy)DocumentIDBlock documentIDBlock;

@end
