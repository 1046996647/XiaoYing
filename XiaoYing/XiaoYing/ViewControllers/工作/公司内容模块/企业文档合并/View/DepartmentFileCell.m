//
//  DepartmentFileCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DepartmentFileCell.h"
#import "XYExtend.h"
#import "FileOperateVC.h"
#import "DocumentVM.h"
#import "DocumentMergeModel.h"
#import "NewViewVC.h"
#import "DeleteViewController.h"
#import "MoveFolderViewController.h"
#import "ZFDownloadManager.h"
#import "AuthorityForDocumentMethod.h"
#import "DocumentOtherMethod.h"

#import "NSObject+CalculateUnit.h"

@interface DepartmentFileCell()

@property (nonatomic, strong) UIImageView *markImageView; //标志图标
@property (nonatomic, strong) UILabel *fileNameLabel; //文件名称
@property (nonatomic, strong) UILabel *fileDepartmentLabel; //文件所属部门
@property (nonatomic, strong) UILabel *createTimeLabel; //文件创建时间
@property (nonatomic, strong) UILabel *fileSizeLabel; //文件大小
@property (nonatomic, strong) UIButton *extandBtn; //扩展按钮
@property (nonatomic, strong) UIView *separatorLine; //

@end

@implementation DepartmentFileCell

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
    
    [self.markImageView sd_setImageWithURL:[NSURL URLWithString:[NSString replaceString:_DocumentModel.thumbnailUrl Withstr1:@"100" str2:@"100" str3:@"c"]] placeholderImage:[DocumentOtherMethod getDocumentThumImageWithfileName:_DocumentModel.documentName]];
    
    self.fileNameLabel.text = _DocumentModel.documentName;
    
    self.fileDepartmentLabel.text = _DocumentModel.documentDepartment; //文件所在部门名称
    
    self.createTimeLabel.text = _DocumentModel.documentCreateTime;
    
    self.fileSizeLabel.text = [NSString stringWithFormat:@"%.2f%@",
                               [DocumentMergeModel calculateFileSizeInUnit:(unsigned long long)_DocumentModel.documentSize],
                               [DocumentMergeModel calculateUnit:(unsigned long long)_DocumentModel.documentSize]];
}

- (void)setupContentView
{
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.fileNameLabel];
    [self.contentView addSubview:self.fileDepartmentLabel];
    [self.contentView addSubview:self.createTimeLabel];
    [self.contentView addSubview:self.fileSizeLabel];
    [self.contentView addSubview:self.extandBtn];
    [self.contentView addSubview:self.separatorLine];
    
    //___
    self.markImageView.frame = CGRectMake(12, 10, 35, 30);
    self.markImageView.image = [UIImage imageNamed:@"other"];
    
    //___
    NSString *fileNameStr = @"文件文件";
    
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
    self.createTimeLabel.frame = CGRectMake(self.fileDepartmentLabel.left, self.fileDepartmentLabel.bottom, fileNameLabelW, 10);
    self.createTimeLabel.font = [UIFont systemFontOfSize:12];
    self.createTimeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.createTimeLabel.text = @"2016-01-12 17:25";
    
    //___
    CGFloat fileSizeLabelX = self.fileNameLabel.left + self.fileNameLabel.width + 10;
    self.fileSizeLabel.frame = CGRectMake(fileSizeLabelX, 20, 60, 15);
    self.fileSizeLabel.text = @"100KB";
    self.fileSizeLabel.font = [UIFont systemFontOfSize:12];
    self.fileSizeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    
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
    
    if (self.height <= 70) {
        self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, self.height - 50);
        self.fileNameLabel.numberOfLines = 0;
        self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom + 5, fileNameLabelW, 10);
        self.createTimeLabel.frame = CGRectMake(self.fileDepartmentLabel.left, self.fileDepartmentLabel.bottom + 5, fileNameLabelW, 10);
        self.separatorLine.frame = CGRectMake(0, self.height - 0.5, kScreen_Width, 0.5);
    }
    if (self.height > 70 && self.height < 110) {
        self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, self.height - 50);
        self.fileNameLabel.numberOfLines = 0;
        self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom + 5, fileNameLabelW, 10);
        self.createTimeLabel.frame = CGRectMake(self.fileDepartmentLabel.left, self.fileDepartmentLabel.bottom + 5, fileNameLabelW, 10);
        self.separatorLine.frame = CGRectMake(0, self.height - 0.5, kScreen_Width, 0.5);
    }
    if (self.height >= 110) {
        self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, self.height - 50);
        self.fileNameLabel.numberOfLines = 3;
        self.fileDepartmentLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom + 5, fileNameLabelW, 10);
        self.createTimeLabel.frame = CGRectMake(self.fileDepartmentLabel.left, self.fileDepartmentLabel.bottom + 5, fileNameLabelW, 10);
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

- (UILabel *)createTimeLabel
{
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] init];
    }
    return _createTimeLabel;
}

-(UILabel *)fileSizeLabel
{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] init];
    }
    return _fileSizeLabel;
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
    BOOL downFileAuthBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        NSString *tempStr = self.DocumentModel.deocumentDepartmentId;
        auth.regionName(@"下载文件").deparmentId(tempStr);
    }];
    
    BOOL moveFileAuthBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        NSString *tempStr = self.DocumentModel.deocumentDepartmentId;
        auth.regionName(@"移动文件").deparmentId(tempStr);
    }];
    
    BOOL renameFileAuthBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        NSString *tempStr = self.DocumentModel.deocumentDepartmentId;
        auth.regionName(@"重命名文件").deparmentId(tempStr);
    }];
    
    BOOL deleteFileAuthBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        NSString *tempStr = self.DocumentModel.deocumentDepartmentId;
        auth.regionName(@"删除文件").deparmentId(tempStr);
    }];
    
    __weak typeof(self)weakSelf = self;
    
    FileOperateVC *vc  = [[FileOperateVC alloc] init];
    vc.fileType = 0;// 0:文件 1：文件夹
    vc.authForButtnArr = @[[NSNumber numberWithBool:downFileAuthBool], [NSNumber numberWithBool:moveFileAuthBool], [NSNumber numberWithBool:renameFileAuthBool], [NSNumber numberWithBool:deleteFileAuthBool]];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:vc animated:YES completion:nil];
    [vc setFileOperateBlock:^(NSInteger filetype, NSInteger tag) {
        
        if (filetype == 0) {
            if (tag == 0) {
                // 下载
                NSLog(@"下载");
                
                // 下载
                NSLog(@"--------00=======" );
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
                
                //3.打通block回调通道
                moveFolderVC.movePlaceBlock = ^(NSString *departmentId, NSString *folderName, NSString *folderId){
                    
                    NSLog(@"将文件移动到:%@-%@-%@", departmentId, folderName, folderId);
                    [DocumentVM removeFileToDestributeFolderId:folderId fileId:weakSelf.DocumentModel.documentId departmentId:departmentId success:^(NSDictionary *dataList) {
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
                    
                    [DocumentVM renameFileWithOldFileId:weakSelf.DocumentModel.documentId newFileName:text success:^(NSDictionary *dataList) {
                        
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
                    [DocumentVM deleteDocumentWithFolderIds:@[] fileIds:@[self.DocumentModel.documentId] success:^(NSDictionary *dataList) {
                        
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
