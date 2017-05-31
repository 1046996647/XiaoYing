//
//  NewExcutePeopleCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"
@interface DepartManagerAuthorityCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_personalLab;  //个性签名
    UIImageView *_markImg;
    UIImageView *_remindImg;
}
@property (nonatomic,strong) NSString *isManagerYesOrNo;
@property (nonatomic,strong) NSString *identifier;

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personal;
@property (nonatomic,strong) EmployeeModel *model;
@property (nonatomic,strong) UIButton *selectedControl;
@property (nonatomic, strong) NSString *currentDepartmentId;
// 假数据
@property (nonatomic,strong) NSString *title;

@end
