//
//  TaskTableViewCell.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "TaskItem.h"
#import "HelpMac.h"

@interface TaskTableViewCell()
{
    UIImageView *imageview;
    UILabel *lab;
    UIView *view;
    UILabel *labcount;
    UILabel *labAll;
}
@end

@implementation TaskTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-12-10, 15.5, 10, 18)];
        [self.contentView addSubview:imageview];
        
        
        lab=[[UILabel alloc]initWithFrame:CGRectMake(17, 18, 70, 20)];
        lab.font=[UIFont systemFontOfSize:16];
        lab.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:lab];
        
        
        view=[[UIView alloc]initWithFrame:CGRectMake(77, 10, 15,15)];
        view.backgroundColor=[UIColor colorWithHexString:@"#f94040"];
        
        labcount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15,15)];
        labcount.textColor=[UIColor whiteColor];
        
        labcount.font=[UIFont systemFontOfSize:10];
        labcount.textAlignment=NSTextAlignmentCenter;
        
        
        [view addSubview:labcount];
        [view.layer setCornerRadius:7.5];
        [self.contentView addSubview:view];
        
        labAll=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-62, 15.5, 40, 18)];
       
        labAll.textColor=[UIColor colorWithHexString:@"#d5d7dc"];
        labAll.font=[UIFont systemFontOfSize:15];
        labAll.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:labAll];
    }
    
    return self;
    
}
-(void)setItem:(TaskItem *)item{
    imageview.image=[UIImage imageNamed:@"Arrow-"];
    lab.text=item.TitleName_;
    if ([item.ProccedCount_ isEqualToString:@"0"]) {
        view.hidden=YES;
    }else{
        view.hidden=NO;
        labcount.text=item.ProccedCount_;
    }
    labAll.text=item.TaskCount_;
}


@end
