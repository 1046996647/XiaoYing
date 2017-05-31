//
//  FrindView.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/2.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "SelectFriendView.h"
#import "ConnectModel.h"
#import "DetailTableViewCell.h"
#import "SearchFriendView.h"
#import "NSString+Utils.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "SearchFriendView.h"
#import "ChatHeaderView.h"



//*******************************************
@interface SelectFriendView () <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic, strong) NSMutableArray * myFriendArray; // 好友信息数组

@property (nonatomic, strong)XYSearchBar *searchBar;


@property (strong, nonatomic) SearchFriendView *searchView;


@end
//*******************************************
@implementation SelectFriendView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        //        _myFriendTabMark =1;
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        // 初始化数据
        [self initWithFriendData];
        
        // 创建视图
        [self loadMyFriendTabView];
        
        // 移除搜索视图
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeSearchView)
                                                     name:@"kRemoveSearchViewNotification"
                                                   object:nil];
    }
    return self;
}

- (void)removeSearchView
{
    [self searchBarCancelButtonClicked:self.searchBar];
    
}

/**
 *  初始化数据
 */
-(void)initWithFriendData
{
    //            从本地读取数据
    _myFriendArray = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
    
    _rowArr = [ContactDataHelper getFriendListDataBy:self.myFriendArray];
    _sectionArr = [ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
}

/**
 *  我的好友界面TableView
 */
-(void)loadMyFriendTabView{
    
    _myFriendtab =[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _myFriendtab.delegate =self;
    _myFriendtab.dataSource =self;
    _myFriendtab.rowHeight =58;
    _myFriendtab.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [_myFriendtab setSectionIndexColor:[UIColor darkGrayColor]];
    [_myFriendtab setSectionIndexBackgroundColor:[UIColor clearColor]];
    _myFriendtab.tableFooterView =[[UIView alloc]init];
    _myFriendtab.tableHeaderView = self.searchBar;
    [self addSubview:_myFriendtab];
    
}

#pragma mark --UITableViewDelegate 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _rowArr.count;
}

//每区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arr = _rowArr[section];
    return [arr count];
    
}

// 会使列表头视图查找框宽度变短（系统设计的）
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _sectionArr;
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
    return index-1;
}

// cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str =@"cell";
    DetailTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell =[[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.sendFriendBlock = ^(ConnectWithMyFriend *model)
        {
            
            if (model.isSelected) {
                
                if (![_selectedArr containsObject:model.ProfileId]) {
                    [_selectedArr addObject:model.ProfileId];
                    
                }
            }
            else {
                if ([_selectedArr containsObject:model.ProfileId]) {
                    [_selectedArr removeObject:model.ProfileId];
                    
                }
            }
            [_myFriendtab reloadData];
            // 数据刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataRefreshNotification" object:nil];
        };
    }

    cell.section = 1;
    cell.type = 1;
    ConnectWithMyFriend * myfriend = _rowArr[indexPath.section][indexPath.row];
    if ([_selectedArr containsObject:myfriend.ProfileId]) {
        myfriend.isSelected = YES;
    }
    else {
        myfriend.isSelected = NO;
    }
    cell.myfriend = myfriend;
    
    if ([_iDArr containsObject:myfriend.ProfileId]) {
        [cell.selectedControl setImage:[UIImage imageNamed:@"choice_gray"] forState:UIControlStateNormal];
        cell.selectedControl.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ChatHeaderView *headerView = [[ChatHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    [headerView setTitleString:[_sectionArr objectAtIndex:section+1]];
    
    return headerView;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;

}


// 选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (XYSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[XYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"查找好友";
        
    }
    return _searchBar;
}
- (SearchFriendView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchFriendView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, self.height-44)];
        _searchView.searchBar = self.searchBar;
        _searchView.selectedArr = self.selectedArr;
        _searchView.iDArr = self.iDArr;
        _searchView.clickAction = FriendViewClickActionTwo;
        __weak typeof(self) weakSelf = self;
        _searchView.searchBlock = ^(void) {
            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];
        };
        
    };
    return _searchView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
    [self.searchView.approveTable reloadData];
    [self addSubview:self.searchView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempResults = [NSMutableArray array];
    for (ConnectWithMyFriend *friend in _myFriendArray) {
        
        if ([friend.Nick containsString:searchText]) {
            [tempResults addObject:friend];
            
        }
    }
    self.searchView.approveArr = tempResults;
    [self.searchView.approveTable reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //    [self.searchView.approveArr removeAllObjects];
    //    self.searchView.approveArr = nil;
    [self.searchView removeFromSuperview];
    self.searchView = nil;
    //    _searchBar.frame = CGRectMake(0, 64, kScreen_Width, 44);
    
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
}


@end
