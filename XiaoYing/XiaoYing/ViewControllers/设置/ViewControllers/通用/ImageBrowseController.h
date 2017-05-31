//
//  ImageBrowseController.h
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"
@class ImageBrowseController;

@protocol ImageBrowseControllerDelegate <NSObject>

- (void)dismiss;

@end

@interface ImageBrowseController : BaseSettingViewController

@property (nonatomic,strong) UIImage *img;
@property (nonatomic,strong) id<ImageBrowseControllerDelegate> delegate;

@end
