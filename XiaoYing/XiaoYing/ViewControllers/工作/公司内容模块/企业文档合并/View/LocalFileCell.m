//
//  LocalFileCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/14.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "LocalFileCell.h"
#import "XYExtend.h"
#import "FileOperateVC.h"
#import "DocumentMergeModel.h"
#import "DocumentVM.h"
#import "DocumentMergeModel.h"
#import "NewViewVC.h"
#import "DeleteViewController.h"
#import "MoveFolderViewController.h"
#import "ZFSessionModel.h"
#import "ZFDownloadManager.h"
@interface LocalFileCell()

@property (nonatomic, strong) UIImageView *markImageView; //标志图标
@property (nonatomic, strong) UILabel *fileNameLabel; //文件名称
@property (nonatomic, strong) UILabel *createTimeLabel; //文件创建时间
@property (nonatomic, strong) UILabel *fileSizeLabel; //文件大小



@end

@implementation LocalFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewRowAnimationNone;
        
        [self setupContentView];
    }
    return self;
}

- (void)setModel:(ZFSessionModel *)model{
    _model = model;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:_model.startTime];
    
    NSString *str = [NSString replaceString:_model.thumbnailUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [self.markImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"other"]];
    self.fileNameLabel.text = _model.fileName;
    self.createTimeLabel.text = strDate;
    self.fileSizeLabel.text = _model.totalSize;
    
    if (model.isSelected == YES) {
        self.extandBtn.selected = YES;
    }else {
        self.extandBtn.selected = NO;
    }
}

- (void)setupContentView
{
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.fileNameLabel];
    [self.contentView addSubview:self.createTimeLabel];
    [self.contentView addSubview:self.fileSizeLabel];
    [self.contentView addSubview:self.extandBtn];
    
    //___
    self.markImageView.frame = CGRectMake(12, 10, 35, 30);
    self.markImageView.image = [UIImage imageNamed:@"other"];
    
    //___
    NSString *fileNameStr = @"文件文件";
    
    CGFloat fileNameLabelX = self.markImageView.left + self.markImageView.width +10;
    CGFloat fileNameLabelY = 10;
    CGFloat fileNameLabelW = kScreen_Width - fileNameLabelX - 80;
    CGFloat fileNameLabelH = [HSMathod getHightForText:fileNameStr limitWidth:fileNameLabelW fontSize:16];
    
    self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, fileNameLabelH);
    self.fileNameLabel.numberOfLines = 0;
    self.fileNameLabel.text = fileNameStr;
    
    //___
    self.createTimeLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom, fileNameLabelW, 20);
    self.createTimeLabel.font = [UIFont systemFontOfSize:12];
    self.createTimeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.createTimeLabel.text = @"2016-01-12 17:25";
    
    //___
    CGFloat fileSizeLabelX = self.fileNameLabel.left + self.fileNameLabel.width + 5;
    self.fileSizeLabel.frame = CGRectMake(fileSizeLabelX, 20, 50, 15);
    self.fileSizeLabel.text = @"100KB";
    self.fileSizeLabel.font = [UIFont systemFontOfSize:12];
    self.fileSizeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    
    //___
    self.extandBtn.frame = CGRectMake(kScreen_Width-14-12, 0, 26, 40);
    self.extandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.extandBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.extandBtn.imageEdgeInsets = UIEdgeInsetsMake(21, 0, 0, 0);
    
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

- (UILabel *)createTimeLabel
{
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] init];
    }
    return _createTimeLabel;
}

- (UILabel *)fileSizeLabel
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

#pragma mark -buttonAction
- (void)extandBtnAction:(UIButton *)btn
{
//    __weak typeof(self) weakSelf = self;
    
    FileOperateVC *vc  = [[FileOperateVC alloc] init];
    vc.fileType = 1;// 0:文件 1：文件夹
    vc.authForButtnArr = @[[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES]];
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
                NSLog(@"重命名");                
                // 重命名
                NewViewVC *newViewVC = [[NewViewVC alloc] init];
                newViewVC.markText = @"重命名";
                newViewVC.placeholderText = @"请输入";
                newViewVC.content = self.model.fileName;
                newViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                newViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                newViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                newViewVC.clickBlock = ^(NSString *str) {
                    [[ZFDownloadManager sharedInstance] renameFile:self.model.url name:str];
                    if (_deleteOrReNameBlock) {
                        _deleteOrReNameBlock(self.model, @"Refersh");
                    }
                };
                [self.viewController presentViewController:newViewVC animated:YES completion:nil];
               

            }
            if (tag == 1) {
                // 删除
                NSLog(@"删除");

                [[ZFDownloadManager sharedInstance] deleteFile:self.model.url];
                if (_deleteOrReNameBlock) {
                    _deleteOrReNameBlock(self.model, nil);
                }

            }
        }
    }];
}




- (void)setType:(NSString *)type {
    _type = type;
    if ([_type isEqualToString:@"1"]) {
        [self.extandBtn setImage:[UIImage imageNamed:@"kong_gray"] forState:UIControlStateNormal];
        [self.extandBtn setImage:[UIImage imageNamed:@"xuanzhong_-orange"] forState:UIControlStateSelected];
        

    }else {
        [self.extandBtn setImage:[UIImage imageNamed:@"jiantou_gray"] forState:UIControlStateNormal];
        [self.extandBtn addTarget:self action:@selector(extandBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
}

@end
