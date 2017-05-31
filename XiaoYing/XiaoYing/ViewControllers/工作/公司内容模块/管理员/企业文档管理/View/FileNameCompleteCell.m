//
//  FileNameCompleteCell.m
//  XiaoYing
//
//  Created by GZH on 16/7/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileNameCompleteCell.h"
#import "RenameFileViewController.h"
#import "DeleteDocumentController.h"
#import "MoveFileViewController.h"
#import "MulSelectDepartmentVC.h"
#import "DocumentViewModel.h"
#import "CompanyFileManageController.h"

#define quarter (kScreen_Width / 9)

@implementation FileNameCompleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.reNameBtn];
        [self.contentView addSubview:self.reNameLabel];
        [self.contentView addSubview:self.visibleBtn];
        [self.contentView addSubview:self.visibleLabel];
        [self.contentView addSubview:self.transferBtn];
        [self.contentView addSubview:self.transferLabel];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.deleteLabel];
    }
    return self;
}

//_______________________________________________
//重命名按钮
- (UIButton *)reNameBtn {
    if (_reNameBtn == nil) {
        self.reNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reNameBtn.frame = CGRectMake(quarter + 5, 9, 20, 20);
        [_reNameBtn setImage:[UIImage imageNamed:@"rename"] forState:UIControlStateNormal];
        [_reNameBtn addTarget:self action:@selector(reNameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reNameBtn;
}

//重命名label
- (UILabel *)reNameLabel {
    if (_reNameLabel == nil) {
        self.reNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(quarter + 2, 30, 40, 14)];
        _reNameLabel.text = @"重命名";
        _reNameLabel.textAlignment = NSTextAlignmentLeft;
        _reNameLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _reNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _reNameLabel;
}

//_______________________________________________
//可见范围按钮
- (UIButton *)visibleBtn {
    if (_visibleBtn == nil) {
        self.visibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _visibleBtn.frame = CGRectMake(quarter * 3 + 5, 9, 25, 17);
        [_visibleBtn setImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
        [_visibleBtn addTarget:self action:@selector(visibleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visibleBtn;
}

//可见范围label
- (UILabel *)visibleLabel {
    if (_visibleLabel == nil) {
        self.visibleLabel = [[UILabel alloc]initWithFrame:CGRectMake(quarter * 3 - 3, 30, 46, 14)];
        _visibleLabel.text = @"可见范围";
        _visibleLabel.textAlignment = NSTextAlignmentLeft;
        _visibleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _visibleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _visibleLabel;
}

//_______________________________________________
//移动按钮
- (UIButton *)transferBtn {
    if (_transferBtn == nil) {
        self.transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferBtn.frame = CGRectMake(quarter * 5 + 5, 9, 25, 17);
        [_transferBtn setImage:[UIImage imageNamed:@"move"] forState:UIControlStateNormal];
        [_transferBtn addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;
}

//移动label
- (UILabel *)transferLabel {
    if (_transferLabel == nil) {
        self.transferLabel = [[UILabel alloc]initWithFrame:CGRectMake(quarter * 5 + 5, 30, 30, 14)];
        _transferLabel.text = @"移动";
        _transferLabel.textAlignment = NSTextAlignmentLeft;
        _transferLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _transferLabel.font = [UIFont systemFontOfSize:10];
    }
    return _transferLabel;
}

//_______________________________________________
//删除按钮
- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(quarter * 7 + 5, 9, 19, 20);
        [_deleteBtn setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

//删除label
- (UILabel *)deleteLabel {
    if (_deleteLabel == nil) {
        self.deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(_deleteBtn.frame.origin.x, _deleteBtn.bottom + 1, 30, 14)];
        _deleteLabel.text = @"删除";
        _deleteLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _deleteLabel.font = [UIFont systemFontOfSize:11];
    }
    return _deleteLabel;
}

//_______________________________________________
//重命名操作
- (void)reNameAction:(UIButton *)btn
{
    RenameFileViewController *renameFileVC = [[RenameFileViewController alloc] init];
    renameFileVC.oldFileId = self.oldFileId;
    renameFileVC.currentFileName = self.oldFileName;
    renameFileVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    renameFileVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    renameFileVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:renameFileVC animated:YES completion:nil];
}

//_______________________________________________
//删除操作
- (void)deleteAction:(UIButton *)btn
{
    DeleteDocumentController *deleteDocumentVC = [[DeleteDocumentController alloc] init];
    deleteDocumentVC.fileIdsArray = @[self.oldFileId];
    deleteDocumentVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    deleteDocumentVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    deleteDocumentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:deleteDocumentVC animated:YES completion:nil];
}

//_______________________________________________
//移动操作
- (void)transferAction:(UIButton *)btn
{
    NSLog(@"移动操作");
    MoveFileViewController *moveFileVC = [[MoveFileViewController alloc] init];
    moveFileVC.folderName = @"根目录";
    moveFileVC.folderId = @"";
    moveFileVC.fileId = self.oldFileId;
    self.viewController.navigationController.navigationBarHidden = NO;
    [self.viewController.navigationController pushViewController:moveFileVC animated:YES];
}

//_______________________________________________
//可见范围操作
- (void)visibleAction:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"可见范围操作");
    MulSelectDepartmentVC *mulSelectDepartmentVC = [[MulSelectDepartmentVC alloc] init];
    
    NSLog(@"self.departmentIdsArray~~~~~%@", self.departmentIdsArray);
    
    [self.departmentIdsArray enumerateObjectsUsingBlock:^(NSString *departmentIdStr , NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([departmentIdStr isEqualToString:@"Uzg9"]) {
            weakSelf.departmentIdsArray[idx] = @"";
            *stop = YES;
        }
    }];
    
    mulSelectDepartmentVC.selectedArr = self.departmentIdsArray;
    
    mulSelectDepartmentVC.title = @"可见范围";
    self.viewController.navigationController.navigationBarHidden = NO;
    [self.viewController.navigationController pushViewController:mulSelectDepartmentVC animated:YES];
    
    mulSelectDepartmentVC.sendBlock = ^(NSMutableArray *arrM) {
        
        [arrM enumerateObjectsUsingBlock:^(NSString *departmentIdStr , NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([departmentIdStr isEqualToString:@""]) {
                arrM[idx] = @"Uzg9";
                *stop = YES;
            }
        }];
        
        NSString *departmentIdArrayStr = [arrM componentsJoinedByString:@","];
        
        [DocumentViewModel setVisibleForFileWithFileId:weakSelf.oldFileId fileName:weakSelf.oldFileName visibleDepartmentIds:departmentIdArrayStr success:^(NSDictionary *dataList) {
            
            NSLog(@"可见范围设置成功:%@", dataList);
            
            //刷新数据源和UI
            CompanyFileManageController *companyFileManagerVC = (CompanyFileManageController *)self.viewController;
            [companyFileManagerVC refreshDocumentTableView];
            
        } failed:^(NSError *error) {
            
            NSLog(@"可见范围设置失败:%@", error);
            
        }];
        
    };
    
}

@end
