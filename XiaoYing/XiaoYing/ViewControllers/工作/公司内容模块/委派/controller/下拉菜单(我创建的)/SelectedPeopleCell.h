//
//  SelectedPeopleCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"

typedef void(^DeleteEmpBlock)(EmployeeModel *);


@interface SelectedPeopleCell : UICollectionViewCell
{
    UIImageView *_titleImg;     // 图标
    UILabel *_applyPeople;      // 申请人
//    UIButton *_deleteBtn;
//    UILabel *_dutyLab;
}
@property (nonatomic,strong) UILabel *dutyLab;
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) EmployeeModel *model;
@property (nonatomic,copy) DeleteEmpBlock deleteBlock;


@end
