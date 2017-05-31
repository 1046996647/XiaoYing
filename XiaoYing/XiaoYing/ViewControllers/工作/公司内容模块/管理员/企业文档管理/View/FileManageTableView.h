//
//  FileManageTableView.h
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManangeCell.h"
#import "FileCell.h"
#import "CreateFolderController.h"

@interface FileManageTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger sectionTemp;
@property (nonatomic, assign) CGFloat tempHeight;

@property (nonatomic, strong) NSMutableArray *selectedArray;//点击标记数组
@property (nonatomic, strong) UIButton *downActionBtn;//点击的按钮

@property (nonatomic, strong) NSMutableArray *folderSectionArray; //文件夹的数组
@property (nonatomic, strong) NSMutableArray *ongingFileSectionArray; //正在上传文件的数组
@property (nonatomic, strong) NSMutableArray *completeFileSectionArray; //文件的数组

@end






