//
//  NoticeViewController.h
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
@class CompanyNoticeView;
@class DepartmentNoticeView;

@interface NoticeViewController : BaseSettingViewController

@property (nonatomic,strong) CompanyNoticeView *companyView;
@property (nonatomic,strong) DepartmentNoticeView *departmentView;

@property (nonatomic,strong) UIView *viewLine;//公告与公司下面的线
@property (nonatomic,strong) UIButton *companybt;//公司button
@property (nonatomic,strong) UIButton *departmentbt;//部门bu
@property (nonatomic,strong) UIButton *screenBtn;  //筛选button
@property (nonatomic,strong) UILabel *labelLine; //部门与筛选中间的分割线
@property (nonatomic,strong) UIButton *belowBtn;  //下层遮盖
@property (nonatomic,strong) UIView *screenrView;  //筛选视图

-(void)initUI;

@end
