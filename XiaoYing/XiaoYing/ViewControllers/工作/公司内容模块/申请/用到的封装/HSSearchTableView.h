//
//  HSSearchTableView.h
//  XiaoYing
//
//  Created by chenchanghua on 16/11/14.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSearchTableView : UIView

@property (nonatomic, strong, readonly) UISearchBar *searchBar;

@property (nonatomic, assign) CGRect beforeShowSearchBarFrame; //退出搜索时，搜索框显示的frame

- (HSSearchTableView *)initWithPreviousViewController:(UIViewController *)previousViewController searchResultTableView:(UITableView *)searchResultTableView searchResultDataArray:(NSMutableArray *)searchResultDataArray searchHappenBlock:(void(^)())block;

@end
