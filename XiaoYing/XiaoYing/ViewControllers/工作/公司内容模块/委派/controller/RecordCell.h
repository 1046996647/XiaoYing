//
//  RecordCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface RecordCell : UITableViewCell

@property(nonatomic,strong)UICollectionView *pictureCollectonView;
@property (nonatomic,strong) RecordModel *model;

@end
