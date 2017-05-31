//
//  XYPositionRenameCell.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/10.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYPositionRenameCell.h"
#import "XYCategoryModel.h"
#import "XYPositionSetNewNameVc.h"
@class XYPositionViewController;

@interface XYPositionRenameCell()

@end


@implementation XYPositionRenameCell
{
    UILabel *_categoryNameLabel;
    UIButton *_editButton;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupCell];
    }
    return self;
}

-(void)setupCell{
    
    //_categoryNameLabel
    _categoryNameLabel = [[UILabel alloc]init];
    _categoryNameLabel.font = [UIFont systemFontOfSize:16];
    _categoryNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_categoryNameLabel];
    
    //selectButton
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setImage:[UIImage imageNamed:@"edit-grey"] forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(renameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editButton];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_categoryNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    //选中button
    _editButton.frame = CGRectMake(kScreen_Width -40, 0, 40, 40);
}


- (void)setCategoryModel:(XYCategoryModel *)categoryModel
{
    _categoryModel = categoryModel;
    _categoryNameLabel.text = _categoryModel.categoryName;
}


#pragma mark SEL
//Button点击方法
-(void)renameAction{
    
    //弹出添加类别窗口
    XYPositionSetNewNameVc * renameviewController = [[XYPositionSetNewNameVc alloc]init];
    renameviewController.categoryModel = self.categoryModel;
    renameviewController.delegate = self.viewController;
    
    renameviewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    renameviewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    renameviewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.viewController presentViewController:renameviewController animated:YES completion:nil];
    
    
}

@end
