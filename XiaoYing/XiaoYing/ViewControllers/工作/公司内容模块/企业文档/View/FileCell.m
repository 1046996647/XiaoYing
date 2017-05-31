//
//  FileManangeCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileCell.h"
#import "CreateFolderController.h"
#import "ZFDownloadManager.h"
#import "WLRemindView.h"
#import "DeleteViewController.h"
#import "DownloadRemindVC.h"
#import "WangUrlHelp.h"

@implementation FileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)initSubViews
{
    _fileControl = [[ItemControl alloc] initWithFrame:CGRectMake(15, 10, 35, 30)];
    [self.contentView addSubview:_fileControl];
    
    _fileLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _fileLab.font = [UIFont systemFontOfSize:14];
    _fileLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _fileLab.numberOfLines = 0;
    _fileLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_fileLab];
    
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_timeLab];
    
    _fileSizeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-45-100, 15, 100, 20)];
    _fileSizeLab.font = [UIFont systemFontOfSize:12];
    _fileSizeLab.textAlignment = NSTextAlignmentRight;
    _fileSizeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_fileSizeLab];
    
    _editControl = [[ItemControl alloc] initWithFrame:CGRectMake(kScreen_Width-45, 0, 45, 50)];
    [_editControl setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [_editControl setImage:[UIImage imageNamed:@"cancel_download"] forState:UIControlStateSelected];

    [_editControl addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editControl];
    
//    _selectedControl = [[ItemControl alloc] initWithFrame:CGRectZero];
//    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
////    _selectedControl.hidden = YES;
//    //    _editControl.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:_selectedControl];
    
    _markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _markBtn.frame = CGRectMake(42, 30, 12, 12);
    [_markBtn setImage:[UIImage imageNamed:@"downloading"] forState:UIControlStateNormal];
    [_markBtn setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateSelected];
    _markBtn.hidden = YES;
    [self.contentView addSubview:_markBtn];
    
}

-(void)setModel:(DocModel *)model{
    _model = model;
    
    [self initSubViews];
    [self setImageViewWithFileName:model.name];
    NSString *str = model.name;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (textSize.height > 76) {
        // 文件名
        _fileLab.frame = CGRectMake(_fileControl.right + 12, 0, 150, 76);
        // 时间
        _timeLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom-4-5, 150, 16);
    }
    else {
        // 文件名
        _fileLab.frame = CGRectMake(_fileControl.right + 12, 8, 150, textSize.height);
        // 时间
        _timeLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom, 150, 16);
    }
    _fileLab.text = model.name;
    _timeLab.text = model.creatTime;

    if (model.type ==0) {//如果是文件夹的话
        _timeLab.hidden = YES;
        _fileSizeLab.hidden = YES;
        _fileLab.top = 16;
        [_fileControl setImage:[UIImage imageNamed:@"folder"] forState:UIControlStateNormal];
        _editControl.hidden = YES;
        _markBtn.hidden = YES;
    }else{
        _timeLab.hidden = NO;
        _fileSizeLab.hidden = NO;
        _editControl.hidden = NO;
        _markBtn.hidden = NO;

        _fileSizeLab.text = [self getSizeStringWithStr:model.size];
        self.fileUrl = DOWNLOADDOC,model.url,model.name];
        NSLog(@"fileUrl:%@",self.fileUrl);
        if ([[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:self.fileUrl withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
        
            }]) {
        
                _editControl.selected = YES;
                _markBtn.hidden = NO;
        
            }
        else {
            _editControl.selected = NO;
        //        _markBtn.hidden = YES;
                if ([[ZFDownloadManager sharedInstance] isCompletion:self.fileUrl]) {
                    _markBtn.hidden = NO;
                    _markBtn.selected = YES;
        
                }
                else {
        
        //            _markBtn.selected = NO;
                    _markBtn.hidden = YES;
                    
                }
        
            }

    }
    
    
}

-(NSString *)getSizeStringWithStr:(NSInteger)size{
    NSNumber *sizeNumber = [NSNumber numberWithInteger:size];
    float sizeFloat = sizeNumber.floatValue / 1024;
    if (sizeFloat > 1) {
        return [NSString stringWithFormat:@"%.1fMB",sizeFloat];
    }else{
        return [NSString stringWithFormat:@"%.1fKB",sizeNumber.floatValue];
    }
}

- (void)edit_action:(ItemControl *)itemControl
{

    
    self.model.isSelected = !self.model.isSelected;
    
    // 正在下载
    if ([[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:self.fileUrl withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
        
    }]) {
        
        DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
//        deleteViewController.urlStr = self.model.fileURL;
        
        deleteViewController.fileDeleteBlock = ^(void)
        {
            // 根据url删除该条数据
            [[ZFDownloadManager sharedInstance] deleteFile:self.fileUrl];
            
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
        };
        
        deleteViewController.titleStr = @"文件正在下载，是否确定取消下载?";
        deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self.viewController presentViewController:deleteViewController animated:YES completion:nil];
        

    }
    else {
        
        NSMutableArray *downloading = [ZFDownloadManager sharedInstance].downloadingArray;
        
        // 只支持单个文件下载判断((实际上支持多文件下载的)
        if (downloading.count > 0) {
            
            
            DownloadRemindVC *downloadRemindVC = [[DownloadRemindVC alloc] init];
            downloadRemindVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            //淡出淡入
            downloadRemindVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //            self.definesPresentationContext = YES; //不盖住整个屏幕
            downloadRemindVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            downloadRemindVC.isSingle = YES;
            [self.viewController presentViewController:downloadRemindVC animated:YES completion:nil];
            
            return;
        }
        
        if ([[ZFDownloadManager sharedInstance] isCompletion:self.fileUrl]) {
            
            DownloadRemindVC *downloadRemindVC = [[DownloadRemindVC alloc] init];
            downloadRemindVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            //淡出淡入
            downloadRemindVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //            self.definesPresentationContext = YES; //不盖住整个屏幕
            downloadRemindVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            downloadRemindVC.isSingle = NO;
            downloadRemindVC.sureBlock = ^(void){
                
                _markBtn.hidden = NO;
                // 根据url删除该条数据
                [[ZFDownloadManager sharedInstance] deleteFile:self.fileUrl];
                NSMutableArray *downladed = [ZFDownloadManager sharedInstance].downloadedArray;
                NSMutableArray *downloaded2 = [NSMutableArray arrayWithArray:downladed];
                for (ZFSessionModel *model in downloaded2) {
                    NSInteger count = 0;
                    for (ZFSessionModel *subModel in [ZFDownloadManager sharedInstance].sessionModelsArray) {
                        if ([subModel.fileName isEqualToString:model.fileName]) {
                            count ++;
                        }
                    }
                    if (count == 0) {
                        [downladed removeObject:model];
                    }
                }
                [WLRemindView showIcon:@"clickon_download"];
                
                [[ZFDownloadManager sharedInstance] download:self.fileUrl type:1 thumbnailUrl:nil progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                    
                } state:^(DownloadState state) {}];
                
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
            };
            [self.viewController presentViewController:downloadRemindVC animated:YES completion:nil];
            
            return;
        }
        
        [WLRemindView showIcon:@"clickon_download"];
        
        [[ZFDownloadManager sharedInstance] download:self.fileUrl type:1 thumbnailUrl:nil  progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
            
        } state:^(DownloadState state) {}];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDownloadNotification" object:nil];
        

    }

    
}

-(void)setImageViewWithFileName:(NSString *)fileName{
    if ([fileName hasSuffix:@".JPG"]||[fileName hasSuffix:@".PNG"]||[fileName hasSuffix:@".png"]||[fileName hasSuffix:@".jpg"]) {
        [_fileControl setImage:[UIImage imageNamed:@"picture_document"] forState:UIControlStateNormal];
    }
    if ([fileName hasSuffix:@".MOV"]||[fileName hasSuffix:@".MP4"]) {
        [_fileControl setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    }
}

//- (void)selected_action:(ItemControl *)itemControl
//{
//    self.model.isSelected = !self.model.isSelected;
//    
//    if ([self.delegate respondsToSelector:@selector(refreshTableView)]) {
//        [self.delegate refreshTableView];
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMulDownloadNotification" object:nil];
//}


@end
