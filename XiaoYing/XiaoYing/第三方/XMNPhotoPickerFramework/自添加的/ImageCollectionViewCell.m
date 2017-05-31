//
//  PictureCollectionViewCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    //self.contentView.backgroundColor = [UIColor greenColor];
    
    
    //设置删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_type"] forState:normal];
    
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    self.contentView.userInteractionEnabled = YES;
    self.imageView.clipsToBounds = YES;
    self.contentView.clipsToBounds = NO;
    [self.contentView addSubview:self.deleteButton];
    
    if (self.deleteButtonHidden == YES) {
        self.deleteButton.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //如果是从企业信息界面跳过来的
    if (self.isCompany == YES) {
        self.imageView.frame = CGRectMake(4, 4, self.frame.size.width - 8, self.frame.size.height - 8);
        
        self.deleteButton.frame = CGRectMake(self.imageView.right - 8, 0, 16, 16);
    }else{
        self.imageView.frame = CGRectMake(4, 4, self.frame.size.width - 8, self.frame.size.width - 8);
        
        self.deleteButton.frame = CGRectMake(self.imageView.right - 10, 0, 16, 16);
    }
}

//按下删除按钮之后
-(void)deleteAction{
    if (self.isCompany == YES) {
        self.deleteCompanyBlock(self.index);
    }else{
        self.deleteBlock(self.imageView.image,self.pictureID);
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
