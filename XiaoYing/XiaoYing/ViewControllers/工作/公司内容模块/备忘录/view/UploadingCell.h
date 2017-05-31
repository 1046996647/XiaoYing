//
//  UploadingCell.h
//  XiaoYing
//
//  Created by ZWL on 16/8/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemControl.h"
#import "WLUploadManager.h"

@interface UploadingCell : UITableViewCell

@property (nonatomic,strong) ItemControl *fileControl;
@property (nonatomic,strong) UILabel *fileLab;
@property (nonatomic,strong) UILabel *receivedDataLab;
@property (nonatomic,strong) UILabel *speedLab;
@property (nonatomic,strong) ItemControl *editControl;
@property (nonatomic,strong) ItemControl *selectedControl;


@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *downloadBtn;
@property (nonatomic,strong) UILabel *downloadLab;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *deleteLab;

@property (nonatomic, strong) WLUploadModel  *uploadModel;

@end
