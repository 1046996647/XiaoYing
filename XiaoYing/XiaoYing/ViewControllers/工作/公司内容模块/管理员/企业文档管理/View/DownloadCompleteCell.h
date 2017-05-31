//
//  DownloadCompleteCell.h
//  XiaoYing
//
//  Created by GZH on 16/6/30.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCompleteCell : UITableViewCell

//重命名
@property (nonatomic, strong) UIButton *reNameBtn;
@property (nonatomic, strong) UILabel *reNameLabel;

//删除
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *deleteLabel;

@property (nonatomic, copy) NSString *oldFolderId;
@property (nonatomic, copy) NSString *oldFolderName;

@end











