//
//  TransportingCell.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DocumentUploadFileModel;

@interface TransportingCell : UITableViewCell

@property (nonatomic, strong) DocumentUploadFileModel *documentUploadFileModel;

@property (nonatomic, strong) UIImageView *markImageView; //标志图标
@property (nonatomic, strong) UILabel *fileNameLabel; //文件名称
@property (nonatomic, strong) UILabel *transportProgressLabel; //文件传输进程
@property (nonatomic, strong) UILabel *transportStateLabel; //文件传输状态
@property (nonatomic, strong) UIButton *extandBtn; //扩展按钮




@end
