//
//  DelegateTasksTableViewCell.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateTasksTableViewCell.h"
#import "ShowAndEditTaskVC.h"

@implementation DelegateTasksTableViewCell
@synthesize backgroundview,stateLabel,numberLabel,titleLabel,tasksDetailsLabel,proportionLabel,time,performPeopleImage,statePrompt;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initialize];
    return self;
}

-(void)initialize
{
    backgroundview = [[UIView alloc]initWithFrame:CGRectMake(12, 3, kScreen_Width - 78, 44)];
    backgroundview.layer.masksToBounds = YES;
    backgroundview.layer.cornerRadius = 5;
    [backgroundview.layer setBorderWidth:0.5];
    [backgroundview.layer setBorderColor:[[UIColor colorWithHexString:@"#d5d7dc"] CGColor]];
    backgroundview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgroundview];
    
    stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    stateLabel.numberOfLines = 0;
    stateLabel.font = [UIFont systemFontOfSize:10];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.textColor = [UIColor whiteColor];
    time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flip) userInfo:nil repeats:YES];
    [backgroundview addSubview:stateLabel];
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 25, 14)];
    numberLabel.font = [UIFont systemFontOfSize:14];
    [backgroundview addSubview:numberLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 8, 120, 14)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [backgroundview addSubview:titleLabel];
    
    tasksDetailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, kScreen_Width - 118, 12)];
    tasksDetailsLabel.font = [UIFont systemFontOfSize:12];
    tasksDetailsLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    [backgroundview addSubview:tasksDetailsLabel];
    
    proportionLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 188, 10, 100, 12)];
    proportionLabel.font = [UIFont systemFontOfSize:12];
    proportionLabel.textAlignment = NSTextAlignmentRight;
    [backgroundview addSubview:proportionLabel];
    
    performPeopleImage = [UIButton buttonWithType:UIButtonTypeCustom];
    performPeopleImage.frame = CGRectMake(kScreen_Width - 56, 3, 44, 44);
    performPeopleImage.layer.masksToBounds = YES;
    performPeopleImage.layer.cornerRadius = 5;
    [performPeopleImage addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:performPeopleImage];
    
    statePrompt = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, 44, 15)];
    statePrompt.textColor = [UIColor whiteColor];
    statePrompt.font = [UIFont systemFontOfSize:10];
    statePrompt.textAlignment = NSTextAlignmentCenter;
    statePrompt.layer.masksToBounds =YES;
    statePrompt.layer.cornerRadius = 5;
    [performPeopleImage addSubview:statePrompt];
    
}

-(void)flip
{
    
}


- (void)editAction:(UIButton *)btn
{
    ShowAndEditTaskVC *showAndEditTaskVC = [[ShowAndEditTaskVC alloc] init];
    [self.viewController.navigationController pushViewController:showAndEditTaskVC animated:YES];
}

@end
