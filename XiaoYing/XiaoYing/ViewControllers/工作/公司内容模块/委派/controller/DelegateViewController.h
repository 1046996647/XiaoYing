//
//  DelegateViewController.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/9.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

@interface DelegateViewController : BaseSettingViewController

@property(strong,nonatomic) UIScrollView *delegateScrollView;               //委派主界面的滚动视图
@property(strong,nonatomic) UIButton *iCreated;                             //我创建的按钮
@property(strong,nonatomic) UIButton *iPerform;                             //我执行的按钮
@property(strong,nonatomic) UIImageView *buttonBackgroundLine;              //按钮下的线
@property(strong,nonatomic) UIImageView *backgroundOnTheRightLine;          //右边背景线
@property(strong,nonatomic) UIButton *screening;                            //筛选按钮
@property(strong,nonatomic) UIControl *screenInterface;                     //筛选背景界面
@property(strong,nonatomic) UIButton *ongoing;                              //筛选进行中按钮
@property(strong,nonatomic) UIButton *failure;                              //筛选失败按钮
@property(strong,nonatomic) UIButton *complete;                             //筛选完成按钮
@property(strong,nonatomic) UIButton *screeningDetermine;                   //筛选确定按钮
@property(strong,nonatomic) UIView *screeningView;                          //筛选视图
@property(strong,nonatomic) UIImageView *backgroundScreeningLineOne;        //筛选背景线一
@property(strong,nonatomic) UIImageView *backgroundScreeningLineSecond;     //筛选背景线二

@end
