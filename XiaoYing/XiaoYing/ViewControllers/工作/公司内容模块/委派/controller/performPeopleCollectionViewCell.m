//
//  performPeopleCollectionViewCell.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "performPeopleCollectionViewCell.h"

@implementation performPeopleCollectionViewCell
@synthesize performPeopleImage,performPeopleName,statePrompt;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    performPeopleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    performPeopleImage.backgroundColor = [UIColor redColor];
    performPeopleImage.layer.masksToBounds =YES;
    performPeopleImage.layer.cornerRadius = 5;
    [self.contentView addSubview:performPeopleImage];
    
    performPeopleName = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, 48, 12)];
    performPeopleName.font = [UIFont systemFontOfSize:12];
    performPeopleName.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:performPeopleName];
    
    statePrompt = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 48, 15)];
    statePrompt.textColor = [UIColor whiteColor];
    statePrompt.font = [UIFont systemFontOfSize:10];
    statePrompt.textAlignment = NSTextAlignmentCenter;
    statePrompt.layer.masksToBounds =YES;
    statePrompt.layer.cornerRadius = 5;
    [performPeopleImage addSubview:statePrompt];
    
    
    return self;
}

@end
