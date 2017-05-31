//
//  FileManangeCell.h
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemControl.h"
#import "CompanyFileManageModel.h"

@protocol FileManangeCellDelegate <NSObject>

- (void)refreshTableView;

@end

typedef NS_ENUM(NSInteger,MarkType)
{
    MarkTypeEdit,
    MarkTypeSelected
};

@interface FileManangeCell : UITableViewCell

@property (nonatomic,strong) ItemControl *fileControl;
@property (nonatomic,strong) UILabel *fileLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *fileSizeLab;
@property (nonatomic,strong) ItemControl *editControl;
@property (nonatomic,strong) ItemControl *selectedControl;

@property (nonatomic,assign) MarkType markType;
@property (nonatomic,strong) CompanyFileManageModel *model;
@property (nonatomic,weak) id<FileManangeCellDelegate> delegate;

@end
