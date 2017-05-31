//
//  ManageCollectionViewCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/14.
//  Copyright © 2016年 ZWL. All rights reserved.


//  Created by ShanWen on 16/7/15.
//  Copyright © 2016年 ShanWen All rights reserved.
//封装了一个cell设置方法

#import "ManageCollectionViewCell.h"
@interface ManageCollectionViewCell()

@property (nonatomic,strong) UILabel *titleLab;


@end

@implementation ManageCollectionViewCell

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建imageView的大小
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 84)/2, (self.frame.size.height - 125)/2, 84, 125)];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;

}

-(void)cellImageName:(NSString *)imageName
  andBackgroundColor:(NSString *)colorWithHexString{
    
    self.imageView.image = [UIImage imageNamed:imageName];
    self.backgroundColor = [UIColor colorWithHexString:colorWithHexString];
 
}


@end
