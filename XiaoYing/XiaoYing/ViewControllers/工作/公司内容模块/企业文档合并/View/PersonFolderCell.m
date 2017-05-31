//
//  PersonFolderCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/15.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "PersonFolderCell.h"
#import "FileOperateVC.h"
#import "DocumentMergeModel.h"
#import "NewViewVC.h"
#import "DeleteViewController.h"
#import "DocumentVM.h"

@implementation PersonFolderCell

#pragma mark -buttonAction
- (void)extandBtnAction:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    
    FileOperateVC *vc  = [[FileOperateVC alloc] init];
    vc.fileType = 1;// 0:文件 1：文件夹
    vc.authForButtnArr = @[[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES]];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:vc animated:YES completion:nil];
    [vc setFileOperateBlock:^(NSInteger filetype, NSInteger tag) {
        
        if (filetype == 0) {
            if (tag == 0) {
                // 下载
                NSLog(@"下载");
            }
            if (tag == 1) {
                // 移动
                NSLog(@"移动");
                
            }
            if (tag == 2) {
                // 重命名
                NSLog(@"重命名");
                
            }
            if (tag == 3) {
                // 删除
                NSLog(@"删除");
                
            }
        }
        else {
            if (tag == 0) {
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
                    
                    [DocumentVM personRenameFolderWithOldFolderId:weakSelf.DocumentModel.documentId newFolderName:text success:^(NSDictionary *dataList) {
                        // 刷新数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                    } failed:^(NSError *error) {
                        
                        
                    }];
                };
            }
            if (tag == 1) {
                // 删除
                DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
                deleteViewController.titleStr = @"是否确定删除该文件夹?";
                deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                //self.definesPresentationContext = YES; //不盖住整个屏幕
                deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                [self.viewController presentViewController:deleteViewController animated:YES completion:nil];
                deleteViewController.fileDeleteBlock = ^(void)
                {
                    [DocumentVM personDeleteDocumentWithFolderIds:@[self.DocumentModel.documentId] fileIds:@[] success:^(NSDictionary *dataList) {
                        
                        if ([dataList[@"Code"] intValue] == 1) {
                            [MBProgressHUD showMessage:dataList[@"Message"]];
                        } else {
                            // 刷新数据
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                        }
                        
                    } failed:^(NSError *error) {
                        
                        
                    }];
                };
                
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    }];
}

@end
