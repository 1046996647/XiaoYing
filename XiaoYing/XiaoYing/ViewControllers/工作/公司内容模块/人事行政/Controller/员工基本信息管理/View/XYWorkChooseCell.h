//
//  XYWorkChooseCell.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYWorkChooseCell : UITableViewCell

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * detail;

@property(nonatomic,strong)UIImage * icon;
@property(nonatomic,strong)UIImage * miniIcon;
@property (nonatomic,copy) NSString *identifier;

@property(nonatomic,strong)UIButton * button;

@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,copy)NSString * buttonName;

@property(nonatomic,assign)BOOL isChoose;

@end
