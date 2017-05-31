//
//  DownDocumentTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DownDocumentTableView.h"
#import "DownLoadingCell1.h"
#import "TransportedCell.h"
#import "ZFDownloadManager.h"
#import "NewViewVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PreviewController.h"

@interface DownDocumentTableView()<UITableViewDelegate, UITableViewDataSource, ZFDownloadDelegate>

@property (atomic, strong) NSMutableArray *downloadObjectArr;


@end

@implementation DownDocumentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self initData];

        [ZFDownloadManager sharedInstance].delegate = self;
        
    }
    return self;
}

- (void)initData {
    
    NSMutableArray *downladed = [ZFDownloadManager sharedInstance].downloadedArray;
    NSMutableArray *downloading = [ZFDownloadManager sharedInstance].downloadingArray;
    _downloadObjectArr = @[].mutableCopy;
    [_downloadObjectArr addObject:downloading];
    [_downloadObjectArr addObject:downladed];
    [self reloadData];

}


#pragma mark - tableViewDataSource,UITableViewDelegate
//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _downloadObjectArr.count;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.downloadObjectArr[section];
//    NSLog(@"%ld",sectionArray.count);
    return sectionArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block ZFSessionModel *downloadObject = self.downloadObjectArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        DownLoadingCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"transportingCELL"];
        if (!cell) {
            cell = [[DownLoadingCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transportingCELL"];
        }
        
        [cell getModel:downloadObject];
        return cell;
        
    }else {
        TransportedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transportedCELL"];
        if (!cell) {
            cell = [[TransportedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transportedCELL"];
        }
        
        [cell getModel:downloadObject];
        return cell;
    }
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//每个section头部标题高度（实现这个代理方法后前面 sectionHeaderHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArray = self.downloadObjectArr[section];
    if (sectionArray.count==0) {
        return 0;

    }
    else {
        return 44;

    }
}

//每个section头部的标题－Header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"进行中";
    }
    return @"已完成";
}

//区头的字体颜色设置
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{

    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    header.contentView.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFSessionModel *downloadObject = self.downloadObjectArr[indexPath.section][indexPath.row];
    
    PreviewController *vc = [[PreviewController alloc] init];
    vc.filePath = ZFFileFullpath(downloadObject.url);
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.viewController.navigationController pushViewController:vc animated:YES];
    [self.viewController presentViewController:vc animated:YES completion:nil];

//    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:ZFFileFullpath(downloadObject.url)]];
//    [self.viewController presentViewController:moviePlayer animated:YES completion:nil];
}



//左滑按钮的实现
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSMutableArray *downloadArray = _downloadObjectArr[indexPath.section];
        ZFSessionModel * downloadObject = downloadArray[indexPath.row];
        [downloadArray removeObject:downloadObject];

        // 根据url删除该条数据
        [[ZFDownloadManager sharedInstance] deleteFile:downloadObject.url];
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView reloadData];

        
        //发送通知刷新本地数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
    }];
    
    if (indexPath.section == 0) {

        return @[deleteRowAction];
    }
    else {
        UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            NSMutableArray *downloadArray = _downloadObjectArr[indexPath.section];
            ZFSessionModel * downloadObject = downloadArray[indexPath.row];
            
            // 重命名
            NewViewVC *newViewVC = [[NewViewVC alloc] init];
            newViewVC.markText = @"重命名";
            newViewVC.placeholderText = @"请输入";
            newViewVC.content = downloadObject.fileName;
            newViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            newViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            newViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            [self.viewController presentViewController:newViewVC animated:YES completion:nil];
            newViewVC.clickBlock = ^(NSString *text) {
                [[ZFDownloadManager sharedInstance] renameFile:downloadObject.url name:text];
                [self initData];
                //发送通知刷新本地数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
            };
            

        }];
        return @[deleteRowAction,renameAction];

    }
    
}


// 重命名
- (void)renameFile:(NSString *)url name:(NSString *)name
{
    // 根据url重命名
    [[ZFDownloadManager sharedInstance] renameFile:url name:name];
    
    // 刷新数据
    [self initData];
    
}


#pragma mark - ZFDownloadDelegate

// 刷新单元格
- (void)downloadResponse:(ZFSessionModel *)sessionModel
{
    // 取到对应的cell上的model
    NSArray *downloadings = self.downloadObjectArr[0];
    if (downloadings) {
        if ([downloadings containsObject:sessionModel]) {
            
            NSInteger index = [downloadings indexOfObject:sessionModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            __block DownLoadingCell1 *cell = [self cellForRowAtIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            sessionModel.progressBlock = ^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.transportProgressLabel.text = [NSString stringWithFormat:@"%@/%@",writtenSize,totalSize];
                    cell.transportStateLabel.text = speed;
                    cell.extandBtn.selected = YES;

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
                        cell.transportStateLabel.text = @"已暂停";
                        cell.extandBtn.selected = NO;
                        //
                    }
                });

                
            };
        }
    }
}




@end
