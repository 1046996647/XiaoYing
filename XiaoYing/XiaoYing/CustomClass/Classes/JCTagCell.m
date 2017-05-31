//
//  JCTagCell.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagCell.h"

@implementation JCTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 1.0f;
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_titleLabel];
        
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.width-20, self.height-20)];
        [circleView.layer setCornerRadius:circleView.height/2];
        circleView.layer.borderColor =[UIColor colorWithHexString:@"#f99740"].CGColor;
        circleView.layer.borderWidth = 1;
        [self.contentView addSubview:circleView];
        self.circleView = circleView;
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(self.width-20, 0, 20, 20);
        [deleteBtn setImage:[UIImage imageNamed:@"delete_person"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;

    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    self.circleView.frame = CGRectMake(10, 10, self.width-20, self.height-20);
    self.deleteBtn.frame = CGRectMake(self.width-20, 0, 20, 20);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

- (void)buttonAction:(UIButton *)btn {
    if (self.selectedBlock) {
        self.selectedBlock(_index);
    }
}

@end
