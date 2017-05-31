//
//  DelegateDetailsTableView.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateTasksTableView.h"

@interface DelegateDetailsTableView : UITableView

@property (nonatomic,strong) UICollectionView *CV;                          //集合视图
@property (nonatomic,strong) DelegateTasksTableView *cellTasks;             //任务的表格视图
@property (nonatomic,strong) UILabel *delegateTitle;                        //委派标题
@property (nonatomic,strong) UILabel *progressTitle;                        //进度标题
@property (nonatomic,strong) UIImageView *progressImage;                    //进度条
@property (nonatomic,strong) UILabel *delegatePeopleTitle;                  //委派人标题
@property (nonatomic,strong) UILabel *delegatePeopleName;                   //委派人姓名
@property (nonatomic,strong) UILabel *startTimeTitle;                       //开始时间标题
@property (nonatomic,strong) UILabel *startDetailedTime;                    //开始的详细时间
@property (nonatomic,strong) UILabel *endTimeTitle;                         //结束时间标题
@property (nonatomic,strong) UILabel *endDetailedTime;                      //结束的详细时间
@property (nonatomic,strong) UILabel *performPeopleCollection;              //执行人集合
@property (nonatomic,strong) UIButton *scalingBtn1;                         //展开收起按钮;
@property (nonatomic,strong) UIButton *scalingBtn2;                         //展开收起按钮;
@property (nonatomic,strong) UIImageView *line;                             //线
@property (nonatomic,strong) NSMutableArray *arr;


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
