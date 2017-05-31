//
//  XYWorkAddPositionVc.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "XYCategoryModel.h"

@protocol XYWorkAddPositionDelegate <NSObject>
@optional
- (BOOL)contranstWithJobMessageByJobName:(NSString *)jobName;
@end

@interface XYWorkAddPositionVc : BaseSettingViewController

@property (nonatomic, strong) XYCategoryModel *categoryModel;
@property (nonatomic, weak) id<XYWorkAddPositionDelegate> delegate;

@end
