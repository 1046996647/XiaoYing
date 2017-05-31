//
//  FileNameCompleteCell.h
//  XiaoYing
//
//  Created by GZH on 16/7/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileNameCompleteCell : UITableViewCell

//重命名
@property (nonatomic, strong) UIButton *reNameBtn;
@property (nonatomic, strong) UILabel *reNameLabel;

//可见范围
@property (nonatomic, strong) UIButton *visibleBtn;
@property (nonatomic, strong) UILabel *visibleLabel;

//移动
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UILabel *transferLabel;

//删除
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *deleteLabel;

@property (nonatomic, copy) NSString *oldFileId;
@property (nonatomic, copy) NSString *oldFileName;

@property (nonatomic, strong) NSMutableArray *departmentIdsArray;

@end
