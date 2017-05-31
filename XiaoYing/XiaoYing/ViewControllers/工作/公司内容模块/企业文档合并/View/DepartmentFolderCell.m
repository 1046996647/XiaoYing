//
//  DepartmentFolderCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DepartmentFolderCell.h"
#import "XYExtend.h"
#import "FileOperateVC.h"
#import "NewViewVC.h"
#import "DeleteViewController.h"
#import "DocumentVM.h"
#import "DocumentMergeModel.h"
#import "AuthorityForDocumentMethod.h"

@interface DepartmentFolderCell()

@property (nonatomic, strong) UIImageView *markImageView; //标志图标
@property (nonatomic, strong) UILabel *fileNameLabel; //文件夹名称
@property (nonatomic, strong) UILabel *fileDepartmentLabel; //文件所属部门
@property (nonatomic, strong) UIButton *extandBtn; //扩展按钮
@property (nonatomic, strong) UIView *separatorLine; //

@end

@implementation DepartmentFolderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupContentView];
    }
    return self;
}

- (void)setDocumentModel:(DocumentMergeModel *)DocumentModel
{
    _DocumentModel = DocumentModel;
    
    self.fileNameLabel.text = _DocumentModel.documentName;
    
    self.fileDepartmentLabel.text = _DocumentModel.documentDepartment;
}

- (void)setupContentView
{
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.fileNameLabel];
    [self.contentView addSubview:self.fileDepartmentLabel];
    [self.contentView addSubview:self.extandBtn];
    [self.contentView addSubview:self.separatorLine];
    
    //___
    self.markImageView.frame = CGRectMake(12, 10, 35, 30);
    self.markImageView.image = [UIImage imageNamed:@"wenjian"];
    
    //___
    NSString *fileNameStr = @"部门文件夹";
    
    CGFloat fileNameLabelX = self.markImageView.left + self.markImageView.width +10;
    CGFloat fileNameLabelY = 10;
    CGFloat fileNameLabelW = kScreen_Width - fileNameLabelX - 80;
    
    self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, 20);
    self.fileNameLabel.numberOfLines = 0;
    self.fileNameLabel.font = [UIFont systemFontOfSize:16];
    self.fileNameLabel.text = fileNameStr;
    
    //___
    self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom, fileNameLabelW, 10);
    self.fileDepartmentLabel.font = [UIFont systemFontOfSize:12];
    self.fileDepartmentLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.fileDepartmentLabel.text = @"科技产业部";
    
    //___
    self.extandBtn.frame = CGRectMake(kScreen_Width-14-12, 0, 26, 40);
    self.extandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.extandBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.extandBtn.imageEdgeInsets = UIEdgeInsetsMake(21, 0, 0, 0);
    [self.extandBtn setImage:[UIImage imageNamed:@"jiantou_gray"] forState:UIControlStateNormal];
    [self.extandBtn addTarget:self action:@selector(extandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //___
    self.separatorLine.frame = CGRectMake(0, self.height - 0.5, kScreen_Width, 0.5);
}

- (void)layoutSubviews
{
    CGFloat fileNameLabelX = self.markImageView.left + self.markImageView.width +10;
    CGFloat fileNameLabelY = 10;
    CGFloat fileNameLabelW = kScreen_Width - fileNameLabelX - 80;
    
    if (self.height <= 55) {
        self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, self.height - 35);
        self.fileNameLabel.numberOfLines = 0;
        self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom + 5, fileNameLabelW, 10);
        self.separatorLine.frame = CGRectMake(0, self.height - 0.5, kScreen_Width, 0.5);
    }
    if (self.height > 55 && self.height < 95) {
        self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, self.height - 35);
        self.fileNameLabel.numberOfLines = 0;
        self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom + 5, fileNameLabelW, 10);
        self.separatorLine.frame = CGRectMake(0, self.height - 0.5, kScreen_Width, 0.5);
    }
    if (self.height >= 95) {
        self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, self.height - 35);
        self.fileNameLabel.numberOfLines = 3;
        self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom + 5, fileNameLabelW, 10);
        self.separatorLine.frame = CGRectMake(0, self.height - 0.5, kScreen_Width, 0.5);
    }
}

- (UIImageView *)markImageView
{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
    }
    return _markImageView;
}

- (UILabel *)fileNameLabel
{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc] init];
    }
    return _fileNameLabel;
}

- (UILabel *)fileDepartmentLabel
{
    if (!_fileDepartmentLabel) {
        _fileDepartmentLabel = [[UILabel alloc] init];
    }
    return _fileDepartmentLabel;
}

- (UIButton *)extandBtn
{
    if (!_extandBtn) {
        _extandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _extandBtn;
}

- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor lightGrayColor];
        _separatorLine.alpha = 0.9;
    }
    return _separatorLine;
}

#pragma mark -buttonAction
- (void)extandBtnAction:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    
    BOOL renameFolderAuthBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        NSString *tempStr = self.DocumentModel.deocumentDepartmentId;
        auth.regionName(@"重命名文件夹").deparmentId(tempStr);
    }];
    
    BOOL deleteFolderAuthBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        NSString *tempStr = self.DocumentModel.deocumentDepartmentId;
        auth.regionName(@"删除文件夹").deparmentId(tempStr);
    }];
    
    FileOperateVC *vc  = [[FileOperateVC alloc] init];
    vc.fileType = 1;// 0:文件 1：文件夹
    vc.authForButtnArr = @[[NSNumber numberWithBool:renameFolderAuthBool], [NSNumber numberWithBool:deleteFolderAuthBool]];
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
                //newViewVC.content = [NSString stringWithFormat:@"%ld人群",(unsigned long)_selectedArr.count];
                newViewVC.content = self.DocumentModel.documentName;
                newViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                newViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                newViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                [self.viewController presentViewController:newViewVC animated:YES completion:nil];
                newViewVC.clickBlock = ^(NSString *text) {
                    
                    [DocumentVM renameFolderWithOldFolderId:weakSelf.DocumentModel.documentId newFolderName:text success:^(NSDictionary *dataList) {
                        
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
                    [DocumentVM deleteDocumentWithFolderIds:@[self.DocumentModel.documentId] fileIds:@[] success:^(NSDictionary *dataList) {
                        
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
