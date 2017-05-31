//
//  FileNamecell.m
//  XiaoYing
//
//  Created by GZH on 16/7/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileNamecell.h"
#import "VisibleRangeVC.h"
#import "UPloadManagerVC.h"
#import "CompanyFileManageController.h"
#import "DocumentUploadFileModel.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@implementation FileNamecell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        [self.contentView addSubview:self.upLoadBtn];
        [self.contentView addSubview:self.upLoadLabel];
        
        [self.contentView addSubview:self.visibleBtn];
        [self.contentView addSubview:self.visibleLabel];
        
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.deleteLabel];

    }
    return self;
}

//开始、暂停上传_________________________________________
- (UIButton *)upLoadBtn {
    if (_upLoadBtn == nil) {
        _upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _upLoadBtn.frame = CGRectMake(50, 9, 20, 20);
        [_upLoadBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_upLoadBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateSelected];
        [_upLoadBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upLoadBtn;
}

- (UILabel *)upLoadLabel {
    if (_upLoadLabel == nil) {
        _upLoadLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 30, 30, 14)];
        _upLoadLabel.text = (self.upLoadBtn.selected)? @"开始" : @"暂停";
        _upLoadLabel.textAlignment = NSTextAlignmentCenter;
        _upLoadLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _upLoadLabel.font = [UIFont systemFontOfSize:10];
    }
    return _upLoadLabel;
}

//可见范围______________________________________________
- (UIButton *)visibleBtn {
    if (_visibleBtn == nil) {
        _visibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _visibleBtn.frame = CGRectMake(kScreen_Width / 2 - 12.5, 9, 25, 17);
        [_visibleBtn setImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
        [_visibleBtn addTarget:self action:@selector(visibleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visibleBtn;
}

- (UILabel *)visibleLabel {
    if (_visibleLabel == nil) {
        _visibleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width / 2 - 23, 30, 46, 14)];
        _visibleLabel.text = @"可见范围";
        _visibleLabel.textAlignment = NSTextAlignmentCenter;
        _visibleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _visibleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _visibleLabel;
}

//删除_________________________________________________
- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(kScreen_Width - 50 - 19, 9, 19, 20);
        [_deleteBtn setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UILabel *)deleteLabel {
    if (_deleteLabel == nil) {
        _deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(_deleteBtn.frame.origin.x, _deleteBtn.bottom + 1, 30, 14)];
        _deleteLabel.text = @"删除";
        _deleteLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _deleteLabel.font = [UIFont systemFontOfSize:11];
    }
    return _deleteLabel;
}

#pragma mark -actionOfTableViewCell
- (void)uploadAction:(UIButton *)btn
{
    NSLog(@"上传／暂停");
    if (btn.selected == NO) { //正在上传

        [self.upLoadLabel setText:@"开始"];
        [btn setSelected:YES];
        
        //1.解档
        DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
        
        NSLog(@"归档前uploadPause~%d", documentUploadFileModel.uploadPause);
        
        //2.修改
        documentUploadFileModel.uploadPause = YES;
        
        //3.归档
        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
        
        NSLog(@"归档后uploadPause~%d", documentUploadFileModel.uploadPause);
        
    }else {
        
        //1.改变状态值
        UPloadManagerVC *parentVC = (UPloadManagerVC *)self.viewController;
        
        [self.upLoadLabel setText:@"暂停"];
        [btn setSelected:NO];
        
        //1.解档
        DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
        
        NSLog(@"归档前uploadPause~%d", documentUploadFileModel.uploadPause);
        
        //2.修改
        documentUploadFileModel.uploadPause = NO;
        
        //3.归档
        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
        
        NSLog(@"归档后uploadPause~%d", documentUploadFileModel.uploadPause);
        
        //2.开始／恢复下载
        NSArray *viewControllersArray = parentVC.navigationController.childViewControllers;
        for (UIViewController *vc in viewControllersArray) {
            if ([vc isKindOfClass:[CompanyFileManageController class]]) {
                CompanyFileManageController *companyFileManagerVC = (CompanyFileManageController *)vc;
                [companyFileManagerVC beginOrRestoreUpload];
            }
        }
        
    }
}

- (void)deleteAction:(UIButton *)btn
{
    NSLog(@"删除");
}

- (void)visibleAction:(UIButton *)btn
{
    NSLog(@"可见范围");
    VisibleRangeVC *visibleVC = [[VisibleRangeVC alloc]init];
    [self.viewController.navigationController pushViewController:visibleVC animated:YES];
    
}

@end
