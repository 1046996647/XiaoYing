//
//  AuthoritySettingCell.h
//  XiaoYing
//
//  Created by ZWL on 16/6/12.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobModel.h"
@interface AuthoritySettingCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_personalLab;  //个性签名
    
}

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) JobModel *jobModel;

@property (nonatomic,strong) NSString *tempString;

@end
