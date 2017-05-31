//
//  NoticeManagerViewCell.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetailModel.h"
@interface NoticeManagerViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *selectbtn;//右上角的选择按钮
@property (nonatomic,strong) UIImageView *imageviewheard;//添加图片
@property (nonatomic,strong) UILabel *labTitle;//标题
@property (nonatomic,strong) UILabel *labName;//发出公告人
@property (nonatomic,strong) UILabel *labContent;//公告内容
@property (nonatomic,strong) UILabel *labTime;//公告时间
@property(nonatomic,strong) CompanyDetailModel *model;



@end
