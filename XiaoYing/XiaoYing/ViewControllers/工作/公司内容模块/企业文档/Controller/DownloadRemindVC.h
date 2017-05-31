//
//  DownloadRemindVC.h
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block) (void);
@interface DownloadRemindVC : UIViewController
@property(nonatomic,assign)BOOL isSingle;
@property(nonatomic,copy)Block sureBlock;
@end
