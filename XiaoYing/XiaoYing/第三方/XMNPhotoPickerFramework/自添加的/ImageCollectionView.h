//
//  ImageCollectionView.h
//  XiaoYing
//
//  Created by ZWL on 16/5/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalTaskModel.h"

/*
 注意：使用这个类型时，当图片的数目发生变化，如果需要改变父视图的界面布局需要观察两个通知，这两个通知分别是（没有参数）：
     imageCountNotificationAction //当添加了图片之后
     imageCountChangedNotificationAction //当点击了删除按钮致使图片数目发生变化以后
 */

@interface ImageCollectionView : UICollectionView

//@property(nonatomic,strong)UICollectionView *pictureCollectonView;
@property(nonatomic,strong)NSMutableArray *itemsSectionPictureArray;//图片数组
@property (nonatomic,strong)LocalTaskModel *model;
@property(nonatomic,strong)NSMutableArray *itemsPictureIDArray;//图片id数组
@property(nonatomic,assign)BOOL deleteButtonHidden;//是否隐藏删除按钮

@property(nonatomic,assign)BOOL isCompany;//是否是从企业信息那边跳过来的
@property(nonatomic,strong)NSArray *imageUrlArray;//图片的url数组
@property(nonatomic,strong)NSArray *imageIDArray;//图片的ID数组，从企业那边跳过来
@property(nonatomic,assign)BOOL isEditing;//是否是编辑状态

@property(nonatomic,assign)NSInteger uploadCount;//是否是第一次
@property(nonatomic,assign)NSInteger count;//次数
@end
