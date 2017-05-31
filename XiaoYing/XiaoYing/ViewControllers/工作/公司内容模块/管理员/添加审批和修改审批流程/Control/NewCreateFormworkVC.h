//
//  NewCreateFormworkVC.h
//  XiaoYing
//
//  Created by ZWL on 16/1/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^RefreshBlock)(void);


@interface NewCreateFormworkVC : BaseSettingViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSString *TypeName;
@property (nonatomic,strong) NSMutableArray *selectedDepArr;
@property (nonatomic,strong)NSMutableArray *selectedEmpArr;
@property (nonatomic,strong)NSArray *flowsArr;

@property (nonatomic,assign) NSInteger TagType;
@property (nonatomic,copy) NSString *CategoryID;
@property (nonatomic,strong)NSMutableArray *ContentTemp;

@property (nonatomic,copy) RefreshBlock refreshBlock;

@end
