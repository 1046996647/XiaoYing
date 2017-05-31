//
//  DepartmentDocumentTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/5.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DepartmentDocumentTableView.h"
#import "XYExtend.h"
#import "DepartmentFolderCell.h"
#import "DepartmentFileCell.h"
#import "DisplayDocumentViewController.h"
#import "DocumentMergeModel.h"

@interface DepartmentDocumentTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DepartmentDocumentTableView
@synthesize folderArray = _folderArray, fileArray = _fileArray;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSMutableArray *)documentListArray
{
    if (!_documentListArray) {
        _documentListArray = [[NSMutableArray alloc] init];
    }
    return _documentListArray;
}

- (NSArray *)folderArray
{
    if (!_folderArray) {
        _folderArray = [[NSArray alloc] init];
    }
    return _folderArray;
}

- (void)setFolderArray:(NSArray *)folderArray
{
    _folderArray = folderArray;
    [self reloadData];
}

- (NSArray *)fileArray
{
    if (!_fileArray) {
        _fileArray = [[NSArray alloc] init];
    }
    return _fileArray;
}

- (void)setFileArray:(NSArray *)fileArray
{
    _fileArray = fileArray;
    [self reloadData];
}

#pragma mark - tableViewDataSource,UITableViewDelegate
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.folderArray.count + self.fileArray.count);
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.folderArray.count > 0) {
        
        if (indexPath.row < self.folderArray.count) {
            
            DepartmentFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departmentFolderCELL"];
            if (!cell) {
                cell = [[DepartmentFolderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"departmentFolderCELL"];
            }
            DocumentMergeModel *tempModel = [self.folderArray objectAtIndex:indexPath.row];
            cell.DocumentModel = tempModel;
            return cell;
            
        }else {
            
            DepartmentFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departmentFileCELL"];
            if (!cell) {
                cell = [[DepartmentFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"departmentFileCELL"];
            }
            DocumentMergeModel *tempModel = [self.fileArray objectAtIndex:(indexPath.row - self.folderArray.count)];
            cell.DocumentModel = tempModel;
            return cell;
            
        }
    }else {
        
        if (indexPath.row < self.fileArray.count) {
            DepartmentFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departmentFileCELL"];
            if (!cell) {
                cell = [[DepartmentFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"departmentFileCELL"];
            }
            DocumentMergeModel *tempModel = [self.fileArray objectAtIndex:indexPath.row];
            cell.DocumentModel = tempModel;
            return cell;
        }else {
            return nil;
        }
    }
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentMergeModel *tempModel = [[DocumentMergeModel alloc] init];
    
    if (self.folderArray.count > 0) {
        
        if (indexPath.row < self.folderArray.count) {
            
            tempModel = [self.folderArray objectAtIndex:indexPath.row];
            CGFloat textHeight = [HSMathod getHightForText:tempModel.documentName limitWidth:(kScreen_Width - 137) fontSize:16];
            
            if (textHeight <= 20) {
                return 55;
            }else if (textHeight > 20 && textHeight < 60) {
                return textHeight + 35;
            } else {
                return 95;
            }
            
        }else {
            
            tempModel = [self.fileArray objectAtIndex:(indexPath.row - self.folderArray.count)];
            CGFloat textHeight = [HSMathod getHightForText:tempModel.documentName limitWidth:(kScreen_Width - 137) fontSize:16];
            
            if (textHeight <= 20) {
                return 70;
            }else if (textHeight > 20 && textHeight < 60) {
                return textHeight + 50;
            } else {
                return 110;
            }
            
        }
    }else {
        
        if (indexPath.row < self.fileArray.count) {
            tempModel = [self.fileArray objectAtIndex:indexPath.row];
            CGFloat textHeight = [HSMathod getHightForText:tempModel.documentName limitWidth:(kScreen_Width - 137) fontSize:16];
            
            if (textHeight <= 20) {
                return 70;
            }else if (textHeight > 20 && textHeight < 60) {
                return textHeight + 50;
            } else {
                return 110;
            }
            
        }else {
            return 0;
        }
    }
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//当已经点击cell时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DepartmentFolderCell *departmentFolderCell = [tableView cellForRowAtIndexPath:indexPath];
    if (departmentFolderCell.DocumentModel.documentType != 0) { //是文件夹才跳转
        return;
    }
    
    DisplayDocumentViewController *displayDocumentVC = [[DisplayDocumentViewController alloc] init];
    displayDocumentVC.displayDocumentType = 2;
    displayDocumentVC.folderName = departmentFolderCell.DocumentModel.documentName;
    displayDocumentVC.folderId = departmentFolderCell.DocumentModel.documentId;
    displayDocumentVC.departmentId = departmentFolderCell.DocumentModel.deocumentDepartmentId;
    displayDocumentVC.departmentName = departmentFolderCell.DocumentModel.documentDepartment;
    
    if ([self.viewController isKindOfClass:[DisplayDocumentViewController class]]) {
        DisplayDocumentViewController *disVC = (DisplayDocumentViewController *)self.viewController;
        displayDocumentVC.folderAllPathArr = disVC.folderAllPathArr.mutableCopy;
        [displayDocumentVC.folderAllPathArr addObject:departmentFolderCell.DocumentModel.documentName];
    }else {
        [displayDocumentVC.folderAllPathArr addObject:departmentFolderCell.DocumentModel.documentName];
    }
    
    [self.viewController.navigationController pushViewController:displayDocumentVC animated:YES];
}

@end
