//
//  DownLoadingCell.m
//  XiaoYing
//
//  Created by GZH on 2017/1/20.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DownLoadingCell1.h"
#import "XYExtend.h"
#import "ZFSessionModel.h"
#import "ZFDownloadManager.h"

@interface DownLoadingCell1 ()

@property (nonatomic, strong)ZFSessionModel *sessionModel;

@end


@implementation DownLoadingCell1


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
    [self.extandBtn setImage:[UIImage imageNamed:@"jixu_black"] forState:UIControlStateNormal];
    [self.extandBtn setImage:[UIImage imageNamed:@"zanting_black"] forState:UIControlStateSelected];
    [self.extandBtn addTarget:self action:@selector(extandBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)getModel:(ZFSessionModel *)model {
    
    _sessionModel = model;
    
    NSString *imageURL = [NSString replaceString:model.thumbnailUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [self.markImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"other"]];
    
    self.fileNameLabel.text = model.fileName;
    
//    NSUInteger receivedSize = ZFDownloadLength(model.url);
//    NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
//                             [model calculateFileSizeInUnit:(unsigned long long)receivedSize],
//                             [model calculateUnit:(unsigned long long)receivedSize]];
//    self.transportProgressLabel.text = [NSString stringWithFormat:@"%@/%@",writtenSize,model.totalSize];

    
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
    if (btn.selected == NO) { //继续
        
        [[ZFDownloadManager sharedInstance] start:_sessionModel.url];

        [btn setSelected:YES];
        
    }else {//暂停
        
        [[ZFDownloadManager sharedInstance] pause:_sessionModel.url];

      
        [btn setSelected:NO];
    }
}
  




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
