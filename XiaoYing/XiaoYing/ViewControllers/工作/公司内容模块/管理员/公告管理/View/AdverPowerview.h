//
//  AdverPowerview.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdverPowerview : UIView

@property (nonatomic, retain)UIView *OraindryPeople;//允许发公告的人
@property (nonatomic, retain)UILabel *lineLabel;
@property (nonatomic, retain)UIView *nameOfpeople;
@property (nonatomic, retain)UIView *powerPeople;
@property (nonatomic, retain)UIView *CanDeletePeople;
@property (nonatomic, retain)UILabel *lineLabelTwo;
@property (nonatomic, retain)UIView *nameOfpeopleTwo;
@property(nonatomic,copy)NSString *departmentId;
@property(nonatomic,strong)NSMutableArray *applyPeopleArr;//允许申请发公告的人
@property(nonatomic,strong)NSMutableArray *approvalPersonArr;//审批公告的人
@property(nonatomic,strong)NSMutableArray *deletePeopleArr;//允许删除公告的人
@property(nonatomic,strong)NSMutableArray *applyDepArr;//允许申请发公告的部门的全体的人
@property(nonatomic,strong)NSMutableArray *approvalDepArr;//审批公告的人
@property(nonatomic,strong)NSMutableArray *deleteDepArr;//允许删除公告的部门的全体的人
@property(nonatomic,strong)UILabel *applypeopleLab;//允许申请发公告的人label
@property(nonatomic,strong)UILabel *approvalPersonLab;//审批公告的人label
@property(nonatomic,strong)UILabel *deletePeopleLab;//允许删除公告的人label

-(NSString *)nameStringFromIDArr:(NSMutableArray *)IDArr;
@end













