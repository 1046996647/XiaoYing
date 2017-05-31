//
//  NoticeCell.h
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyDetailModel;
@interface NoticeCell : UITableViewCell

//@property (nonatomic,strong) UILabel *labDepartment;//公告部门

@property (nonatomic,strong) UIButton *selectbtn;//选择按钮
//- (void)getModel:(CompanyDetailModel *)model;
@property(nonatomic,strong)CompanyDetailModel *model;
@property(nonatomic,assign)BOOL isDepartment;//是否是部门公告
@end
