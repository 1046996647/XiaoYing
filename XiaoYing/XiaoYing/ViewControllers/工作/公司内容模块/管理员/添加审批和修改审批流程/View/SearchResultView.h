//
//  SearchView.h
//  XiaoYing
//
//  Created by ZWL on 16/10/14.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(void);

typedef void(^RefreshBlock)(void);

@interface SearchResultView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) NSMutableArray *approveArr;
//@property (nonatomic,assign) NSInteger mark;
@property (nonatomic,copy) SearchBlock searchBlock;
@property (nonatomic,copy) RefreshBlock refreshBlock;



@end
