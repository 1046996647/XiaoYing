//
//  FileTypeCollectionViewCell.h
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTypeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *imgBtn;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UILabel *countLab;
@property(nonatomic,strong)NSArray *modelArray;
@end
