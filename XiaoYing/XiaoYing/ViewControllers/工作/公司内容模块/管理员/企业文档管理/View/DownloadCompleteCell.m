//
//  DownloadCompleteCell.m
//  XiaoYing
//
//  Created by GZH on 16/6/30.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DownloadCompleteCell.h"
#import "CreateFolderController.h"
#import "RenameFolderController.h"
#import "DeleteDocumentController.h"

@implementation DownloadCompleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview: self.reNameBtn];
        [self.contentView addSubview: self.reNameLabel];
        [self.contentView addSubview: self.deleteBtn];
        [self.contentView addSubview: self.deleteLabel];
        
    }
    return self;
}

//重命名按钮(reNameAction:)
- (UIButton *)reNameBtn {
    if (_reNameBtn == nil) {
        self.reNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reNameBtn.frame = CGRectMake(75, 9, 20, 20);
        [_reNameBtn setImage:[UIImage imageNamed:@"rename"] forState:UIControlStateNormal];
        [_reNameBtn addTarget:self action:@selector(reNameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reNameBtn;
}

//重命名Label
- (UILabel *)reNameLabel {
    if (_reNameLabel == nil) {
        self.reNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 40, 14)];
        _reNameLabel.text = @"重命名";
        _reNameLabel.textAlignment = NSTextAlignmentLeft;
        _reNameLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _reNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _reNameLabel;
}

//删除按钮
- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(kScreen_Width - 75 - 19, 9, 19, 20);
        [_deleteBtn setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

//删除Label
- (UILabel *)deleteLabel {
    if (_deleteLabel == nil) {
        self.deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(_deleteBtn.frame.origin.x, _deleteBtn.bottom + 1, 40, 14)];
        _deleteLabel.text = @"删除";
        _deleteLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _deleteLabel.font = [UIFont systemFontOfSize:10];
    }
    return _deleteLabel;
}

//重命名操作
- (void)reNameAction:(UIButton *)btn
{
    RenameFolderController *renameFolderVC = [[RenameFolderController alloc] init];
    renameFolderVC.oldFolderId = self.oldFolderId;
    renameFolderVC.currentFolderName = self.oldFolderName;;
    renameFolderVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    renameFolderVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    renameFolderVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:renameFolderVC animated:YES completion:nil];
}

//删除操作
- (void)deleteAction:(UIButton *)btn
{
    DeleteDocumentController *deleteDocumentVC = [[DeleteDocumentController alloc] init];
    deleteDocumentVC.folderIdsArray = @[self.oldFolderId];
    deleteDocumentVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    deleteDocumentVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    deleteDocumentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:deleteDocumentVC animated:YES completion:nil];
}

@end
