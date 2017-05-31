//
//  UploadDocumentTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "UploadDocumentTableView.h"
#import "TransportingCell.h"
#import "TransportedCell.h"
#import "DocumentUploadFileModel.h"
#import "TransportDropMethod.h"
#import "NSObject+CalculateUnit.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface UploadDocumentTableView()<UITableViewDelegate, UITableViewDataSource>

/** 上传完成的模型数组*/
@property (nonatomic, strong) NSMutableArray *uploadedArray;

@end

@implementation UploadDocumentTableView
@synthesize documentUploadFileModel = _documentUploadFileModel;

- (DocumentUploadFileModel *)documentUploadFileModel
{
    if (!_documentUploadFileModel) {
        _documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    }
    return _documentUploadFileModel;
}

- (void)setDocumentUploadFileModel:(DocumentUploadFileModel *)documentUploadFileModel
{
    _documentUploadFileModel = documentUploadFileModel;
    
    if (_documentUploadFileModel.isUploadFinish) {
        
        self.uploadedArray = [TransportDropMethod getUploadedArray];
        [self reloadData];
    }
    else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        TransportingCell *cell = [self cellForRowAtIndexPath:indexPath];
        //文件名称
        cell.fileNameLabel.text = _documentUploadFileModel.fileName;
        
        //               文件上传进度        
        // 已上传大小
        NSString *fileCompleteUploadNum = [NSString stringWithFormat:@"%.2f%@",
                              [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long)_documentUploadFileModel.fileCompleteUploadNum],
                              [DocumentUploadFileModel calculateUnit:(unsigned long long)_documentUploadFileModel.fileCompleteUploadNum]];
        
        // 总文件大小
        NSString *fileSize = [NSString stringWithFormat:@"%.2f%@",
                                     [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long)_documentUploadFileModel.fileSize],
                                     [DocumentUploadFileModel calculateUnit:(unsigned long long)_documentUploadFileModel.fileSize]];
        cell.transportProgressLabel.text = [NSString stringWithFormat:@"%@/%@", fileCompleteUploadNum, fileSize];

        
        //文件上传速度
        float speedSec = [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long) _documentUploadFileModel.fileUploadSpeed];
        NSString *unit = [DocumentUploadFileModel calculateUnit:(unsigned long long) _documentUploadFileModel.fileUploadSpeed];
        NSString *speedStr = [NSString stringWithFormat:@"%.0f%@/S",speedSec,unit];
        cell.transportStateLabel.text = speedStr;
//        cell.transportStateLabel.text = [NSString stringWithFormat:@"%ldKB/S", (long)_documentUploadFileModel.fileUploadSpeed];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    _documentUploadFileModel = self.documentUploadFileModel;
    _uploadedArray = [TransportDropMethod getUploadedArray];

}

#pragma mark - tableViewDataSource,UITableViewDelegate
//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;

}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (!_documentUploadFileModel || _documentUploadFileModel.isUploadFinish) {
            return 0;
        }
        else {
            return 1;
            
        }
    } else {
        return self.uploadedArray.count;
    }
    
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TransportingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transportingCELL"];
        if (!cell) {
            cell = [[TransportingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transportingCELL"];
        }
        cell.documentUploadFileModel = self.documentUploadFileModel;
        return cell;
        
    }else {
        TransportedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transportedCELL"];
        if (!cell) {
            cell = [[TransportedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transportedCELL"];
        }
        DocumentUploadFileModel *model = self.uploadedArray[indexPath.row];
        cell.fileNameLabel.text = model.fileName;
//        cell.fileSizeLabel.backgroundColor = [UIColor redColor];
//        cell.fileSizeLabel.frame = kScreen_Width-12-100;
        cell.fileSizeLabel.frame = CGRectMake(kScreen_Width-12-120, 0, 120, cell.height);
        cell.fileSizeLabel.text = [NSString stringWithFormat:@"%.2f%@",
                                 [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long)model.fileSize],
                                 [DocumentUploadFileModel calculateUnit:(unsigned long long)model.fileSize]];
        cell.transportDestinationLabel.text = [NSString stringWithFormat:@"上传至:%@",model.place];
        NSString *imageURL = [NSString replaceString:model.fileRatioThumWebUrl Withstr1:@"100" str2:@"100" str3:@"c"];
        [cell.markImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"other"]];

        return cell;
    }

    
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

//每个section头部标题高度（实现这个代理方法后前面 sectionHeaderHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (!_documentUploadFileModel || _documentUploadFileModel.isUploadFinish) {
            return 0;
        }
        else {
            return 44;
            
        }
    } else {
        
        if (self.uploadedArray.count == 0) {
            return 0;
        }
        else {
            return 44;
            
        }
    }

}

//每个section头部的标题－Header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"进行中";
    }else {
        return @"已完成";
    }
}

//区头的字体颜色设置
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    header.contentView.backgroundColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
}

//左滑按钮的实现
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (indexPath.section == 0) {
            [TransportDropMethod deleteFile:self.documentUploadFileModel];
            _documentUploadFileModel = nil;
            
        } else {
            
            DocumentUploadFileModel *model = self.uploadedArray[indexPath.row];
            [self.uploadedArray removeObject:model];
            [TransportDropMethod deleteFile:model];

        }
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView reloadData];
    }];
    
    return @[deleteRowAction];
}

//当已经点击cell时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
