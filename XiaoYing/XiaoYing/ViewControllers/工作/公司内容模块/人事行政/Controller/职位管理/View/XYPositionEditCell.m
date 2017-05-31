//
//  XYPositionEditCell.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYPositionEditCell.h"
#import "XYCategoryModel.h"

@interface XYPositionEditCell()

//类别名称
@property(nonatomic,strong)UILabel * titleLabel;

@end

@implementation XYPositionEditCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupCell];
    }
    
    return self;
}

-(void)setupCell{
    
    //titleLabel
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:self.titleLabel];
    
    //selectButton
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectButton];

    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(12);
        }];
    
    //选中button
    self.selectButton.frame = CGRectMake(kScreen_Width -40, 0, 40, 40);

    
}


-(void)setModel:(XYCategoryModel *)model{
    
    _model = model;
    self.titleLabel.text = model.categoryName;
}


#pragma mark SEL
//Button点击方法
-(void)chooseButton:(UIButton*)button{
    
    if (button.selected == 0) {
        button.selected = 1;
        
        //发送添加请求
        NSDictionary *categoryIdDict = [[NSDictionary alloc]initWithObjectsAndKeys:self.model.categoryId,@"categoryId", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"add" object:nil userInfo:categoryIdDict];
        NSLog(@"categoryIdDict~~%@", categoryIdDict);
    }else{
        button.selected = 0;
        
        //发送移除请求
        NSDictionary *categoryIdDict = [[NSDictionary alloc]initWithObjectsAndKeys:self.model.categoryId,@"categoryId", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"remove" object:nil userInfo:categoryIdDict];
        
    }

  
 
}

@end
