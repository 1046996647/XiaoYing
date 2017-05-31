//
//  showWarningVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/11/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block) (void);
@interface showWarningVC : UIViewController
@property(nonatomic,copy)Block sureBlock;//点击确定后的block
@end
