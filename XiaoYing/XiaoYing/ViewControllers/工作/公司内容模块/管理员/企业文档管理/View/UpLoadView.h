//
//  UpLoadView.h
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileManageTableView;

@interface UpLoadView : UITableView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger completeProgressNum; //已经上传的进度

@property (nonatomic, assign) NSInteger uploadPreogressSpeed; //上传的速度

@end
