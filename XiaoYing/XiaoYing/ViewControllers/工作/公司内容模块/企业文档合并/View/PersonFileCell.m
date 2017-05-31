//
//  PersonFileCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/15.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "PersonFileCell.h"
#import "XYExtend.h"
#import "FileOperateVC.h"
#import "DocumentMergeModel.h"
#import "DocumentVM.h"
#import "DocumentMergeModel.h"
#import "NewViewVC.h"
#import "DeleteViewController.h"
#import "MoveFolderViewController.h"
#import "ZFDownloadManager.h"
#import "AuthorityForDocumentMethod.h"

@implementation PersonFileCell

#pragma mark -buttonAction
- (void)extandBtnAction:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    
    FileOperateVC *vc  = [[FileOperateVC alloc] init];
    vc.fileType = 0;// 0:文件 1：文件夹
    vc.authForButtnArr = @[[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES]];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:vc animated:YES completion:nil];
    [vc setFileOperateBlock:^(NSInteger filetype, NSInteger tag) {
        
        if (filetype == 0) {
            if (tag == 0) {
                // 下载
                NSLog(@"下载");

                NSString *addressURL = [downLoadBaseUrl stringByAppendingFormat:@"%@%@",self.DocumentModel.documentUrl,self.DocumentModel.documentName];
                
                if ([[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:addressURL withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                    
                }]) {
                    [MBProgressHUD showMessage:@"已加入下载列表!" toView:self];
                    
                } else {
                    
                    NSMutableArray *downloading = [ZFDownloadManager sharedInstance].downloadingArray;
                    
                    // 只支持单个文件下载判断((实际上支持多文件下载的)
                    if (downloading.count > 0) {
                        [MBProgressHUD showMessage:@"暂不支持多个文件下载!" toView:self];
                        return;
                    }
                    
                    //已经下载
                    if ([[ZFDownloadManager sharedInstance] isCompletion:addressURL]) {
                        [MBProgressHUD showMessage:@"该文件已下载!" toView:self];
                        return;
                    }
                    
                    [[ZFDownloadManager sharedInstance] download:addressURL type:self.DocumentModel.documentType thumbnailUrl:self.DocumentModel.thumbnailUrl  progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                    } state:^(DownloadState state) {}];
                    
                }
                
            }
            if (tag == 1) {
                // 移动
                //1.创建移动文件夹选择VC
                MoveFolderViewController *moveFolderVC = [[MoveFolderViewController alloc] init];
                
                //2.将当前的部门id传过去
                moveFolderVC.folderName = @"根目录";
                moveFolderVC.folderId = @"";
                moveFolderVC.departmentId = weakSelf.DocumentModel.deocumentDepartmentId;
                moveFolderVC.departmentId = @" ";//用@" "与公司的@""相区别
                
                //3.打通block回调通道
                moveFolderVC.movePlaceBlock = ^(NSString *departmentId, NSString *folderName, NSString *folderId){
                    
                    NSLog(@"将文件移动到:%@-%@-%@", departmentId, folderName, folderId);
                    [DocumentVM personRemoveFileToDestributeFolderId:folderId fileId:weakSelf.DocumentModel.documentId success:^(NSDictionary *dataList) {
                        // 刷新数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                    } failed:^(NSError *error) {
                        
                    }];
                };
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:moveFolderVC];
                //4.模态视图
                [self.viewController.navigationController presentViewController:nav animated:YES completion:nil];
                
            }
            if (tag == 2) {
                // 重命名
                NewViewVC *newViewVC = [[NewViewVC alloc] init];
                newViewVC.markText = @"重命名";
                newViewVC.placeholderText = @"请输入";
                newViewVC.content = self.DocumentModel.documentName;
                newViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                newViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                newViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                [self.viewController presentViewController:newViewVC animated:YES completion:nil];
                newViewVC.clickBlock = ^(NSString *text) {
                    
                    [DocumentVM personRenameFileWithOldFileId:weakSelf.DocumentModel.documentId newFileName:text success:^(NSDictionary *dataList) {
                        // 刷新数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                    } failed:^(NSError *error) {
                        
                    }];
                };
                
            }
            if (tag == 3) {
                // 删除
                DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
                deleteViewController.titleStr = @"是否确定删除该文件?";
                deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                //self.definesPresentationContext = YES; //不盖住整个屏幕
                deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                [self.viewController presentViewController:deleteViewController animated:YES completion:nil];
                deleteViewController.fileDeleteBlock = ^(void)
                {
                    [DocumentVM personDeleteDocumentWithFolderIds:@[] fileIds:@[self.DocumentModel.documentId] success:^(NSDictionary *dataList) {
                        // 刷新数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                    } failed:^(NSError *error) {
                        
                    }];
                };
                
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        else {
            if (tag == 0) {
                // 重命名
                NSLog(@"重命名");
            }
            if (tag == 1) {
                // 删除
                NSLog(@"删除");
                
            }
        }
    }];
}

@end
