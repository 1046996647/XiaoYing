//
//  SelectWorkmateView.h
//  XiaoYing
//
//  Created by ZWL on 16/11/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectWorkmateView : UIView

// 选中的人
@property (nonatomic, strong)NSMutableArray *selectedArr;
@property (nonatomic,strong) UITableView *tableView;
// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;

@end
