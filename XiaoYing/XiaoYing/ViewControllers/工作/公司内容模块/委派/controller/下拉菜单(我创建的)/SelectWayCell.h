//
//  SelectWayCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectWayCell : UITableViewCell
{
    UILabel *_nameLab;
}
@property (nonatomic,strong) UIButton *selectedControl;
@property (nonatomic,strong) NSString *way;

@end
