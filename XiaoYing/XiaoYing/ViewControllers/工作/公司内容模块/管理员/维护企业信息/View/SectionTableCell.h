//
//  SectionTableCell.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DescriptionsModel;


@interface SectionTableCell : UITableViewCell

//2-4分区cell的赋值  str区分是不是企业信息的cell  （空）颜色不一样的区分
@property (nonatomic, strong) UILabel *SectionLabel;
- (void)getModel:(DescriptionsModel *)model andType:(NSString *)str;


//5分区cell的赋值 str区分是不是企业信息的cell   删除按钮是否显示
@property (nonatomic, strong) UILabel *backgroundLabel;//添加的描述
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *cellLabel;
@property (nonatomic, strong) UILabel *labelOnCell;
@property (nonatomic, strong) UIButton *deleteBtn;

- (void)getModelOfSection:(NSString *)sectionTitle
          AndDetailOfCell:(NSString *)detaelText;

@end
