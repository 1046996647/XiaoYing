//
//  UniversalController.m
//  XiaoYing
//
//  Created by ZWL on 15/12/15.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "CompanyFileController.h"
#import "FileTableView.h"
#import "DownloadManagerController.h"
#import "ZFDownloadManager.h"
#import "WangUrlHelp.h"
#import "SortVC.h"
#import "DocModel.h"
//#import "ImageBrowseVC.h"

@interface CompanyFileController()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    FileTableView *_tableView;
    NSArray *_titleArray;
    UIButton *_clearBtn;//清77除按钮
    NSMutableArray *_searchArray;     // 装载搜索结果的数组
}

@property (nonatomic,strong) UIView *lastView;
@property (nonatomic,strong) UIView *currentView;
@property (nonatomic,strong) UIButton *btn;//导航栏右上角按钮
@property (nonatomic,strong) UISearchBar *searchBar;//搜索
@property (nonatomic,strong) UITableView *searchResultView;//点击搜索按钮之后出现的搜索界面
@property (nonatomic,strong) NSString *key;//查询关键字
@property (nonatomic,strong) UIView *ViewForSearch;//当搜索时的背景图
@property (nonatomic,strong) UILabel *downloadCountLab;//下载数label


@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,strong) NSMutableArray *downloadArr;
@property (nonatomic,strong) NSMutableArray *nameOfFile;
@property (nonatomic,strong) NSMutableArray *dateOfFile;
@property (nonatomic,strong)  NSArray *foldersArray;//文件夹的数组
@property (nonatomic,strong)  NSArray *filesArray;//文件数组
@property (nonatomic,assign) BOOL isCheckAll;

@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation CompanyFileController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _searchArray = [NSMutableArray array];

    if (self.catalogId == nil) {
      self.title = @"企业文档";
    }
    _nameOfFile = [NSMutableArray array];
    _dateOfFile = [NSMutableArray array];

    _tableView=[[FileTableView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.checkType = CheckTypeDownload;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 43, 0);
    _tableView.modelArray = [NSArray new];
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    //加载网络数据
    [self loadData];
    
    //表的头视图
    [self initHeaderView];
    
    //新建文件和操作
    [self initBottomView];
    
    //下载的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"kDownloadNotification" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.searchBar.top == 20) {//如果此时还是搜索界面的话
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
}

#pragma mark - 网络加载方法 methods
-(void)loadData{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    NSString *url = GETDOC,@""];
    if (self.catalogId != nil) {
        url = GETDOC,self.catalogId];
    }
    [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
      NSNumber *code = JSONDict[@"Code"];
        if (code.integerValue == 0){
            [_hud hide:YES];
            _hud = nil;
            NSArray *dataArray = JSONDict[@"Data"];
            NSArray *newArray = [DocModel getModelArrayFromModelArray:dataArray];
            _tableView.modelArray = [self simplySortedWithArray:newArray];
            [_tableView reloadData];
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

//从服务器得到数组后先进行简单的排序
-(NSArray *)simplySortedWithArray:(NSArray*)array{
    NSMutableArray *finalArray = array.mutableCopy;
    NSMutableArray *midArray = [NSMutableArray array];
    for (DocModel *model in array) {
        if (model.type != 0) {//不是文件夹
            [midArray addObject:model];
            [finalArray removeObject:model];
        }
    }
    self.filesArray = midArray.copy;
    self.foldersArray = finalArray.copy;
    [finalArray addObjectsFromArray:self.filesArray];
    return finalArray.copy;
}

#pragma mark - 通知方法
- (void)notificationAction:(NSNotification *)notification
{
    __block NSMutableArray *downloading = [ZFDownloadManager sharedInstance].downloadingArray;
    
    // 在主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloading.count > 0) {
            
            self.downloadCountLab.hidden = NO;
            self.downloadCountLab.text = [NSString stringWithFormat:@"%ld",(unsigned long)downloading.count];
        }
        else {
            self.downloadCountLab.hidden = YES;
        }
        [_tableView reloadData];
    });
}


// 下载管理按钮事件
- (void)btnAction:(UIButton *)btn
{

    
    DownloadManagerController *downloadManagerController = [[DownloadManagerController alloc] init];
    downloadManagerController.title = @"下载管理";
    [self.navigationController pushViewController:downloadManagerController animated:YES];
    
}

// 下载管理
- (void)initBottomView
{

    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    self.lastView = baseView;
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    //下载数
    UILabel *downloadCountLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2+30, 7, 15, 15)];
    downloadCountLab.backgroundColor = [UIColor redColor];
    downloadCountLab.layer.cornerRadius = downloadCountLab.width/2.0;
    downloadCountLab.clipsToBounds = YES;
    downloadCountLab.hidden = YES;
    downloadCountLab.textColor = [UIColor whiteColor];
    downloadCountLab.font = [UIFont systemFontOfSize:11];
    downloadCountLab.textAlignment = NSTextAlignmentCenter;
    self.downloadCountLab = downloadCountLab;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreen_Width, 44);
    [btn setTitle:@"下载管理" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];
    [btn addSubview:downloadCountLab];

}

//表的头视图
- (void)initHeaderView
{
//    //头视图
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    headerView.backgroundColor = [UIColor whiteColor];
    
    //查找文档
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(12, (44-21)/2, 25, 21);
    [sortBtn setImage:[UIImage imageNamed:@"sorting"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sortBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(sortBtn.right+12, 12, .5, 20)];
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [view addSubview:line];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(line.right+6, (44-30)/2.0, kScreen_Width-(line.right+6)-6, 30)];
    //searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
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
    
//    //清除按钮
//     _clearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    _clearBtn.frame =CGRectMake(searchBar.width -31, (searchBar.height-16)/2.0, 16, 16);
//    [_clearBtn setBackgroundImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
//    [_clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
//    _clearBtn.hidden =YES;
//    [_searchBar addSubview:_clearBtn];
    
    //分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, .5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:sepView];
    
//    _tableView.tableHeaderView = headerView;
}

// 排序
- (void)sortAction {
    SortVC *sortVC = [[SortVC alloc] init];
    sortVC.blockResult = ^(NSInteger position) {
        NSMutableArray *modelArrays = [NSMutableArray array];
        NSMutableArray *sortFilesArray = _filesArray.mutableCopy;
        NSMutableArray *sortFolderArray = _foldersArray.mutableCopy;
        NSMutableArray *foldersNameArray = [NSMutableArray array];
        [_nameOfFile removeAllObjects];
        [_dateOfFile removeAllObjects];
        for (DocModel *model in _filesArray) {
            [_nameOfFile addObject:model.name];
            [_dateOfFile addObject:model.creatTime];
        }
        for (DocModel *model in _foldersArray) {
            [foldersNameArray addObject:model.name];
        }
        if (position == 0) {//按名称排序
            sortFolderArray = [NSMutableArray SortOfNameWithArray:foldersNameArray AndTargetArray:sortFolderArray];
            sortFilesArray = [NSMutableArray SortOfNameWithArray:_nameOfFile AndTargetArray:sortFilesArray];
            [modelArrays addObjectsFromArray:sortFolderArray];
            [modelArrays addObjectsFromArray:sortFilesArray];
            _tableView.modelArray = modelArrays.copy;
            
            [_tableView reloadData];
        }else {//按时间排序
            sortFilesArray = [NSMutableArray SortOfTimeWithArray:_dateOfFile AndTargetArray:sortFilesArray];
            [modelArrays addObjectsFromArray:_foldersArray];
            [modelArrays addObjectsFromArray:sortFilesArray];
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
    return _searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - UITableViewDelegate delegateMethods
//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DocModel *model = _searchArray[indexPath.row];
    if (model.type == 0) {//文件夹
        CompanyFileController *vc = [CompanyFileController new];
        vc.catalogId = model.CatID;
        vc.title = model.name;
        [self.navigationController pushViewController:vc animated:YES];
        [vc.navigationController setNavigationBarHidden:NO animated:YES];
    }
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
