//
//  MaintainCompanyView.h
//  XiaoYing
//
//  Created by GZH on 16/7/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintainCompanyView : UITableView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong)XYSearchBar *m_searchBar;


@property (nonatomic, strong)NSMutableArray *subUnitArray;




@end
