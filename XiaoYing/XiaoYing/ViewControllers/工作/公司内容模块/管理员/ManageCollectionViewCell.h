//
//  ManageCollectionViewCell.h
//  XiaoYing
//
//  Created by ZWL on 16/1/14.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageCollectionViewCell : UICollectionViewCell


@property (nonatomic,strong) UIImageView *imageView;

-(void)cellImageName:(NSString *)imageName
  andBackgroundColor:(NSString *)colorString;
@end
