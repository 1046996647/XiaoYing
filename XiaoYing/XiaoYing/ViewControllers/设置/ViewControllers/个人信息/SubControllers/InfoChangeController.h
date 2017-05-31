//
//  InfoChangeController.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/15.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

//@class InfoChangeController;
//@protocol InfoChangeControllerDelegate <NSObject>
//
//- (void)sendText:(NSString *)text;
//
//@end

@interface InfoChangeController : BaseSettingViewController

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSIndexPath *indexPath;

//@property (nonatomic,weak) id<InfoChangeControllerDelegate> delegate;

@end
