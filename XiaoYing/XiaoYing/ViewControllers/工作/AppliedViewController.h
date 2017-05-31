//
//  AppliedViewController.h
//  XiaoYing
//
//  Created by ZWL on 15/10/21.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveHeader.h"

typedef void(^BlockArrayOfCompany)(NSMutableArray *array);

@interface AppliedViewController : UIViewController

@property (nonatomic, strong)BlockArrayOfCompany blockArrayOfCompany;

@end
