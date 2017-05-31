//
//  CreatFormworkVC.h
//  XiaoYing
//
//  Created by ZWL on 16/1/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//
#import "TempModel.h"

typedef void(^SendTempBlock)(TempModel *);

@interface CreatFormworkVC : UIViewController

@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) SendTempBlock sendTempBlock;
@property (nonatomic,strong) TempModel *model;



@end
