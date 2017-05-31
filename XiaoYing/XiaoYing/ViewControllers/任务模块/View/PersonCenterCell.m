//
//  PersonCenterCell.m
//  XiaoYing
//
//  Created by ZWL on 15/11/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "PersonCenterCell.h"

@implementation PersonCenterCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if ([reuseIdentifier isEqualToString:@"cellHead"]) {
            _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-60, 10, 40, 40)];
            [self.contentView addSubview:_headImageView];

        }else{
            _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-200, 0, 180, 44)];
            _nameLab.textAlignment=NSTextAlignmentRight;
            _nameLab.font=[UIFont systemFontOfSize:13];
         
            _nameLab.numberOfLines=2;
            [self.contentView addSubview:_nameLab];

        }
        
    }
    return self;
}


@end
