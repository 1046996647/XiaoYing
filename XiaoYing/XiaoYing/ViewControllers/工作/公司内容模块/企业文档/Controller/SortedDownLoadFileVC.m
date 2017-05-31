//
//  SortedDownLoadFileVC.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SortedDownLoadFileVC.h"
#import "SortVC.h"
#import "WangUrlHelp.h"
#import "DocModel.h"
#import "FileTableView.h"
#import "CompanyFileController.h"
#define kBACKNOTI @"bakcnoti"
@interface SortedDownLoadFileVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)UIButton *clearBtn;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,copy) NSMutableArray *deleteArr;
@property (nonatomic,strong) UIButton *button;//删除视图的button
@property (nonatomic,strong) UIButton *dBtn;//导航栏右上角按钮
@property (nonatomic,strong) UIButton *fBtn;//导航栏右上角按钮
@property(nonatomic,strong)UITableView *searchResultView;//点击搜索按钮之后出现的搜索界面
@property(nonatomic,strong)NSString *key;//查询关键字
@property(nonatomic,strong)UIView *ViewForSearch;//当搜索时的背景图
@property(nonatomic,strong)NSMutableArray *searchArray;// 装载搜索结果的数组
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)UIDocumentInteractionController *documentInteractionController;
@end

@implementation SortedDownLoadFileVC

// 懒加载
- (NSMutableArray *)deleteArr
{
    if (!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkType = CheckTypeDownload;
    _searchArray = [NSMutableArray array];
    [_tableView registerClass:[DownloadFinishCell class] forCellReuseIdentifier:@"downloadFinishCell"];
    
    //导航栏的保存按钮
    [self initRightBtn];
    
    //初始化子视图
    [self initUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.searchBar.top == 20) {//如果此时还是搜索界面的话
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏的保存按钮
- (void)initRightBtn
{
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(6, (44-20)/2.0, 40, 20);
    dBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dBtn setTitle:@"取消" forState:UIControlStateNormal];
    dBtn.hidden = YES;
    self.dBtn = dBtn;
    [dBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:dBtn];
    
    
    UIButton *fBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fBtn.frame = CGRectMake(kScreen_Width-60-6, (44-20)/2.0, 60, 20);
    fBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fBtn setTitle:@"多选" forState:UIControlStateNormal];
    self.fBtn = fBtn;
    [fBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:fBtn];
    
}

-(void)initUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
//    //头视图
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    headerView.backgroundColor = [UIColor whiteColor];
    
    //查找文档
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view  addSubview:view];
    
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(12, (44-21)/2, 25, 21);
    [sortBtn setImage:[UIImage imageNamed:@"sorting"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sortBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(sortBtn.right+12, 12, .5, 20)];
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [view addSubview:line];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(line.right+6, (44-30)/2.0, kScreen_Width-(line.right+6)-6, 30)];
    searchBar.showsCancelButton = NO;
    searchBar.delegate = self;
    //    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"查找文档";
    searchBar.layer.cornerRadius = 5;
    searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
    [searchBar setBackgroundImage:[UIImage new]];
    [self.view addSubview:searchBar];

    self.searchBar = searchBar;
    
    UIColor *innerColor = [UIColor colorWithHexString:@"#efeff4"];
    for (UIView* subview in [[self.searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            textField.backgroundColor = innerColor;
        }
    }
    
    
    //分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, .5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view  addSubview:sepView];

//    [self.view addSubview:headerView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 43, 0);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];

    // 删除视图
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.hidden = YES;
    button.userInteractionEnabled = NO;
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44);
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"f94040"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button];
    self.button = button;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [button addSubview:lineView];
}

// 排序
- (void)sortAction {
    SortVC *sortVC = [[SortVC alloc] init];
    sortVC.blockResult = ^(NSInteger position) {
        NSMutableArray *fileNamesArray = [NSMutableArray array];
        NSMutableArray *fileTimesArray = [NSMutableArray array];
        for (ZFSessionModel *model in self.modelsArray) {
            [fileNamesArray addObject:model.fileName];
            [fileTimesArray addObject:model.startTime];
        }
        if (position == 0) {//按名称排序
            self.modelsArray = [NSMutableArray SortOfNameWithArray:fileNamesArray AndTargetArray:self.modelsArray];
            [_tableView reloadData];
        }else {//按时间排序
            self.modelsArray = [NSMutableArray SortOfTimeWithArray:fileTimesArray AndTargetArray:self.modelsArray];
            [_tableView reloadData];
        }
    };
    
    sortVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    sortVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sortVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:sortVC animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return self.modelsArray.count;
    }else{
        return _searchArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _tableView) {
        __block ZFSessionModel *downloadObject = nil;
        DownloadFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadFinishCell"];
        if (cell == nil) {
            cell = [[DownloadFinishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"downloadFinishCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deleteBlock = ^(ZFSessionModel *model) {
            
            if (model.isSelected == YES) {
                [self.deleteArr addObject:model];
            } else {
                [self.deleteArr removeObject:model];
                
            }
            
            [self changeAction];
            
            
        };
        cell.checkType = self.checkType;
        downloadObject = self.modelsArray[indexPath.row];
        cell.sessionModel = downloadObject;
        
        return cell;
    }else{
        FileCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            //            cell.delegate = self;
        }
        
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        DocModel *model = _searchArray[indexPath.row];
        
        cell.model = model;
        
        return cell;

    }
    

}

#pragma mark - UITableViewDelegate delegateMethods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tableView) {
        ZFSessionModel *downloadObject = nil;
        
        downloadObject = self.modelsArray[indexPath.row];
        
        //计算字符串高度
        NSString *str = downloadObject.fileName;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        NSLog(@"!!!%.0f",textSize.height);
        
        
        if (downloadObject.isExpand) {
            if (textSize.height > 76) {
                return (76+18+50);
            }
            else {
                return (textSize.height+30+50);
                
            }
        } else {
            
            if (textSize.height > 76) {
                return (76+18);
            }
            else {
                return (textSize.height+30);
                
            }
        }

    }else{
        DocModel *model = _searchArray[indexPath.row];
        
        //计算字符串高度
        NSString *str = model.name;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        if (textSize.height > 76) {
            return (76+18-5);
        }
        else {
            return (textSize.height+30);
            
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _searchResultView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DocModel *model = _searchArray[indexPath.row];
        if (model.type == 0) {//文件夹
            CompanyFileController *vc = [CompanyFileController new];
            vc.catalogId = model.CatID;
            vc.title = model.name;
            [self.navigationController pushViewController:vc animated:YES];
            [vc.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }else
    {
        ZFSessionModel *model = self.modelsArray[indexPath.row];
        NSString *filePath = ZFFileFullpath(model.url);
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        [self.documentInteractionController setDelegate:self];
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }
}


- (void)changeAction
{
    NSString *countStr = nil;
    if (self.deleteArr.count == 0) {
        self.button.userInteractionEnabled = NO;
        
        countStr = @"删除";
    } else {
        self.button.userInteractionEnabled = YES;
        countStr = [NSString stringWithFormat:@"删除(%ld)",(unsigned long)self.deleteArr.count];
        
    }
    [self.button setTitle:countStr forState:UIControlStateNormal];
}

// 多选删除
- (void)deleteAction
{
    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    //    deleteViewController.urlStr = self.sessionModel.url;
    
    deleteViewController.fileDeleteBlock = ^(void)
    {
        for (ZFSessionModel *model in self.deleteArr) {
            if (model.isSelected) {
                [self deleteFile:model];
            }
        }
        
        [self cancelAction:self.dBtn];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
        
    };
    
    deleteViewController.titleStr = @"是否确定删除?";
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteViewController animated:YES completion:nil];
    
}

// 取消事件
- (void)cancelAction:(UIButton *)btn
{
    // 删除的数组清空
    [self.deleteArr removeAllObjects];
    self.deleteArr = nil;
    
//    // 改变单元格的样式
//    self.checkType = CheckTypeDownload;
    
    // 取消选中
    for (ZFSessionModel *model in self.modelsArray) {
        model.isSelected = NO;
    }
    
    [_tableView reloadData];
    
    self.button.hidden = YES;
    
    for (UIView *subView in self.navigationItem.leftBarButtonItems) {
        if ([subView isKindOfClass:[UIBarButtonItem class]]) {
            UIBarButtonItem *item = (UIBarButtonItem *)subView;
            item.customView.hidden = NO;
        }
    }
    self.dBtn.hidden = YES;
    [self.fBtn setTitle:@"多选" forState:UIControlStateNormal];
    _tableView.height = kScreen_Height-64-44.5;
    
    
}

//右上角按钮点击事件
- (void)rightBtnAction:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"多选"]) {
        
        //_downloadingBtn.userInteractionEnabled = NO;
//        self.navigationItem.leftBarButtonItem
        for (UIView *subView in self.navigationItem.leftBarButtonItems) {
            if ([subView isKindOfClass:[UIBarButtonItem class]]) {
                UIBarButtonItem *item = (UIBarButtonItem *)subView;
                item.customView.hidden = YES;
            }
        }
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        self.dBtn.hidden = NO;
        self.button.hidden = NO;
        _tableView.height = kScreen_Height-64-44.5-44;
        
        
    }
    else if ([btn.currentTitle isEqualToString:@"全选"]) {
        [btn setTitle:@"全不选" forState:UIControlStateNormal];
        
        // 全选中
        for (ZFSessionModel *model in self.modelsArray) {
            model.isSelected = YES;
            
            if (![self.deleteArr containsObject:model]) {
                [self.deleteArr addObject:model];
            }
        }
        
        [self changeAction];
        
    }
    else if ([btn.currentTitle isEqualToString:@"全不选"]) {
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        
        // 全不选中
        for (ZFSessionModel *model in self.modelsArray) {
            model.isSelected = NO;
        }
        
        // 删除的数组清空
        [self.deleteArr removeAllObjects];
        self.deleteArr = nil;
        
        [self changeAction];
    }
    
    // 改变单元格的样式
    self.checkType = CheckTypeSelected;
    
    // 收起
    for (ZFSessionModel *model in self.modelsArray) {
        model.isExpand = NO;
    }
    
    [_tableView reloadData];
    
}

// 刷新表视图
- (void)refreshTableview
{
    [_tableView reloadData];
}

- (void)initData{
    [_tableView reloadData];
}

// 重命名
- (void)renameFile:(NSString *)url name:(NSString *)name
{
    // 根据url重命名
    [[ZFDownloadManager sharedInstance] renameFile:url name:name];
    
    // 刷新数据
    [self initData];
    
}

// 删除文件
- (void)deleteFile:(ZFSessionModel *)model
{
    // 根据url删除该条数据
    [[ZFDownloadManager sharedInstance] deleteFile:model.url];
    

        [self.modelsArray removeObject:model];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
    
    [_tableView reloadData];
}

#pragma mark - 重写返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self.fBtn removeFromSuperview];
    self.fBtn = nil;
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kBACKNOTI object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载 lazyLoad
-(UITableView*)searchResultView{
    if (_searchResultView == nil) {
        //初始化搜索的数组
        _searchArray = [NSMutableArray array];
        _searchResultView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
        //消除分割线左边的空白
        if ([_searchResultView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchResultView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_searchResultView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchResultView setLayoutMargins:UIEdgeInsetsZero];
        }
        _searchResultView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        //去除底部分割线
        _searchResultView.tableFooterView = [UIView new];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
    }
    return _searchResultView;
}

-(UIView*)ViewForSearch{
    if (_ViewForSearch == nil) {
        _ViewForSearch = [[UIView alloc]initWithFrame:self.view.bounds];
        _ViewForSearch.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        //        _ViewForSearch.backgroundColor = [UIColor redColor];
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kScreen_Width, 1)];
        sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [_ViewForSearch addSubview:sepView];
    }
    return _ViewForSearch;
}

#pragma mark - UISearchBar delegateMethods
//当搜索之后
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.navigationController.navigationBarHidden = YES;
        _searchBar.showsCancelButton = YES;
        _searchBar.top = 20;
        _searchBar.width = kScreen_Width;
        _searchBar.left = 0;
        UIColor *innerColor = [UIColor whiteColor];
        for (UIView* subview in [[self.searchBar.subviews lastObject] subviews]) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField*)subview;
                textField.backgroundColor = innerColor;
            }
        }
        [self.view addSubview:self.ViewForSearch];
        [self.view bringSubviewToFront:_searchBar];
        [self.view addSubview:self.searchResultView];
    }];
}

//当点击了取消按钮之后
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBarHidden = NO;
        _searchBar.top = (44-30)/2.0;
        _searchBar.width = kScreen_Width-(49.5+6)-6;
        _searchBar.left = 49.5+6;
        UIColor *innerColor = [UIColor colorWithHexString:@"#efeff4"];
        for (UIView* subview in [[self.searchBar.subviews lastObject] subviews]) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField*)subview;
                textField.backgroundColor = innerColor;
            }
        }
        [self.searchResultView removeFromSuperview];
        self.searchResultView = nil;
        [self.self.ViewForSearch removeFromSuperview];
        self.self.ViewForSearch = nil;
        _searchBar.showsCancelButton = NO;
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
    }];
}

-(void)searchDataWithKey:(NSString *)key{
    NSString *url = SEARCHDOC,key];
    [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if (code.integerValue == 0){
            [_hud hide:YES];
            _hud = nil;
            NSArray *dataArray = JSONDict[@"Data"];
            NSArray *newArray = [DocModel getModelArrayFromModelArray:dataArray];
            _searchArray = newArray.mutableCopy;
            [_searchResultView reloadData];
        }else{
            [_hud hide:YES];
            _hud = nil;
            NSString *message = JSONDict[@"Message"];
            [MBProgressHUD showMessage:message];
        }
    } failed:^(NSError *error) {
        [_hud hide:YES];
        _hud = nil;
        NSLog(@"失败**********=======>>>%@",error);
    }];
}



//当点击了搜索按钮之后
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBarResignAndChangeUI];
    [_hud removeFromSuperViewOnHide];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    _key = searchBar.text;
    //    if (_departmentbt.selected == NO) {//搜索公司公告
    //        [self GetCompanyNoticeActionWithStart:start andEnd:end andKey:_key andIsSearch:YES];
    //    }else{//搜索部门公告
    //        [self GetDepartmentNoticeActionWithStart:start andEnd:end andKey:_key andIsSearch:YES];
    //    }
    [self searchDataWithKey:_key];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self searchBarResignAndChangeUI];
}

- (void)searchBarResignAndChangeUI{
    
    [_searchBar resignFirstResponder];//失去第一响应
    
    [self changeSearchBarCancelBtnTitleColor:_searchBar];//改变布局
    
}

#pragma mark - 遍历改变搜索框 取消按钮的文字颜色

- (void)changeSearchBarCancelBtnTitleColor:(UIView *)view{
    
    if (view) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *getBtn = (UIButton *)view;
            
            [getBtn setEnabled:YES];//设置可用
            
            [getBtn setUserInteractionEnabled:YES];
            
            
            [getBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateReserved];
            
            [getBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateDisabled];
            
            return;
            
        }else{
            
            for (UIView *subView in view.subviews) {
                
                [self changeSearchBarCancelBtnTitleColor:subView];
                
            }
            
        }
        
    }else{
        
        return;
        
    }
    
}



@end
