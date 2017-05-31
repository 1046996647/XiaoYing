//
//  StepsView.h
//  XiaoYing
//
//  Created by GZH on 16/7/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsView : UITableView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


@property (nonatomic, strong)XYSearchBar *m_searchBar;
@property (nonatomic, strong)NSMutableArray *sunUnitArray;

@property (nonatomic, strong)NSMutableArray *unitButtonArray;
@end
