//
//  UploadManagerVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "WLUploadManagerVC.h"

@interface WLUploadManagerVC ()<UITableViewDelegate,UITableViewDataSource,WLUploadDelegate>
{
    
    UITableView *_tableView;
    
}

@property (nonatomic, strong) NSMutableArray *uploadingArray;


@end

@implementation WLUploadManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新单元格的代理
    [WLUploadManager sharedInstance].delegate = self;
    
    // 表视图
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UploadingCell class] forCellReuseIdentifier:@"downloadingCell"];
    
    // 更新数据源
    [self initData];
    
}

// 更新数据源
- (void)initData
{
    NSMutableArray *uploadingArray = [WLUploadManager sharedInstance].uploadingArray;
    self.uploadingArray = uploadingArray;
    
    
    // 退出APP后再进入自动上传
    if (uploadingArray.count > 0) {
        for (WLUploadModel *model in uploadingArray) {

            if (!model.uploadManager) {
                [[WLUploadManager sharedInstance] readDataWithUploadModel:model];
                
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - WLUploadDelegate

// 刷新单元格
- (void)uploadResponse:(WLUploadModel *)uploadModel
{
    // 取到对应的cell上的model
    NSArray *uploadingArray = self.uploadingArray;
    
    __block WLUploadModel *weakUploadModel = uploadModel;
    
    if (uploadingArray) {
        if ([uploadingArray containsObject:uploadModel]) {
            
            NSInteger index = [uploadingArray indexOfObject:uploadModel];
            
            NSIndexPath *indexPath = nil;
            indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            UploadingCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
//            __weak typeof(self) weakSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
                                         [weakUploadModel calculateFileSizeInUnit:(unsigned long long)weakUploadModel.startLength],
                                         [weakUploadModel calculateUnit:(unsigned long long)weakUploadModel.startLength]];
                NSString *totalSize = [NSString stringWithFormat:@"%.2f %@",
                                       [weakUploadModel calculateFileSizeInUnit:(unsigned long long)weakUploadModel.totalSize],
                                       [weakUploadModel calculateUnit:(unsigned long long)weakUploadModel.totalSize]];
                cell.receivedDataLab.text = [NSString stringWithFormat:@"%@/%@",writtenSize,totalSize];
                cell.speedLab.text      = weakUploadModel.speedStr;
                cell.downloadBtn.selected = YES;
                cell.downloadLab.text = @"暂停";
            });
            

            
            
            uploadModel.stateBlock = ^(UploadState state){
//
//                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新数据源
//                    if (state == DownloadStateCompleted) {
//                        [weakSelf initData];
//                        //                        cell.downloadBtn.selected = NO;
//                    }
                    // 暂停
                    if (state == UploadStateSuspended) {
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.uploadingArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLUploadModel *uploadModel = nil;
    
    UploadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    uploadModel = self.uploadingArray[indexPath.row];
    cell.uploadModel = uploadModel;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLUploadModel *uploadModel = nil;
    
    uploadModel = self.uploadingArray[indexPath.row];

    
    if (uploadModel.isExpand) {
        return 100;
    } else {
        return 50;
    }
}

// 刷新表视图
- (void)refreshTableview
{
    [_tableView reloadData];
}

// 删除文件
- (void)deleteFile:(WLUploadModel *)model
{
    // 根据url删除该条数据
    [[WLUploadManager sharedInstance] deleteFile:model];
//    
//    if (self.tag == 1) {
//        
//        [self.downloading removeObject:model];
//        
//        // 发送通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
//    }

    [self.uploadingArray removeObject:model];

    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
