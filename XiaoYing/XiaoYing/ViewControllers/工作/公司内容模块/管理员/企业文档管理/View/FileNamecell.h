//
//  FileNamecell.h
//  XiaoYing
//
//  Created by GZH on 16/7/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileNamecell : UITableViewCell

//开始、暂停
@property (nonatomic, strong)UIButton *upLoadBtn;
@property (nonatomic, strong)UILabel *upLoadLabel;

//可见范围
@property (nonatomic, strong)UIButton *visibleBtn;
@property (nonatomic, strong)UILabel *visibleLabel;

//删除
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, strong)UILabel *deleteLabel;

@end
