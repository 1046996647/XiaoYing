//
//  DownloadManagerController.m
//  XiaoYing
//
//  Created by ZWL on 16/1/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DownloadManagerController.h"
#import "DownloadingCell.h"
#import "DownloadFinishCell.h"
#import "DeleteViewController.h"
#import "FileTypeCollectionView.h"
#import "DownloadedDictionaryModel.h"

#define kBACKNOTI @"bakcnoti"
@interface DownloadManagerController ()<UITableViewDelegate,UITableViewDataSource,ZFDownloadDelegate,UIDocumentInteractionControllerDelegate>
{
    UIButton *_downloadingBtn;
    UIButton *_downloadFinishBtn;
    UIView *_viewLine;
    
    UITableView *_tableView;

}

@property (nonatomic,strong) UIButton *dBtn;//导航栏右上角按钮
@property (nonatomic,strong) UIButton *fBtn;//导航栏右上角按钮


@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSMutableArray *downloading;
@property (nonatomic, strong) NSMutableArray *downladed;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *showTypeBtn;


@property (nonatomic,copy) NSMutableArray *deleteArr;
@property (nonatomic,strong) FileTypeCollectionView *fileTypeCollectionView;
@property(nonatomic,strong)UIDocumentInteractionController *documentInteractionController;


@end

@implementation DownloadManagerController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSelf:) name:kBACKNOTI object:nil];
    
    // 更新单元格的代理
    [ZFDownloadManager sharedInstance].delegate = self;


    //导航栏的保存按钮
    [self initRightBtn];

    //初始化子视图
    [self initSubViews];
    
    // 更新数据源
    [self initData];
    
    
    self.tag = 1;
    
    
}


//初始化子视图
- (void)initSubViews
{
    
    //-------------------顶部视图-------------------
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    _downloadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadingBtn.frame = CGRectMake(0, 0, kScreen_Width/2.0, 44);
    [_downloadingBtn setTitle:@"正在下载" forState:UIControlStateNormal];
    _downloadingBtn.tag = 1;
    [_downloadingBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    _downloadingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_downloadingBtn addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_downloadingBtn];
    
    _downloadFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadFinishBtn.frame = CGRectMake(kScreen_Width/2.0, 0, kScreen_Width/2.0, 44);
    [_downloadFinishBtn setTitle:@"下载完成" forState:UIControlStateNormal];
    _downloadFinishBtn.tag = 2;
    [_downloadFinishBtn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    _downloadFinishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_downloadFinishBtn addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_downloadFinishBtn];
    
    _viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42, kScreen_Width/2, 2)];
    _viewLine.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [headerView addSubview:_viewLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, .5)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [headerView addSubview:bottomLine];
    
    // 表视图
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, bottomLine.bottom, kScreen_Width, kScreen_Height-64-bottomLine.bottom) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[DownloadingCell class] forCellReuseIdentifier:@"downloadingCell"];
    [_tableView registerClass:[DownloadFinishCell class] forCellReuseIdentifier:@"downloadFinishCell"];

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
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [button addSubview:line];
    
    
    // 集合视图
    CGFloat width = (kScreen_Width-15*2-30*3)/4.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 30;
    layout.minimumLineSpacing = 53; //上下的间距 可以设置0看下效果
//    创建 UICollectionView
    self.fileTypeCollectionView = [[FileTypeCollectionView alloc] initWithFrame:CGRectMake(0, bottomLine.bottom, kScreen_Width, kScreen_Height-64-bottomLine.bottom) collectionViewLayout:layout];
    self.fileTypeCollectionView.hidden = YES;
    self.fileTypeCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.fileTypeCollectionView];

    // 下载完成文件的显示样式按钮
    UIButton *showTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showTypeBtn.hidden = YES;
    //    showTypeBtn.userInteractionEnabled = NO;
    showTypeBtn.frame = CGRectMake(kScreen_Width-12-40, kScreen_Height-64-12-40, 40, 40);
    [showTypeBtn setImage:[UIImage imageNamed:@"classification"] forState:UIControlStateNormal];
    [showTypeBtn setImage:[UIImage imageNamed:@"record-1"] forState:UIControlStateSelected];
    [showTypeBtn addTarget:self action:@selector(showTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showTypeBtn];
    self.showTypeBtn = showTypeBtn;
    
}


- (void)initData
{
    NSMutableArray *downloading = [ZFDownloadManager sharedInstance].downloadingArray;
    self.downloading = downloading;
    
    NSMutableArray *downladed = [ZFDownloadManager sharedInstance].downloadedArray;
    self.downladed = downladed;
    
    // 退出APP后再进入自动下载
    if (downloading.count > 0) {
        for (ZFSessionModel *model in downloading) {
            // 正在下载
//            if (![[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:model.url withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                
//            }]) {
//                [[ZFDownloadManager sharedInstance] download:model.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                    
//                } state:^(DownloadState state) {}];
//                
//            }
            
            if (!model.downloadManager) {
                [[ZFDownloadManager sharedInstance] download:model.url type:1 thumbnailUrl:nil  progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                    
                } state:^(DownloadState state) {}];
                
            }
        }
    }

    [_tableView reloadData];
}

// 显示样式按钮
- (void)showTypeAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        self.fileTypeCollectionView.hidden = NO;
        self.fileTypeCollectionView.downloadedDic = [DownloadedDictionaryModel getDownloadedDictionaryWithArray:self.downladed];
        [self.fileTypeCollectionView reloadData];
        self.fBtn.hidden = YES;

    }
    else {
        self.fileTypeCollectionView.hidden = YES;
        self.fBtn.hidden = NO;

    }
    
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
    fBtn.hidden = YES;
    self.fBtn = fBtn;
    [fBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:fBtn];

}

// 取消事件
- (void)cancelAction:(UIButton *)btn
{
    // 删除的数组清空
    [self.deleteArr removeAllObjects];
    self.deleteArr = nil;
    
    // 改变单元格的样式
    self.checkType = CheckTypeDownload;
    
    // 取消选中
    for (ZFSessionModel *model in self.downladed) {
        model.isSelected = NO;
    }
    
    [_tableView reloadData];

    self.button.hidden = YES;
    _downloadingBtn.userInteractionEnabled = YES;

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
        
        _downloadingBtn.userInteractionEnabled = NO;
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
        for (ZFSessionModel *model in self.downladed) {
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
        for (ZFSessionModel *model in self.downladed) {
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
    for (ZFSessionModel *model in self.downladed) {
        model.isExpand = NO;
    }
    
    [_tableView reloadData];
    
}

-(void)operateAction:(UIButton *)btn{

    
    // 记录tag，用作单元格显示判断
    self.tag = btn.tag;
    
    // 更新数据源
    [self initData];
    
    if (btn.tag==1) {
        
//        self.dBtn.hidden = NO;
        self.fBtn.hidden = YES;
        self.fileTypeCollectionView.hidden = YES;
        self.showTypeBtn.hidden = YES;

        
        [_downloadingBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        [_downloadFinishBtn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
        
        _viewLine.frame=CGRectMake(0, 42, kScreen_Width/2, 2);

    }
    else {
        
        self.showTypeBtn.hidden = NO;
        
        if (!self.showTypeBtn.selected) {
            self.fBtn.hidden = NO;

        }
        
        if (self.showTypeBtn.selected) {
            self.fileTypeCollectionView.hidden = NO;

        }
        
        [_downloadingBtn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
        
        [_downloadFinishBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        _viewLine.frame=CGRectMake(kScreen_Width/2, 42, kScreen_Width/2, 2);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tag == 1) {
        return self.downloading.count;
    } else {
        return self.downladed.count;
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __block ZFSessionModel *downloadObject = nil;

    if (self.tag == 1) {
        
        DownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        downloadObject = self.downloading[indexPath.row];
        cell.sessionModel = downloadObject;
        
        cell.downloadBlock = ^(UIButton *sender) {
            [[ZFDownloadManager sharedInstance] download:downloadObject.url type:1 thumbnailUrl:nil   progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {} state:^(DownloadState state) {}];
        };

        return cell;
        
    }else if (self.tag == 2) {
        
        DownloadFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadFinishCell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deleteBlock = ^(ZFSessionModel *model) {
            
            if (model.isSelected == YES) {
                [self.deleteArr addObject:model];
            } else {
                [self.deleteArr removeObject:model];
                
            }
            
            [self changeAction];
            
            [_tableView reloadData];

        };
        cell.checkType = self.checkType;
        downloadObject = self.downladed[indexPath.row];
        cell.sessionModel = downloadObject;

        return cell;
    }
    return nil;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tag == 2) {
        ZFSessionModel *model = self.downladed[indexPath.row];
        NSString *filePath = ZFFileFullpath(model.url);
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        [self.documentInteractionController setDelegate:self];
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFSessionModel *downloadObject = nil;
    
    if (self.tag == 1) {
        ;
        downloadObject = self.downloading[indexPath.row];

    }else if (self.tag == 2) {
        
        downloadObject = self.downladed[indexPath.row];
        
    }
    
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

#pragma mark - ZFDownloadDelegate

// 刷新单元格
- (void)downloadResponse:(ZFSessionModel *)sessionModel
{
    // 取到对应的cell上的model
    NSArray *downloadings = self.downloading;
    
    if (downloadings) {
        if ([downloadings containsObject:sessionModel]) {
            
            NSInteger index = [downloadings indexOfObject:sessionModel];
            
            NSIndexPath *indexPath = nil;
            
            if (self.tag == 1) {
                indexPath = [NSIndexPath indexPathForRow:index inSection:0];

            }
            
            __block DownloadingCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            
            sessionModel.progressBlock = ^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.receivedDataLab.text   = [NSString stringWithFormat:@"%@/%@",writtenSize,totalSize];
                    cell.speedLab.text      = speed;
                    cell.downloadBtn.selected = YES;
                    cell.downloadLab.text = @"暂停";
                });
            };
            
            
            sessionModel.stateBlock = ^(DownloadState state){
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新数据源
                    if (state == DownloadStateCompleted) {
                        [weakSelf initData];
//                        cell.downloadBtn.selected = NO;
                    }
                    // 暂停
                    if (state == DownloadStateSuspended) {
                        cell.speedLab.text = @"已暂停";
                        cell.downloadBtn.selected = NO;
                        cell.downloadLab.text = @"下载";
//
                    }
                });
                
                
            };
            
            
        }

    }

}




#pragma mark - 重写返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self.fBtn removeFromSuperview];
    self.fBtn = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 刷新表视图
- (void)refreshTableview
{
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
    
    if (self.tag == 1) {

        [self.downloading removeObject:model];
        
    }
    else {
        [self.downladed removeObject:model];
    }
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
    
    [_tableView reloadData];
}

-(void)reloadSelf:(NSNotification *)noti{
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:self.downladed];
    for (ZFSessionModel *model in muArray) {
        NSInteger count = 0;
        for (ZFSessionModel *subModel in [ZFDownloadManager sharedInstance].sessionModelsArray) {
            if ([subModel.fileName isEqualToString:model.fileName]) {
                count ++;
            }
        }
        if (count == 0) {
            [self.downladed removeObject:model];
        }
    }
    [_tableView reloadData];
    self.fileTypeCollectionView.downloadedDic = [DownloadedDictionaryModel getDownloadedDictionaryWithArray:self.downladed];
    [self.fileTypeCollectionView reloadData];
}


@end
