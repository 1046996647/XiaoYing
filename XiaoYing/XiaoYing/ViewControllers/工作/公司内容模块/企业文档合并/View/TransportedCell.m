//
//  TransportedCell.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "TransportedCell.h"
#import "XYExtend.h"
#import "ZFSessionModel.h"

@interface TransportedCell()

@end

@implementation TransportedCell

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
    [self.contentView addSubview:self.transportDestinationLabel];
    [self.contentView addSubview:self.fileSizeLabel];
    
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
    self.transportDestinationLabel.frame = CGRectMake(self.fileNameLabel.left, self.fileNameLabel.bottom, fileNameLabelW, 20);
    self.transportDestinationLabel.font = [UIFont systemFontOfSize:12];
    self.transportDestinationLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.transportDestinationLabel.text = @"下载至:本地";
    
    //___
//    CGFloat fileSizeLabelX = self.fileNameLabel.left + self.fileNameLabel.width + 10;
    self.fileSizeLabel.frame = CGRectMake(kScreen_Width-12-120, 0, 120, self.height);
    self.fileSizeLabel.text = @"1000KB";
    self.fileSizeLabel.font = [UIFont systemFontOfSize:12];
    self.fileSizeLabel.textAlignment = NSTextAlignmentRight;
    self.fileSizeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    
}

- (void)getModel:(ZFSessionModel *)model {
    
    NSString *imageURL = [NSString replaceString:model.thumbnailUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [self.markImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"other"]];

    self.fileNameLabel.text = model.fileName;
    self.fileSizeLabel.text = model.totalSize;
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

- (UILabel *)transportDestinationLabel
{
    if (!_transportDestinationLabel) {
        _transportDestinationLabel = [[UILabel alloc] init];
    }
    return _transportDestinationLabel;
}

- (UILabel *)fileSizeLabel
{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] init];
    }
    return _fileSizeLabel;
}

@end
