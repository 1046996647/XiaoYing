//
//  PersonDocumentTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/5.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "PersonDocumentTableView.h"
#import "PersonFolderCell.h"
#import "PersonFileCell.h"
#import "DisplayDocumentViewController.h"
#import "DocumentMergeModel.h"
#import "XYExtend.h"

@interface PersonDocumentTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PersonDocumentTableView
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
            
            PersonFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonFolderCELL"];
            if (!cell) {
                cell = [[PersonFolderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonFolderCELL"];
            }
            DocumentMergeModel *tempModel = [self.folderArray objectAtIndex:indexPath.row];
            cell.DocumentModel = tempModel;
            return cell;
            
        }else {
            
            PersonFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonFileCELL"];
            if (!cell) {
                cell = [[PersonFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonFileCELL"];
            }
            DocumentMergeModel *tempModel = [self.fileArray objectAtIndex:(indexPath.row - self.folderArray.count)];
            cell.DocumentModel = tempModel;
            return cell;
            
        }
    }else {
        
        if (indexPath.row < self.fileArray.count) {
            PersonFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonFileCELL"];
            if (!cell) {
                cell = [[PersonFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonFileCELL"];
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
            
            if (textHeight <= 30) {
                return 50;
            }else if (textHeight > 30 && textHeight < 60) {
                return textHeight + 20;
            } else {
                return 80;
            }
            
        }else {
            
            tempModel = [self.fileArray objectAtIndex:(indexPath.row - self.folderArray.count)];
            CGFloat textHeight = [HSMathod getHightForText:tempModel.documentName limitWidth:(kScreen_Width - 137) fontSize:16];
            
            if (textHeight <= 20) {
                return 55;
            }else if (textHeight > 20 && textHeight < 60) {
                return textHeight + 35;
            } else {
                return 95;
            }
            
        }
    }else {
        
        if (indexPath.row < self.fileArray.count) {

            tempModel = [self.fileArray objectAtIndex:indexPath.row];
            CGFloat textHeight = [HSMathod getHightForText:tempModel.documentName limitWidth:(kScreen_Width - 137) fontSize:16];
            
            if (textHeight <= 20) {
                return 55;
            }else if (textHeight > 20 && textHeight < 60) {
                return textHeight + 35;
            } else {
                return 95;
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
    
    PersonFolderCell *personFolderCell = [tableView cellForRowAtIndexPath:indexPath];
    if (personFolderCell.DocumentModel.documentType != 0) { //是文件夹才跳转
        return;
    }
    
    DisplayDocumentViewController *displayDocumentVC = [[DisplayDocumentViewController alloc] init];
    displayDocumentVC.displayDocumentType = 3;
    displayDocumentVC.folderName = personFolderCell.DocumentModel.documentName;
    displayDocumentVC.folderId = personFolderCell.DocumentModel.documentId;
    displayDocumentVC.departmentId = @" ";
    displayDocumentVC.departmentName = @"个人文档";
    
    if ([self.viewController isKindOfClass:[DisplayDocumentViewController class]]) {
        DisplayDocumentViewController *disVC = (DisplayDocumentViewController *)self.viewController;
        displayDocumentVC.folderAllPathArr = disVC.folderAllPathArr.mutableCopy;
        [displayDocumentVC.folderAllPathArr addObject:personFolderCell.DocumentModel.documentName];
    }else {
        [displayDocumentVC.folderAllPathArr addObject:personFolderCell.DocumentModel.documentName];
    }
    
    [self.viewController.navigationController pushViewController:displayDocumentVC animated:YES];
}

@end
