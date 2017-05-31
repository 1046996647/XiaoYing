//
//  DeleteViewController.h
//  XiaoYing
//
//  Created by ZWL on 16/1/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZFDownloadManager.h"

typedef void(^FileDeleteBlock)(void);


@interface DeleteViewController : UIViewController

@property (nonatomic,strong) NSArray *deleteArr;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString *urlStr;

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,copy) FileDeleteBlock fileDeleteBlock;

@end
