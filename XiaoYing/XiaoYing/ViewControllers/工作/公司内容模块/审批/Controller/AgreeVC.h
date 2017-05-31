//
//  AgreeVC.h
//  XiaoYing
//
//  Created by ZWL on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
typedef void(^Block) (void);
@interface AgreeVC : BaseSettingViewController

@property (nonatomic,copy) NSString *btnText;
@property(nonatomic,strong)NSMutableArray *picturesArray;//用来装图片的数组
@property(nonatomic,strong)NSMutableArray *pictureIDArray;//用来装图片ID的数组
@property(nonatomic,copy)NSString *applyRequestId;//申请的ID号
@property(nonatomic,copy)Block agreeOrRefuseBlock;//点击了同意或者拒绝之后的block
@end
