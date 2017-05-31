//
//  FileManangeCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DownloadFinishCell.h"
#import "DownloadManagerController.h"
#import "DeleteViewController.h"
#import "RenameVC.h"
#import "ZFDownloadManager.h"


@implementation DownloadFinishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        self.clipsToBounds = YES;
        
        //初始化子视图
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _fileControl = [[ItemControl alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_fileControl];
    
    _fileLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _fileLab.font = [UIFont systemFontOfSize:16];
    _fileLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _fileLab.numberOfLines = 3;
    _fileLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_fileLab];
    
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_timeLab];
    
    _fileSizeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _fileSizeLab.font = [UIFont systemFontOfSize:12];
    _fileSizeLab.textAlignment = NSTextAlignmentRight;
    _fileSizeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_fileSizeLab];
    
    
    _editControl = [[ItemControl alloc] initWithFrame:CGRectZero];
    //    _editControl.indexPath = self
    [_editControl setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [_editControl setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [_editControl addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_editControl];
    
    
    _selectedControl = [[ItemControl alloc] initWithFrame:CGRectZero];
    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedControl setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];

    [self.contentView addSubview:_selectedControl];
    
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [self.contentView addSubview:_line];
    
    _backView = [[UIView alloc] initWithFrame:CGRectZero];
//    _backView.hidden = YES;
    _backView.backgroundColor = [UIColor colorWithHexString:@"ecf0f6"];
    [self.contentView addSubview:_backView];
    
    _renameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_renameBtn addTarget:self action:@selector(renameAction) forControlEvents:UIControlEventTouchUpInside];

    [_renameBtn setImage:[UIImage imageNamed:@"rename"] forState:UIControlStateNormal];
    [_backView addSubview:_renameBtn];
    
    
    _renameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _renameLab.font = [UIFont systemFontOfSize:10];
    _renameLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _renameLab.textAlignment = NSTextAlignmentCenter;
    _renameLab.text = @"重命名";
    [_backView addSubview:_renameLab];
    
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

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isExpandAction) name:@"kIsExpandNotification" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kIsExpandNotification" object:nil];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
   // [_fileControl setImage:[UIImage imageNamed:@"ying"] forState:UIControlStateNormal];
    //    [_fileImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/%@",self.profileModel.FaceUrl]]];
    
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
        _timeLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom-4, 150, 16);
    }
    else {
        // 文件名
        _fileLab.frame = CGRectMake(_fileControl.right + 12, 8, 150, textSize.height);
        // 时间
        _timeLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom, 150, 16);
    }

//    _fileLab.backgroundColor = [UIColor cyanColor];
    self.fileLab.text = self.sessionModel.fileName;

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *startTimeStr = [dateFormatter stringFromDate:self.sessionModel.startTime];
    self.timeLab.text = startTimeStr;
    
    // 文件总长度
    _fileSizeLab.frame = CGRectMake(kScreen_Width-100-40, (50-12)/2, 100, 12);
    self.fileSizeLab.text = self.sessionModel.totalSize;

    _editControl.frame = CGRectMake(kScreen_Width-40, 0, 40, 50);
    
    _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, 50);
    
    _line.frame = CGRectMake(0, self.timeLab.bottom+6-.5, kScreen_Width, .5);
    
    _backView.frame = CGRectMake(0, self.timeLab.bottom+6, kScreen_Width, 50);
    
    _renameBtn.frame = CGRectMake(150/2, 9, 30, 20);
    
    _renameLab.frame = CGRectMake(_renameBtn.left - 5, _renameBtn.bottom+3, 40, 10);
    
    _deleteBtn.frame = CGRectMake(kScreen_Width-150/2-20, 9, 20, 20);
    
    _deleteLab.frame = CGRectMake(_deleteBtn.left - 10, _deleteBtn.bottom+3, 40, 10);
    



    
    if (self.checkType == CheckTypeDownload) {
        _selectedControl.hidden = YES;
        _editControl.hidden = NO;
        
        if (self.sessionModel.isExpand) {
            
            _editControl.selected = YES;
        }
        else {
            _editControl.selected = NO;
        }
    }
    else {
        _selectedControl.hidden = NO;
        _editControl.hidden = YES;
        
        if (self.sessionModel.isSelected == YES) {
            
            _selectedControl.selected = YES;

        }
        else {
            
            _selectedControl.selected = NO;

        }

    }
    
    
}

-(void)setSessionModel:(ZFSessionModel *)sessionModel{
    _sessionModel = sessionModel;
    [self showImageViewWithFileName:sessionModel.fileName andFilePath:ZFFileFullpath(sessionModel.url)];
}

// 重命名
- (void)renameAction
{
    RenameVC *renameVC = [[RenameVC alloc] init];
    //    deleteViewController.urlStr = self.sessionModel.url;
    
    renameVC.fileRenameBlock = ^(NSString *name)
    {
        DownloadManagerController *vc = (DownloadManagerController *)self.viewController;
        [vc renameFile:self.sessionModel.url name:name];
    };
    renameVC.currentText = self.sessionModel.fileName;
    renameVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    renameVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    renameVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:renameVC animated:YES completion:nil];

}

- (void)edit_action:(ItemControl *)itemControl
{
    
//    self.sessionModel.isExpand = !self.sessionModel.isExpand;
    
    if (self.sessionModel.isExpand) {
        self.sessionModel.isExpand = NO;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kIsExpandNotification" object:nil];
        self.sessionModel.isExpand = YES;

    }
    
    DownloadManagerController *vc = (DownloadManagerController *)self.viewController;
    [vc refreshTableview];
}

- (void)selected_action:(ItemControl *)itemControl
{
    self.sessionModel.isSelected = !self.sessionModel.isSelected;
    
    if (_deleteBlock) {
        _deleteBlock(self.sessionModel);
    }
    
//    DownloadManagerController *vc = (DownloadManagerController *)self.viewController;
//    [vc refreshTableview];
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

- (void)isExpandAction
{
    if (self.sessionModel.isExpand) {
        self.sessionModel.isExpand = NO;
    }
}

-(void)showImageViewWithFileName:(NSString*)fileName andFilePath:(NSString*)filePath{
    
    UIImage *image = nil;
    if ([fileName hasSuffix:@".JPG"] || [fileName hasSuffix:@".PNG"]) {
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        image = [UIImage imageWithData:data];
    }
    
    if ([fileName hasSuffix:@".MOV"] || [fileName hasSuffix:@".MP4"]) {
        image = [UIImage imageNamed:@"video"];
    }
    [_fileControl setImage:image forState:UIControlStateNormal];
}

@end
