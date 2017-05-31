//
//  TransportingCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "TransportingCell.h"
#import "XYExtend.h"
#import "DocumentUploadFileModel.h"
#import "TransportDropMethod.h"
#import "NSObject+CalculateUnit.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface TransportingCell()



@end

@implementation TransportingCell

- (void)setDocumentUploadFileModel:(DocumentUploadFileModel *)documentUploadFileModel
{
    _documentUploadFileModel = documentUploadFileModel;
    
    //文件缩略图
    
    
    //文件名称
    self.fileNameLabel.text = _documentUploadFileModel.fileName;
    
    //               文件上传进度
    // 已上传大小
    NSString *fileCompleteUploadNum = [NSString stringWithFormat:@"%.2f%@",
                                       [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long)_documentUploadFileModel.fileCompleteUploadNum],
                                       [DocumentUploadFileModel calculateUnit:(unsigned long long)_documentUploadFileModel.fileCompleteUploadNum]];
    
    // 总文件大小
    NSString *fileSize = [NSString stringWithFormat:@"%.2f%@",
                          [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long)_documentUploadFileModel.fileSize],
                          [DocumentUploadFileModel calculateUnit:(unsigned long long)_documentUploadFileModel.fileSize]];
    
    self.transportProgressLabel.text = [NSString stringWithFormat:@"%@/%@", fileCompleteUploadNum, fileSize];
    
    NSString *imageURL = [NSString replaceString:_documentUploadFileModel.fileRatioThumWebUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [self.markImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"other"]];
    
//    //文件上传速度
//    self.transportStateLabel.text = [NSString stringWithFormat:@"%ldKB/S", (long)_documentUploadFileModel.fileUploadSpeed];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView
{
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.fileNameLabel];
    [self.contentView addSubview:self.transportProgressLabel];
    [self.contentView addSubview:self.transportStateLabel];
    [self.contentView addSubview:self.extandBtn];
    
    //___
    self.markImageView.frame = CGRectMake(12, 10, 35, 30);
    self.markImageView.image = [UIImage imageNamed:@"other"];
    
    //___
    NSString *fileNameStr = @"文件名.MOV";
    
    CGFloat fileNameLabelX = self.markImageView.left + self.markImageView.width +10;
    CGFloat fileNameLabelY = 10;
    CGFloat fileNameLabelW = kScreen_Width - fileNameLabelX - 110;
    CGFloat fileNameLabelH = [HSMathod getHightForText:fileNameStr limitWidth:fileNameLabelW fontSize:16];
    
    self.fileNameLabel.frame = CGRectMake(fileNameLabelX, fileNameLabelY, fileNameLabelW, fileNameLabelH);
    self.fileNameLabel.numberOfLines = 0;
    self.fileNameLabel.text = fileNameStr;
    
    //___
    self.transportProgressLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom, fileNameLabelW, 20);
    self.transportProgressLabel.font = [UIFont systemFontOfSize:12];
    self.transportProgressLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.transportProgressLabel.text = @"50KB/2000KB";
    
    //___
    CGFloat fileSizeLabelX = self.fileNameLabel.left + self.fileNameLabel.width + 10;
    self.transportStateLabel.frame = CGRectMake(fileSizeLabelX, 20, 60, 15);
    self.transportStateLabel.text = @"100KB/s";
    self.transportStateLabel.textAlignment = NSTextAlignmentRight;
    self.transportStateLabel.font = [UIFont systemFontOfSize:12];
    self.transportStateLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    
    //___
    self.extandBtn.frame = CGRectMake(kScreen_Width-22-12, 14, 22, 22);
    [self.extandBtn setImage:[UIImage imageNamed:@"zanting_black"] forState:UIControlStateNormal];
    [self.extandBtn setImage:[UIImage imageNamed:@"jixu_black"] forState:UIControlStateSelected];
    [self.extandBtn addTarget:self action:@selector(extandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    [self.extandBtn setSelected:(documentUploadFileModel.uploadPause)];
    
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

- (UILabel *)transportProgressLabel
{
    if (!_transportProgressLabel) {
        _transportProgressLabel = [[UILabel alloc] init];
    }
    return _transportProgressLabel;
}

- (UILabel *)transportStateLabel
{
    if (!_transportStateLabel) {
        _transportStateLabel = [[UILabel alloc] init];
    }
    return _transportStateLabel;
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
    if (btn.selected == NO) { //暂停
        
        [btn setSelected:YES];
        
        //1.解档
        DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
        
        //2.修改
        documentUploadFileModel.uploadPause = YES;
        
        //3.归档
        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
        
    }else {//上传
        
        [btn setSelected:NO];
        
        //1.解档
        DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
        
        //2.修改
        documentUploadFileModel.uploadPause = NO;
        
        //3.归档
        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
        //4.开始／恢复下载
        [TransportDropMethod uploadDataWithProgressControl];

    }
    
}

@end
