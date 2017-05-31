//
//  PictureCollectionViewCell.h
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block) (UIImage *image,NSString *pictureID);
typedef void(^Cblock) (NSInteger index);

@interface ImageCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)NSString *pictureID;

@property(nonatomic,strong)UIButton *deleteButton;//删除按钮

@property(nonatomic,copy)Block deleteBlock;

@property(nonatomic,assign)BOOL deleteButtonHidden;//是否隐藏删除按钮

@property(nonatomic,assign)BOOL isCompany;//是否是从企业信息那边跳过来的

@property(nonatomic,assign)NSInteger index;//cell在第几个

@property(nonatomic,copy)Cblock deleteCompanyBlock;
@end
