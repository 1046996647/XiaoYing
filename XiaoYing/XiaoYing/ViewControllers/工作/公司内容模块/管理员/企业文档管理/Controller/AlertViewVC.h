//
//  AlertViewVC.h
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^eventBlock)();

@interface AlertViewVC : UIViewController

- (void)addAlertMessageWithAlertName:(NSString *)name andEventBlock:(eventBlock)block;

@end
