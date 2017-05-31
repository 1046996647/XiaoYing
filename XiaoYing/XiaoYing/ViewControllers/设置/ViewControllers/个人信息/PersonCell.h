//
//  PersonCell.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/15.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CellFontType)
{
    CellFontTypeFirst = 1,//注意初始值不要为0
    CellFontTypeSec = 2
};

@interface PersonCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *dataLab;
@property (nonatomic,strong) UIView *sepView; //自定义分割线


@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,assign) CellFontType cellFontType;

@end
