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

@interface DownloadFinishCell : UITableViewCell

typedef void(^DeleteBlock)(ZFSessionModel *);


@property (nonatomic,strong) ItemControl *fileControl;
@property (nonatomic,strong) UILabel *fileLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *fileSizeLab;
@property (nonatomic,strong) ItemControl *editControl;
@property (nonatomic,strong) ItemControl *selectedControl;
@property (nonatomic,strong) UIImageView *markImgView;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,assign) CheckType checkType;

@property (nonatomic, strong) ZFSessionModel *sessionModel;



@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *renameBtn;
@property (nonatomic,strong) UILabel *renameLab;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *deleteLab;

@property (nonatomic, copy) DeleteBlock deleteBlock;


@end


