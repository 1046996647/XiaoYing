//
//  RenameVC.h
//  XiaoYing
//
//  Created by ZWL on 16/7/14.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FileRenameBlock)(NSString *);


@interface RenameVC : UIViewController

@property (nonatomic,strong) NSString *currentText;

@property (nonatomic,copy) FileRenameBlock fileRenameBlock;


@end
