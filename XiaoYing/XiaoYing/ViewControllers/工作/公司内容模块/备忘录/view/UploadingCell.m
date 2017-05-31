//
//  UploadingCell.m
//  XiaoYing
//
//  Created by ZWL on 16/8/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "UploadingCell.h"
#import "WLUploadManagerVC.h"
#import "DeleteViewController.h"

@implementation UploadingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clipsToBounds = YES;
        
        //初始化子视图
        [self initSubViews];
        
        //        self.deleteArr = [NSMutableArray array];
    }
    return self;
}

- (void)initSubViews
{
    _fileControl = [[ItemControl alloc] initWithFrame:CGRectMake(12, 10, 35, 30)];
    _fileControl.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:_fileControl];
    
    _fileLab = [[UILabel alloc] initWithFrame:CGRectMake(_fileControl.right+12, 11, 200, 14)];
    _fileLab.font = [UIFont systemFontOfSize:16];
    _fileLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_fileLab];
    
    
    _receivedDataLab = [[UILabel alloc] initWithFrame:CGRectMake(_fileLab.left, _fileLab.bottom, 150, 16)];
    _receivedDataLab.font = [UIFont systemFontOfSize:12];
    _receivedDataLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_receivedDataLab];
    
    _speedLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-45-100, (50-20)/2, 100, 20)];
    _speedLab.font = [UIFont systemFontOfSize:12];
    _speedLab.textAlignment = NSTextAlignmentRight;
    _speedLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_speedLab];
    
    _editControl = [[ItemControl alloc] initWithFrame:CGRectMake(_speedLab.right+12, 15, 20, 20)];
    //    _editControl.indexPath = self
    [_editControl setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [_editControl setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [_editControl addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_editControl];
    
    
    
    //    _selectedControl = [[ItemControl alloc] initWithFrame:CGRectZero];
    //    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
    //    //    _selectedControl.hidden = YES;
    //    //    _editControl.backgroundColor = [UIColor redColor];
    //    [self.contentView addSubview:_selectedControl];
    
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreen_Width, 50)];
    _backView.backgroundColor = [UIColor colorWithHexString:@"ecf0f6"];
    [self.contentView addSubview:_backView];
    
    _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadBtn.frame = CGRectMake(150/2, 9, 20, 20);
    [_downloadBtn addTarget:self action:@selector(clickUpload:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [_downloadBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _downloadBtn.selected = YES;
    [_backView addSubview:_downloadBtn];
    
    
    _downloadLab = [[UILabel alloc] initWithFrame:CGRectMake(_downloadBtn.left, _downloadBtn.bottom+3, 20, 10)];
    _downloadLab.font = [UIFont systemFontOfSize:10];
    _downloadLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _downloadLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_downloadLab];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(kScreen_Width-150/2-20, 9, 20, 20);
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
    [_backView addSubview:_deleteBtn];
    
    
    _deleteLab = [[UILabel alloc] initWithFrame:CGRectMake(_deleteBtn.left, _downloadBtn.bottom+3, 20, 10)];
    _deleteLab.font = [UIFont systemFontOfSize:10];
    _deleteLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _deleteLab.text = @"删除";
    _deleteLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_deleteLab];
}

/**
 *  model setter
 *
 *  @param sessionModel sessionModel
 */
- (void)setUploadModel:(WLUploadModel *)uploadModel
{
    _uploadModel = uploadModel;
    self.fileLab.text = uploadModel.fileName;
    NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
                             [uploadModel calculateFileSizeInUnit:(unsigned long long)uploadModel.startLength],
                             [uploadModel calculateUnit:(unsigned long long)uploadModel.startLength]];
    NSString *totalSize = [NSString stringWithFormat:@"%.2f %@",
                             [uploadModel calculateFileSizeInUnit:(unsigned long long)uploadModel.totalSize],
                             [uploadModel calculateUnit:(unsigned long long)uploadModel.totalSize]];
    self.receivedDataLab.text = [NSString stringWithFormat:@"%@/%@",writtenSize,totalSize];
    
    self.speedLab.text      = uploadModel.speedStr;
    self.downloadBtn.selected = YES;
    self.downloadLab.text = @"暂停";
    
    if (self.uploadModel.isExpand) {
        
        _editControl.selected = YES;
    }
    else {
        _editControl.selected = NO;
    }
    
}


- (void)edit_action:(ItemControl *)itemControl
{
    
    self.uploadModel.isExpand = !self.uploadModel.isExpand;
    
    WLUploadManagerVC *vc = (WLUploadManagerVC *)self.viewController;
    [vc refreshTableview];
}

/**
 *  暂停、上传
 *
 *  @param sender UIButton
 */
- (void)clickUpload:(UIButton *)sender {
    
//    if (self.downloadBlock) {
//        self.downloadBlock(sender);
//    }
    
    [[WLUploadManager sharedInstance] pauseOrUpload:self.uploadModel];
    
}



// 删除
- (void)deleteAction
{
    
    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    //    deleteViewController.urlStr = self.sessionModel.url;
    
    deleteViewController.fileDeleteBlock = ^(void)
    {
        WLUploadManagerVC *vc = (WLUploadManagerVC *)self.viewController;
        [vc deleteFile:self.uploadModel];
    };
    
    deleteViewController.titleStr = @"是否确定删除?";
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:deleteViewController animated:YES completion:nil];
    
    
    
}

@end
