//
//  GroupListView.m
//  XiaoYing
//
//  Created by ZWL on 16/8/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "GroupListView.h"
#import "GroupListCell.h"
#import "ChatViewController.h"
#import "GroupListSettingVC.h"
#import "SearchGroupListView.h"


@interface GroupListView ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView * myFriendtab;
@property (nonatomic, strong)XYSearchBar *searchBar;
@property (strong, nonatomic) SearchGroupListView *searchView;
@property (nonatomic,strong) NSArray *groupListArr;


@end

@implementation GroupListView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        //        _myFriendTabMark =1;
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        // 创建视图
        [self loadMyFriendTabView];
        
        // 请求数据
        [self requestData];
        
        // 移除搜索视图
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeSearchView)
                                                     name:@"kRemoveSearchViewNotification"
                                                   object:nil];
        
        // 刷新群组列表
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestData)
                                                     name:@"kRefreshDiscussionListNotification"
                                                   object:nil];

    }
    return self;
}

- (void)removeSearchView
{
    [self searchBarCancelButtonClicked:self.searchBar];
    
}

- (void)requestData
{
    [AFNetClient GET_Path:GetDiscussionList completed:^(NSData *stringData, id JSONDict) {
        
        //        [_hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg];
            
        } else {
            
            NSArray *arr = [JSONDict objectForKey:@"Data"];
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                GroupListModel *model = [[GroupListModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
            self.groupListArr = arrM;
            [_myFriendtab reloadData];
            
            [ZWLCacheData archiveObject:arrM toFile:GroupPath];
            
            // 是否还有讨论组
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kIsHasDiscussionNotification" object:nil];

        }
    } failed:^(NSError *error) {
        
        //            从本地读取数据
        self.groupListArr = [ZWLCacheData unarchiveObjectWithFile:GroupPath];
        [_myFriendtab reloadData];

        
    }];
}

-(void)loadMyFriendTabView{

    _myFriendtab =[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _myFriendtab.delegate =self;
    _myFriendtab.dataSource =self;
    _myFriendtab.rowHeight =58;
    _myFriendtab.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    _myFriendtab.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0);
    _myFriendtab.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _myFriendtab.tableFooterView =[[UIView alloc]init];
    _myFriendtab.tableHeaderView = self.searchBar;
    [self addSubview:_myFriendtab];
    
}

#pragma mark --UITableViewDelegate 协议方法
//每区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupListArr.count;
}

// cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str =@"cell";
    GroupListCell * cell =[tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell =[[GroupListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    cell.model = self.groupListArr[indexPath.row];
    return cell;
}


// 选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupListModel *model = self.groupListArr[indexPath.row];
    
    //讨论组
    ChatViewController * chatVC =[[ChatViewController alloc]init];
    chatVC.conversationType = ConversationType_DISCUSSION;
    chatVC.targetId = model.RongCloudChatRoomId;
    chatVC.title = model.Name;
    //        chatVC.unreadMessageCount = model.unreadMessageCount;
//    chatVC.model = model;
    [self.viewController.navigationController pushViewController:chatVC animated:YES];
    
}

- (XYSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[XYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"查找群";
        
    }
    return _searchBar;
}
- (SearchGroupListView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchGroupListView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, self.height-44)];
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
    for (GroupListModel *model in self.groupListArr) {
        
        if ([model.Name containsString:searchText]) {
            [tempResults addObject:model];
            
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
