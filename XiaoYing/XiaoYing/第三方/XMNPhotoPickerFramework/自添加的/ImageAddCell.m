//
//  PictureAddCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "ImageAddCell.h"

@implementation ImageAddCell
{
    UIImageView *addImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    addImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:addImageView];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isCompany == YES) {
        addImageView.frame = CGRectMake(4, 4, self.frame.size.width - 8, self.frame.size.height - 8);
        addImageView.image = [UIImage imageNamed:@"add_picmov.png"];
       // NSLog(@"添加图片width:%f,height:%f",addImageView.frame.size.width,addImageView.frame.size.height);
    }else{
        addImageView.frame = CGRectMake(4, 4, self.frame.size.width - 8, self.frame.size.width -8);
        addImageView.image = [UIImage imageNamed:@"add_picmov.png"];
    }
    
    
    
    
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
