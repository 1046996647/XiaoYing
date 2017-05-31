//
//  PushViewVC.h
//  XiaoYing
//
//  Created by GZH on 16/8/9.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushViewVCDelegate <NSObject>

- (void)agreeCompanyAction;
- (void)deleteCompanyAction;
- (void)refusecompanyAction;

@end


@interface PushViewVC : UIViewController

@property (nonatomic, strong)NSString *maskStr;
@property (nonatomic, strong)NSString *queueID;
@property (nonatomic )NSInteger index;

@property (nonatomic, assign)id<PushViewVCDelegate>delegate;

@end
