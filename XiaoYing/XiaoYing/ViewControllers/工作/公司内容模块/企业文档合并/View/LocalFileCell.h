//
//  LocalFileCell.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/14.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFSessionModel;
@interface LocalFileCell : UITableViewCell

typedef void(^DeleteOrReNameBlock)(ZFSessionModel *, NSString*);


@property (nonatomic, strong) UIButton *extandBtn; //扩展按钮
@property (nonatomic,strong)ZFSessionModel *model;
@property (nonatomic,strong)NSString *type;

@property (nonatomic, copy) DeleteOrReNameBlock deleteOrReNameBlock;

@end


