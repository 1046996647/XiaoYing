//
//  EditPersonVC.h
//  XiaoYing
//
//  Created by ZWL on 15/11/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
@class ProfileMyModel;

@interface EditPersonVC : BaseSettingViewController
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,retain) ProfileMyModel *mymodel;
@property (nonatomic,assign) NSInteger mark;
-(void)setContent:(NSString *)Content;
@end
