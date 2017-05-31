//
//  SearchFileVC.m
//  XiaoYing
//
//  Created by ZWL on 17/1/23.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "SearchFileVC.h"
#import "DocumentMergeModel.h"
#import "DocumentVM.h"
#import "CompanyFileCell.h"
#import "ZFDownloadManager.h"
#import "LocalFileCell.h"

@interface SearchFileVC ()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)XYSearchBar *searchBar;
@property (nonatomic, strong) UITableView *folderTableView;
@property (nonatomic, strong) NSMutableArray *folderModelArray;


@end

@implementation SearchFileVC

- (XYSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[XYSearchBar alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"查找文档";
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

- (UITableView *)folderTableView
{
    if (!_folderTableView) {
        _folderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _folderTableView.backgroundColor = [UIColor clearColor];
        _folderTableView.delegate = self;
        _folderTableView.dataSource = self;
        _folderTableView.tableFooterView = [[UIView alloc] init];
        if ([_folderTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_folderTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_folderTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_folderTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _folderTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.folderTableView];
    
    // 这里是全部刷新(公司、部门、个人），可优化！！！
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDoc) name:@"kRefreshDocNotification" object:nil];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.folderModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_type isEqualToString:@"本地文档"]) {
        LocalFileCell *localCell = [tableView dequeueReusableCellWithIdentifier:@"localCell"];
        
        if (localCell == nil) {
            localCell = [[LocalFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"localCell"];
            localCell.deleteOrReNameBlock = ^(ZFSessionModel *model, NSString *str) {
                
                if (![str isEqualToString:@"Refersh"]) {
                    [self.folderModelArray removeObject:model];
                }
                [tableView reloadData];
            };
        }
        localCell.type = @"0";
        ZFSessionModel *documentModel = self.folderModelArray[indexPath.row];
        localCell.model = documentModel;
        
        return localCell;
    }
    else {
        
        CompanyFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[CompanyFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        DocumentMergeModel *documentModel = self.folderModelArray[indexPath.row];
        cell.type = 1;
        cell.DocumentModel = documentModel;
        
        return cell;
    }

    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDoc
{
    [self searchAction:self.searchBar.text];
}

- (void)searchAction:(NSString *)text
{

    [self resignKeyboard];
    
    if ([_type isEqualToString:@"本地文档"]) {
        
        NSMutableArray *array = [ZFDownloadManager sharedInstance].downloadedArray;
        NSMutableArray *resultArray = [NSMutableArray array];

        for (int i = 0; i < array.count; i++) {
            ZFSessionModel *downloadModel = array[i];
            if ([downloadModel.fileName containsString:text]) {
                [resultArray addObject:downloadModel];
            }
        }
        self.folderModelArray = resultArray;
        [self.folderTableView reloadData];
        
        
    }else {
        [DocumentVM searchFile:text pageIndex:1 pageSize:1000 orderType:1 isasc:1 success:^(NSArray *documentListArray) {
            
            //根据传过来测总的文档数据，按文件夹和文件两种类型进行分类
            NSMutableArray *folderArray = [NSMutableArray array];
            for (DocumentMergeModel *documentModel in [DocumentMergeModel getModelArrayFromModelArray:documentListArray]) {
                [folderArray addObject:documentModel];
                
            }
            
            self.folderModelArray = folderArray;//数据源
            [self.folderTableView reloadData];//根据数据源刷新UI
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@", error);
        }];

    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self resignKeyboard];
    [self searchAction:self.searchBar.text];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;

    _searchBar.text = @"";
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignKeyboard];
}

- (void)resignKeyboard
{
    [_searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [_searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}

@end
