//
//  LocalDocumentTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/5.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "LocalDocumentTableView.h"
#import "LocalFileCell.h"
#import "ZFDownloadManager.h"
#import "ImageBrowseVC.h"

@interface LocalDocumentTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LocalDocumentTableView

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

- (void)setDownloadedArray:(NSMutableArray *)downloadedArray {
    _downloadedArray = downloadedArray;
    [self reloadData];
}

#pragma mark - tableViewDataSource,UITableViewDelegate
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _downloadedArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoaclFileCELL"];
    if (!cell) {
        cell = [[LocalFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoaclFileCELL"];
        cell.deleteOrReNameBlock = ^(ZFSessionModel *model, NSString *str) {
            
            if (![str isEqualToString:@"Refersh"]) {
                [self.downloadedArray removeObject:model];
            }
            
            [self reloadData];
        };
    }
    
    cell.type = @"0";
    ZFSessionModel *downloadModel = _downloadedArray[indexPath.row];
    cell.model = downloadModel;

    return cell;
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//当已经点击cell时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZFSessionModel *downloadModel = _downloadedArray[indexPath.row];
    NSString *urlStr = [NSString replaceString:downloadModel.thumbnailUrl Withstr1:@"300" str2:@"300" str3:@"c"];

    ImageBrowseVC *browserVC = [ImageBrowseVC new];
    browserVC.sizeType = @"1";
    browserVC.urlStr = urlStr;
    [self.viewController presentViewController:browserVC animated:YES completion:nil];

}




@end
