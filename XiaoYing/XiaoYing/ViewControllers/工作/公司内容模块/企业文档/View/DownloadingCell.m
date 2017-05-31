//
//  FileManangeCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DownloadingCell.h"
#import "DownloadManagerController.h"
#import "DeleteViewController.h"

@implementation DownloadingCell

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
    _fileControl = [[ItemControl alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_fileControl];
    
    _fileLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _fileLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _fileLab.font = [UIFont systemFontOfSize:16];
    _fileLab.numberOfLines = 3;
    _fileLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_fileLab];
    
    
    _receivedDataLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _receivedDataLab.font = [UIFont systemFontOfSize:12];
    _receivedDataLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_receivedDataLab];
    
    _speedLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _speedLab.font = [UIFont systemFontOfSize:12];
    _speedLab.textAlignment = NSTextAlignmentRight;
    _speedLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_speedLab];
    
    _editControl = [[ItemControl alloc] initWithFrame:CGRectZero];
    //    _editControl.indexPath = self
    [_editControl setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [_editControl setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [_editControl addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_editControl];


    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [self.contentView addSubview:_line];
    
   _backView = [[UIView alloc] initWithFrame:CGRectZero];
    _backView.backgroundColor = [UIColor colorWithHexString:@"ecf0f6"];
    [self.contentView addSubview:_backView];
    
    _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadBtn addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [_downloadBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _downloadBtn.selected = YES;
    [_backView addSubview:_downloadBtn];

    
    _downloadLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _downloadLab.font = [UIFont systemFontOfSize:10];
    _downloadLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _downloadLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_downloadLab];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
    [_backView addSubview:_deleteBtn];
    
    
    _deleteLab = [[UILabel alloc] initWithFrame:CGRectZero];
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
- (void)setSessionModel:(ZFSessionModel *)sessionModel
{
    
    _sessionModel = sessionModel;

    // 头像
    _fileControl.frame = CGRectMake(15, 10, 35, 30);
    
    
    //计算字符串高度
    NSString *str = self.sessionModel.fileName;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (textSize.height > 76) {
        // 文件名
        _fileLab.frame = CGRectMake(_fileControl.right + 12, 0, 150, 76);
        // 时间
        self.receivedDataLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom-4, 150, 16);
    }
    else {
        // 文件名
        _fileLab.frame = CGRectMake(_fileControl.right + 12, 8, 150, textSize.height);
        // 时间
        self.receivedDataLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom, 150, 16);
    }
    
    //    _fileLab.backgroundColor = [UIColor cyanColor];
    self.fileLab.text = self.sessionModel.fileName;

    [self setImageViewWithFileName:self.sessionModel.fileName];
    
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *startTimeStr = [dateFormatter stringFromDate:self.sessionModel.startTime];
//    self.timeLab.text = startTimeStr;
//    
    // 文件总长度
    self.speedLab.frame = CGRectMake(kScreen_Width-100-40, (50-12)/2, 100, 12);
    
    _editControl.frame = CGRectMake(kScreen_Width-40, 0, 40, 50);
    
    _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, 50);
    
    _line.frame = CGRectMake(0, self.receivedDataLab.bottom+6-.5, kScreen_Width, .5);
    
    _backView.frame = CGRectMake(0, self.receivedDataLab.bottom+6, kScreen_Width, 50);
    
    _downloadBtn.frame = CGRectMake(150/2, 9, 30, 20);
    
    _downloadLab.frame = CGRectMake(_downloadBtn.left, _downloadBtn.bottom+3, 30, 10);
    
    _deleteBtn.frame = CGRectMake(kScreen_Width-150/2-20, 9, 20, 20);
    
    _deleteLab.frame = CGRectMake(_deleteBtn.left - 4, _deleteBtn.bottom+3, 30, 10);

    
    NSUInteger receivedSize = ZFDownloadLength(sessionModel.url);
//    NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
//                             [ZFSessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
//                             [ZFSessionModel calculateUnit:(unsigned long long)receivedSize]];
//    self.receivedDataLab.text = [NSString stringWithFormat:@"%@/%@",writtenSize,sessionModel.totalSize];
//    self.speedLab.text      = sessionModel.speedStr;
    self.downloadBtn.selected = YES;
    self.downloadLab.text = @"暂停";
    
    if (self.sessionModel.isExpand) {
        
        _editControl.selected = YES;
    }
    else {
        _editControl.selected = NO;
    }
    
}


- (void)edit_action:(ItemControl *)itemControl
{

    self.sessionModel.isExpand = !self.sessionModel.isExpand;

    DownloadManagerController *vc = (DownloadManagerController *)self.viewController;
    [vc refreshTableview];
}

/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (void)clickDownload:(UIButton *)sender {

    if (self.downloadBlock) {
        self.downloadBlock(sender);
    }

}



// 删除
- (void)deleteAction
{
    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
//    deleteViewController.urlStr = self.sessionModel.url;
    
    deleteViewController.fileDeleteBlock = ^(void)
    {
        DownloadManagerController *vc = (DownloadManagerController *)self.viewController;
        [vc deleteFile:self.sessionModel];
    };
    
    deleteViewController.titleStr = @"是否确定删除?";
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:deleteViewController animated:YES completion:nil];

    

}

//根据文件名来设置图像
-(void)setImageViewWithFileName:(NSString*)fileName{
    if ([fileName hasSuffix:@".JPG"]||[fileName hasSuffix:@".PNG"]) {
        [_fileControl setImage:[UIImage imageNamed:@"picture_document"] forState:UIControlStateNormal];
    }
    if ([fileName hasSuffix:@".MOV"]||[fileName hasSuffix:@".MP4"]) {
        [_fileControl setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    }

}
@end
