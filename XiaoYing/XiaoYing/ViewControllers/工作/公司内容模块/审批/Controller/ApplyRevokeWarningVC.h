//
//  ApplyRevokeWarningVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block) (void);
@interface ApplyRevokeWarningVC : UIViewController
@property(nonatomic,copy)Block sureBlock;//点击确定后的block
@end
