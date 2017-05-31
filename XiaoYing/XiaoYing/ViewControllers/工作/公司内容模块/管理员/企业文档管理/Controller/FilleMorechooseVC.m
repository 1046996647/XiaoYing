//
//  FilleMorechooseVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FilleMorechooseVC.h"
#import "FileMoreChooseView.h"
#import "AlertViewVC.h"
#import "DocumentViewModel.h"
#import "DocumentModel.h"
#import "MoveFileViewController.h"
#import "DeleteDocumentController.h"
#import "XYExtend.h"
#import "FileMoreChooseSearchTableView.h"
#import "UITableView+showMessageView.h"

@interface FilleMorechooseVC ()

@property (nonatomic)BOOL isAllChoose;
@property (nonatomic, strong) FileMoreChooseView *fileMoreSelectTableView;
@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIButton *moveBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UISearchBar *searchBar;//搜索栏
@property (nonatomic, strong) AlertViewVC *alertVC;  //推出的Alertview

@property (nonatomic, strong) FileMoreChooseSearchTableView *searchResultTableView; //用来显示搜索结果的tableView
@property (nonatomic, strong) NSMutableArray *searchResultArray; //搜索结果的数组

@end

@implementation FilleMorechooseVC
@synthesize searchResultArray = _searchResultArray;

- (NSString *)parentFolderId
{
    if (!_parentFolderId) {
        _parentFolderId = @"";//初始化默认值
    }
    return _parentFolderId;
}

- (FileMoreChooseSearchTableView *)searchResultTableView
{
    if (!_searchResultTableView) {
        _searchResultTableView = [[FileMoreChooseSearchTableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
        _searchResultTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    }
    return _searchResultTableView;
}

- (NSMutableArray *)searchResultArray
{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

- (void)setSearchResultArray:(NSMutableArray *)searchResultArray
{
    _searchResultArray = searchResultArray;
    
    //将数据传递给tableView，作为其展示view的数据源
    self.searchResultTableView.searchResultArray = searchResultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
   
    [self setupBasic];
    
    [self setupBottomView];
    
    [self getDocumentDataList];
    
    [self setupHeaderView];
}

// 根据文件夹id查看该文件夹包含的文件夹以及文件
- (void)getDocumentDataList
{
    [DocumentViewModel getDocumentListDataWithFolderId:self.parentFolderId success:^(NSArray *documentListArray) {
        //根据传过来测总的文档数据，按文件夹和文件两种类型进行分类
        NSMutableArray *folderArray = [NSMutableArray array];
        NSMutableArray *fileArray = [NSMutableArray array];
        for (DocumentModel *documentModel in [DocumentModel getModelArrayFromModelArray:documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }else { //代表文件
                [fileArray addObject:documentModel];
            }
        }
        
        self.fileMoreSelectTableView.folderArray = [self sortFolderArrayWithNameFromOriginArray:folderArray];
        self.fileMoreSelectTableView.fileArray = [self sortFileArrayWithTimeFromOriginArray:fileArray];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

- (void)setupBasic
{
    self.title = @"企业文档管理";
    
    //NavigationItem的设置(clickSelectAction:)
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(0, 0, 50, 30);
    selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitle:@"全不选" forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(clickSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    //[selectButton sizeToFit];
    
    UIBarButtonItem *selectBarButton = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
    self.navigationItem.rightBarButtonItem = selectBarButton;
    
    __weak typeof(self)weakSelf = self;
    HSBlockButton *leftBarButton = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftBarButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [leftBarButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBarButton addTouchUpInsideBlock:^(UIButton *button) {
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:leftBarButton]];

    //展示table的设置
    _fileMoreSelectTableView = [[FileMoreChooseView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height - 44 - 64 - 44)];
    _fileMoreSelectTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_fileMoreSelectTableView];
    
    [_fileMoreSelectTableView addObserver:self forKeyPath:@"folderDeleteArray" options:NSKeyValueObservingOptionNew context:nil];
    [_fileMoreSelectTableView addObserver:self forKeyPath:@"fileDeleteArray" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)setupHeaderView
{
    //背景view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:headerView];
    
    //排序按钮(soreWithTimeOrName)
    UIButton *sortbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortbtn.frame = CGRectMake(12, 7, 35, 30);
    [sortbtn setImage:[UIImage imageNamed:@"sorting"] forState:UIControlStateNormal];
    [sortbtn addTarget:self action:@selector(soreWithTimeOrName) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortbtn];
    
    //一条竖线
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(59, 9, 1, 26)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    viewLine.alpha = 0.4;
    [self.view addSubview:viewLine];
    
    //搜索框
    __weak typeof(self) weakSelf = self;
    HSSearchTableView *searchTableView = [[HSSearchTableView alloc] initWithPreviousViewController:self searchResultTableView:self.searchResultTableView searchResultDataArray:self.searchResultArray searchHappenBlock:^{
        
        //从服务器搜索
        [DocumentViewModel searchDocumentWithKeyText:weakSelf.searchBar.text success:^(NSArray *documentListArray) {
            
            NSMutableArray *fileArray = [NSMutableArray array];
            for (DocumentModel *documentModel in [DocumentModel getModelArrayFromModelArray:documentListArray]) {
                if (documentModel.documentType != 0) { //代表不是文件夹
                    [fileArray addObject:documentModel];
                }
            }
            weakSelf.searchResultArray = fileArray.mutableCopy;
            
            //如果没有搜索结果的时候，显示没有搜索到结果图片
            [weakSelf.searchResultTableView tableViewDisplayNotFoundViewWithRowCount:weakSelf.searchResultArray.count];
            
        } failed:^(NSError *error) {
            
            
        }];
        
    }];
    [self.view addSubview:searchTableView];//只是为了长持有
    self.searchBar = searchTableView.searchBar;
    searchTableView.beforeShowSearchBarFrame = CGRectMake(67, 0, kScreen_Width - 67, 44);
    self.searchBar.frame = CGRectMake(67, 0, kScreen_Width - 67, 44);
    self.searchBar.placeholder = @"查找文档";
    [self.view addSubview:self.searchBar];
    
    
    //分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, .5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:sepView];
    
}

//点击排序按钮
- (void)soreWithTimeOrName
{
    NSLog(@"按时间排序");
    
    __weak typeof(self)weakSelf = self;
    
    _alertVC = [[AlertViewVC alloc] init];
    
    [_alertVC addAlertMessageWithAlertName:@"按时间顺序排序" andEventBlock:^{
        
        NSLog(@"按时间顺序排序");
        weakSelf.fileMoreSelectTableView.fileArray = [weakSelf sortFileArrayWithTimeFromOriginArray:weakSelf.fileMoreSelectTableView.fileArray];
    }];
    
    [_alertVC addAlertMessageWithAlertName:@"按名称顺序排序" andEventBlock:^{
        
        NSLog(@"按名称顺序排序");
        weakSelf.fileMoreSelectTableView.fileArray = [weakSelf sortFileArrayWithNameFromOriginArray:weakSelf.fileMoreSelectTableView.fileArray];
    }];
    
    [_alertVC addAlertMessageWithAlertName:@"取消" andEventBlock:^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    _alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_alertVC animated:YES completion:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"folderDeleteArray"]) {
        
        NSLog(@"要删除的文件夹数组变更啦");
        NSLog(@"_fileMoreSelectTableView.folderDeleteArray~~%@", _fileMoreSelectTableView.folderDeleteArray);
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%u)", _fileMoreSelectTableView.folderDeleteArray.count + _fileMoreSelectTableView.fileDeleteArray.count] forState:UIControlStateNormal];
        
    }
    
    if ([keyPath isEqualToString:@"fileDeleteArray"]) {
        
        NSLog(@"要删除的文件数组变更啦");
        NSLog(@"_fileMoreSelectTableView.fileDeleteArray~~%@", _fileMoreSelectTableView.fileDeleteArray);
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%u)", _fileMoreSelectTableView.folderDeleteArray.count + _fileMoreSelectTableView.fileDeleteArray.count] forState:UIControlStateNormal];
    }
}

- (void)clickSelectAction:(UIButton *)btn
{
    if (btn.selected) { //点击全不选
        NSLog(@"点击全不选");
        
        [btn setSelected:NO];
        [_fileMoreSelectTableView selectAllDocument:NO];
        
    }else { //点击全选
        NSLog(@"点击全选");
        
        [btn setSelected:YES];
        [_fileMoreSelectTableView selectAllDocument:YES];
        
    }
}

//上传,上传管理工具条的初始化
- (void)setupBottomView {
    
    //滑动视图引起的特殊位置，再减64
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:topView];
    
    //移动按钮
    self.moveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moveBtn.frame = CGRectMake(0, 0, kScreen_Width/2.0, 44);
    [self.moveBtn setTitle:@"移动" forState:UIControlStateNormal];
    [self.moveBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    self.moveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.moveBtn addTarget:self action:@selector(moveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:self.moveBtn];
    
    //删除按钮
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(kScreen_Width/2.0, 0, kScreen_Width/2.0, 44);
    [self.deleteBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:self.deleteBtn];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 0.5 , 8, 1, 28)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:lineView];
}

- (void)moveBtnAction:(UIButton *)btn
{
    NSLog(@"点击移动操作");
    //暂不支持文件夹的移动
    if (_fileMoreSelectTableView.folderDeleteArray.count > 0) {
        [MBProgressHUD showMessage:@"暂不支持文件夹的移动"];
    }else {
        NSMutableArray *moveFileIdsArray = [NSMutableArray array];
        for (DocumentModel *documentModel in _fileMoreSelectTableView.fileDeleteArray) {
            [moveFileIdsArray addObject:documentModel.documentId];
        }
        NSString *moveFileIdsStr = [moveFileIdsArray componentsJoinedByString:@","];
        
        MoveFileViewController *moveFileVC = [[MoveFileViewController alloc] init];
        moveFileVC.folderName = @"根目录";
        moveFileVC.folderId = @"";
        moveFileVC.fileId = moveFileIdsStr;
        [self.navigationController pushViewController:moveFileVC animated:YES];
    }
}

- (void)deleteBtnAction:(UIButton *)btn
{
    NSLog(@"点击删除操作");
    NSMutableArray *deleteFolderArray = [NSMutableArray array];
    NSMutableArray *deleteFileArray = [NSMutableArray array];
    if (_fileMoreSelectTableView.folderDeleteArray.count > 0) {
        for (DocumentModel *documentModel in _fileMoreSelectTableView.folderDeleteArray) {
            [deleteFolderArray addObject:documentModel.documentId];
        }
    }
    if (_fileMoreSelectTableView.fileDeleteArray.count > 0) {
        for (DocumentModel *documentModel in _fileMoreSelectTableView.fileDeleteArray) {
            [deleteFileArray addObject:documentModel.documentId];
        }
    }
    
    DeleteDocumentController *deleteDocumentVC = [[DeleteDocumentController alloc] init];
    deleteDocumentVC.folderIdsArray = deleteFolderArray;
    deleteDocumentVC.fileIdsArray = deleteFileArray;
    deleteDocumentVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    deleteDocumentVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    deleteDocumentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteDocumentVC animated:YES completion:nil];

    
}

//_______________________
- (NSMutableArray *)sortFolderArrayWithNameFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentName];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

- (NSMutableArray *)sortFileArrayWithNameFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentName];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

- (NSMutableArray *)sortFileArrayWithTimeFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *timeArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [timeArray addObject:model.documentCreateTime];
    }
    return [NSMutableArray SortOfTimeWithArray:timeArray AndTargetArray:originArray];
}

- (void)dealloc {
    [_fileMoreSelectTableView removeObserver:self forKeyPath:@"folderDeleteArray"];
    [_fileMoreSelectTableView removeObserver:self forKeyPath:@"fileDeleteArray"];
}

@end
