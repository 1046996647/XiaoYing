//
//  DownloadingCell.h
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemControl.h"
#import "ZFDownloadManager.h"

typedef void(^ZFDownloadBlock)(UIButton *);

@interface DownloadingCell : UITableViewCell

@property (nonatomic,strong) ItemControl *fileControl;
@property (nonatomic,strong) UILabel *fileLab;
@property (nonatomic,strong) UILabel *receivedDataLab;
@property (nonatomic,strong) UILabel *speedLab;
@property (nonatomic,strong) ItemControl *editControl;
@property (nonatomic,strong) ItemControl *selectedControl;
@property (nonatomic,strong) UIView *line;


@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *downloadBtn;
@property (nonatomic,strong) UILabel *downloadLab;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *deleteLab;

@property (nonatomic, copy  ) ZFDownloadBlock downloadBlock;
@property (nonatomic, strong) ZFSessionModel  *sessionModel;



@end


