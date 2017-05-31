//
//  SearchGroupListView.h
//  XiaoYing
//
//  Created by ZWL on 16/11/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(void);

@interface SearchGroupListView : UIView

@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) NSMutableArray *approveArr;

@property (nonatomic, strong)UISearchBar *searchBar;

@property (nonatomic,copy) SearchBlock searchBlock;

@end
