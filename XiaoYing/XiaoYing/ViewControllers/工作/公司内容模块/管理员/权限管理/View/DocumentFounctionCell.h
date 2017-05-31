//
//  DocumentFounctionCell.h
//  XiaoYing
//
//  Created by GZH on 2017/1/6.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModuleModel;



@interface DocumentFounctionCell : UITableViewCell
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIButton *imageMark;

- (void)getModel:(ModuleModel *)model
 andSelectedMark:(NSString *)str;



@end

