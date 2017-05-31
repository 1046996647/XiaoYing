//
//  TransportedCell.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFSessionModel;
@interface TransportedCell : UITableViewCell

@property (nonatomic, strong) UIImageView *markImageView; //标志图标
@property (nonatomic, strong) UILabel *fileNameLabel; //文件名称
@property (nonatomic, strong) UILabel *transportDestinationLabel; //文件传输目的地
@property (nonatomic, strong) UILabel *fileSizeLabel; //文件大小

- (void)getModel:(ZFSessionModel *)model;

@end




