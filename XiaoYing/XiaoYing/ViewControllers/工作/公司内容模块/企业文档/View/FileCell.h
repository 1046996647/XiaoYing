//
//  FileManangeCell.h
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemControl.h"
#import "DocModel.h"

//@protocol FileCellDelegate <NSObject>
//
//- (void)refreshTableView;
//
//@end

//typedef NS_ENUM(NSInteger,CheckType)
//{
//    CheckTypeDownload,
//    CheckTypeSelected
//};

@interface FileCell : UITableViewCell

@property (nonatomic,strong) ItemControl *fileControl;
@property (nonatomic,strong) UILabel *fileLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *fileSizeLab;
@property (nonatomic,strong) ItemControl *editControl;
@property (nonatomic,strong) ItemControl *selectedControl;
@property (nonatomic,strong) UIButton *markBtn;
@property(nonatomic,copy)NSString *fileUrl;
//@property (nonatomic,assign) CheckType checkType;
//@property (nonatomic,weak) id<FileCellDelegate> delegate;
@property (nonatomic,strong) DocModel *model;


//@property (nonatomic, copy) void(^downloadCallBack)();



@end
