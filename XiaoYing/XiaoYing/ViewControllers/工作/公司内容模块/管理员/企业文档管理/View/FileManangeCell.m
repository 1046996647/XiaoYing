//
//  FileManangeCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileManangeCell.h"
#import "CreateFolderController.h"

@implementation FileManangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [_editControl setImage:[UIImage imageNamed:@"edit-grey"] forState:UIControlStateNormal];
    [_editControl addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
//    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_editControl];
    
    _selectedControl = [[ItemControl alloc] initWithFrame:CGRectZero];
//    [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
//    _selectedControl.hidden = YES;
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_selectedControl];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _fileControl.frame = CGRectMake(15, 10, 35, 30);
    [_fileControl setImage:[UIImage imageNamed:@"ying"] forState:UIControlStateNormal];
//    [_fileImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/%@",self.profileModel.FaceUrl]]];
    
    _fileLab.frame = CGRectMake(_fileControl.right + 16, 8, 150, 20);
//    _fileLab.text = self.profileModel.Nick;
//    _fileLab.text = self.model.title;
    
    
    _timeLab.frame = CGRectMake(_fileLab.left, _fileLab.bottom, 150, 16);
//    _timeLab.text = self.profileModel.Signature;
    _timeLab.text = self.model.time;
    
    _fileSizeLab.frame = CGRectMake(kScreen_Width-45-100, (50-20)/2, 100, 20);
//    _fileSizeLab.text = self.model.message;
    
    _editControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
    
    _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
    if (self.model.isSelected == YES) {
        [_selectedControl setImage:[UIImage imageNamed:@"file_choose"] forState:UIControlStateNormal];
    }
    else {
        [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    }


    
    
    if (self.markType == MarkTypeEdit) {
        _editControl.hidden = NO;
        _selectedControl.hidden = YES;
    }
    else {
        _editControl.hidden = YES;
        _selectedControl.hidden = NO;
    }
}

- (void)edit_action:(ItemControl *)itemControl
{
    CreateFolderController *fileNewController = [[CreateFolderController alloc] init];
    fileNewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    fileNewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    fileNewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:fileNewController animated:YES completion:nil];
}

- (void)selected_action:(ItemControl *)itemControl
{
    self.model.isSelected = !self.model.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(refreshTableView)]) {
        [self.delegate refreshTableView];
    }
}


@end
