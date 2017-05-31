//
//  ImagePlayerViewController.h
//  XiaoYing
//
//  Created by ZWL on 16/1/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
typedef void(^MyBlock) (NSMutableArray *imageArray,NSMutableArray *imageIDArray);
@interface ImagePlayerViewController : BaseSettingViewController

@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property(nonatomic,strong)NSMutableArray *imageIDArray;//图片ID数组
@property(nonatomic,copy)MyBlock backBlock;
@property(nonatomic,assign)BOOL isApproal;//是否是从审批中的拒绝或者同意按钮跳过来的
@end
