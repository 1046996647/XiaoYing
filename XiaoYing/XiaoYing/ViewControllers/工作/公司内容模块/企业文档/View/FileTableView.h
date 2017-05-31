//
//  FileManageTableView.h
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCell.h"
#import "CompanyFileManageModel.h"
#import "DocModel.h"

@interface FileTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) CheckType checkType;
@property (nonatomic,strong) NSString *selectedState;

@property (nonatomic,strong) NSMutableArray *downContentDatas;
@property (nonatomic,strong) NSArray *modelArray;

@end
