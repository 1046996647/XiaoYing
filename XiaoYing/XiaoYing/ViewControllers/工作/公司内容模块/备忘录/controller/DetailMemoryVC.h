//
//  DetailMemoryVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

typedef void(^RefreshBlock)(void);


@interface DetailMemoryVC : BaseSettingViewController

@property (nonatomic,strong) NSArray *dataArr;
;
@property (nonatomic,assign) NSInteger Id;

@property (nonatomic,copy) RefreshBlock refreshBlock;

@end
