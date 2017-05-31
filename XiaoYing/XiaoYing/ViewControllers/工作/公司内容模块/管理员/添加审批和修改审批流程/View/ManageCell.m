
//
//  ManageCell.m
//  XiaoYing
//
//  Created by ZWL on 16/4/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ManageCell.h"
#import "ApprovePopupVC.h"

@implementation ManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _selectedControl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
        //    _selectedControl.hidden = YES;
        //    _editControl.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_selectedControl];
        
        _editControl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_editControl setImage:[UIImage imageNamed:@"edit-grey"] forState:UIControlStateNormal];
        [_editControl addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
        //    _editControl.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_editControl];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
    
    _editControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);

    
    [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    
    if (self.checkType == CheckTypeDownload) {
        _selectedControl.hidden = YES;
        _editControl.hidden = YES;
        
//        if (self.model.TypesList.count > 0) {
//            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        } else {
//            self.accessoryType = UITableViewCellAccessoryNone;
//
//        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    }
    else if (self.checkType == CheckTypeSelected) {
        _selectedControl.hidden = NO;
        _editControl.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.model.isSelected == YES) {
            [_selectedControl setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        }
        else {
            [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
        }

    } else {
        _selectedControl.hidden = YES;
        _editControl.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
}

- (void)selected_action:(UIButton *)btn
{
    self.model.isSelected = !self.model.isSelected;
    
    if (_deleteBlock) {
        _deleteBlock(self.model);
    }
    
}

- (void)edit_action:(UIButton *)btn
{
    ApprovePopupVC *approvePopupVC = [[ApprovePopupVC alloc] init];
    approvePopupVC.ID = self.model.ID;
    approvePopupVC.currentText = self.textLabel.text;
    approvePopupVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    approvePopupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    approvePopupVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:approvePopupVC animated:YES completion:nil];
}

@end
