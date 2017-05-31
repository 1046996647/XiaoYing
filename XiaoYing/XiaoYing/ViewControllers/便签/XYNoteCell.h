//
//  XYNoteCell.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYNoteModel;

@interface XYNoteCell : UITableViewCell

@property(nonatomic,copy)NSString * identifier;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * miniTitle;
@property(nonatomic,strong)UIView * iconView;

- (void)setNoteData:(XYNoteModel *)model;
@end
