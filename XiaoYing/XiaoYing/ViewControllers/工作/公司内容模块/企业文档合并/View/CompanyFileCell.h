//
//  CompanyFileCell.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DocumentMergeModel;

@interface CompanyFileCell : UITableViewCell

@property (nonatomic, strong) DocumentMergeModel *DocumentModel;
@property (nonatomic, strong) UIButton *extandBtn; //扩展按钮
@property (nonatomic, assign) NSInteger type; 

@end
