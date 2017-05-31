//
//  FrindView.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/2.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "FriendView.h"
#import "ConnectModel.h"
#import "DetailTableViewCell.h"
#import "ConnectViewController.h"
#import "FriendDetailMessageVC.h"
#import <RongIMKit/RongIMKit.h>
#import "HeadPictureViewController.h"
#import "SearchFriendView.h"
#import "taskDatabase.h"
#import "NSString+Utils.h"
#import "ChatHeaderView.h"
#import "FriendRequestVC.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "SearchFriendView.h"


//*******************************************
@interface FriendView () <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    ConnectWithMyFriend *_selectedFriend;
    UILabel * searchLab; // 没有好友时显示 searchLab

    int _aCount;
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}
@property (nonatomic, strong) NSMutableArray * myFriendArray; // 好友信息数组
@property (nonatomic, strong) UITableView * myFriendtab; // 好友表视图
@property (nonatomic, strong)XYSearchBar *searchBar;

@property (nonatomic, strong) NSArray *requestArray; // 请求好友数组
@property (nonatomic, strong) MBProgressHUD *hud;

@property (strong, nonatomic) SearchFriendView *searchView;


@end
//*******************************************
@implementation FriendView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        //        _myFriendTabMark =1;
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        // 创建视图
        [self loadMyFriendTabView];
        
        // 初始化数据
        [self initWithFriendData];

        
//        __weak typeof(self) weakSelf = self;

//        _myFriendtab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            
//            [weakSelf initWithFriendData];
//        }];
        
        
        // 检测好友请求
        [self loadFriendRequest];
//        // 检测好友请求
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadFriendRequest)
                                                     name:kCheckFriendRequestNotification
                                                   object:nil];
        // 同意成功好友刷新
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initWithFriendData)
                                                     name:kAgreeFriendSuccessNotification
                                                   object:nil];
        
        // 是否是同事数据刷新
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(RefreshIsEmployee)
                                                     name:@"kRefreshIsEmployeeNotification"
                                                   object:nil];
        
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

- (void)RefreshIsEmployee
{
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    
    for (ConnectWithMyFriend *friend in _myFriendArray) {
        
        for (NSDictionary *aDic in employeesArr) {
            
            if ([aDic[@"ProfileId"] isEqualToString:friend.ProfileId]) {
                friend.isEmployee = YES;
                
                // 刷新会话列表信息操作
                //.........
            }
            else {
                friend.isEmployee = NO;

            }
        }
    }

    _rowArr=[ContactDataHelper getFriendListDataBy:self.myFriendArray];
    _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
    
    [_myFriendtab reloadData];
}

/**
 *  初始化数据
 */
-(void)initWithFriendData
{
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
//    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    _hud.labelText = @"加载中...";
    
    [AFNetClient GET_Path:MyFriendRequest completed:^(NSData *stringData, id JSONDict) {
        
//        [_hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.viewController.view];
            
        } else {
            
            NSMutableArray *arr =[[JSONDict objectForKey:@"Data"] mutableCopy];
            
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                ConnectWithMyFriend *friend = [[ConnectWithMyFriend alloc] initWithContentsOfDic:dic];
                [arrM addObject:friend];
                
                for (NSDictionary *aDic in employeesArr) {
    
                    if ([aDic[@"ProfileId"] isEqualToString:friend.ProfileId]) {
                        friend.isEmployee = YES;
                    }
                    else {
                        RCUserInfo * user =[[RCUserInfo alloc]init];
                        user.userId = friend.ProfileId;
                        user.name = friend.Nick;
                        NSString *iconURL = [NSString replaceString:friend.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
                        user.portraitUri = iconURL;
                        NSLog(@"%@-----------------",friend.Nick);
                        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
                    }
                }
            }
            _myFriendArray = arrM;

    
            [ZWLCacheData archiveObject:arrM toFile:FriendPath];
            
            
            // 会话列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshConversionList" object:nil];
            
            // 是否是好友数据刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshIsFriendNotification" object:nil];
            
//            [_myFriendtab.mj_header endRefreshing];

            _rowArr = [ContactDataHelper getFriendListDataBy:self.myFriendArray];
            _sectionArr = [ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
            
            [_myFriendtab reloadData];
            
            if (arr.count >0) {
                
                searchLab.hidden = YES;

            }else{
                searchLab.hidden =NO;
            }
        }
        
        
    } failed:^(NSError *error) {
        
//        [_hud hide:YES];
//        [_myFriendtab.mj_header endRefreshing];

        //            从本地读取数据
        _myFriendArray = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
        for (ConnectWithMyFriend *friend in _myFriendArray) {
            
            for (NSDictionary *aDic in employeesArr) {
                
                if ([aDic[@"ProfileId"] isEqualToString:friend.ProfileId]) {
                    friend.isEmployee = YES;
                }
            }
        }
        
        _rowArr=[ContactDataHelper getFriendListDataBy:self.myFriendArray];
        _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
        
        [_myFriendtab reloadData];
        
    }];
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
    
    searchLab =[[UILabel alloc]initWithFrame:CGRectMake(0, kScreen_CenterY -100, kScreen_Width, 20)];
    searchLab.text =@"你还没有好友哦~";
    searchLab.textAlignment =NSTextAlignmentCenter;
    searchLab.hidden =YES;
    searchLab.textColor =[UIColor colorWithHexString:@"#848484"];
    [_myFriendtab addSubview:searchLab];
    
}

#pragma mark --UITableViewDelegate 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _rowArr.count+1;
}

//每区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (0 == section) {
        return 1;
    }
    else {
        
        NSArray *arr = _rowArr[section-1];
        return [arr count];

    }

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
    }
    
    cell.section = indexPath.section;
    if (0 == indexPath.section) {
//        cell.requestCount =
        cell.myfriend = nil;

    }
    else {

        cell.countLab.hidden = YES;
        ConnectWithMyFriend * myfriend = _rowArr[indexPath.section-1][indexPath.row];
        cell.myfriend = myfriend;
    }
    

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ChatHeaderView *headerView = [[ChatHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    [headerView setTitleString:[_sectionArr objectAtIndex:section]];
    
    return headerView;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section != 0) {
        
        return 20;
    }
    
    return 0;
}


// 选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section) {
        
        FriendRequestVC *friendRequestVC =[[FriendRequestVC alloc] init];
        friendRequestVC.requestArray = self.requestArray;
        friendRequestVC.count = _aCount;
        [self.viewController.navigationController pushViewController:friendRequestVC animated:YES];
        friendRequestVC.requestBlock = ^(void) {
            [self loadFriendRequest];
        };
        
        return;
    }
    
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    ConnectWithMyFriend * myfriend = _rowArr[indexPath.section-1][indexPath.row];
    FriendDetailMessageVC *friendDetailMessageVC = [[FriendDetailMessageVC alloc] init];
    friendDetailMessageVC.model = myfriend;
    [self.viewController.navigationController pushViewController:friendDetailMessageVC animated:YES];
    
}

// 检测好友请求
- (void)loadFriendRequest {
    
    // 获取接受申请数据
    [AFNetClient GET_Path:FriendRequest completed:^(NSData *stringData, id JSONDict) {
        NSArray *data = JSONDict[@"Data"];
        
        if ([data isKindOfClass:[NSNull class]]) {
            return ;
        }
        self.requestArray = data;
        
//        NSLog(@"%@",data);
        _aCount = 0;
        for (NSDictionary *dic in data) {
            if (![dic[@"Viewed"] boolValue]) {
                _aCount++;
            }
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        DetailTableViewCell * cell = [_myFriendtab cellForRowAtIndexPath:indexPath];

        if (_aCount > 0) {
            cell.countLab.hidden = NO;
            cell.countLab.text = [NSString stringWithFormat:@"%d",_aCount];
        }
        else {
            cell.countLab.hidden = YES;

        }
        
        
        // 有好友请求通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kHasFriendRequestNotification" object:@(_aCount)];
        
    } failed:^(NSError *error) {
        NSLog(@"%@", error);

    }];
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
//        _searchView.clickAction = FriendViewClickActionOne;
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
