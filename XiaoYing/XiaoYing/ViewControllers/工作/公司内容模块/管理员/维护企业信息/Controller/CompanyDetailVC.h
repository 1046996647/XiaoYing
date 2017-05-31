//
//  CompanyDetailVC.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>


//回调头像或者名称是否修改
typedef void(^BlockChange)(NSString *strID);


//回调请求回来数据中的ID
typedef void(^BlockValue)(NSString *strID);


@interface CompanyDetailVC : UITableViewController

@property (nonatomic, strong)NSString *typeStr;


@property (nonatomic, strong) NSMutableArray *arrayOfSectionTitle; //存储请求回来的数据（描述信息）

@property (nonatomic, strong)NSMutableArray *arrayDescriptionID;
@property (nonatomic, strong)NSMutableArray *cardIDArray;
@property (nonatomic, strong)NSMutableArray *arrayDescriptionNet;  //请求回来描述信息的个数
//@property (nonatomic, strong)NSMutableArray *arrayTitleNet;

@property (nonatomic, strong)NSString *tempDescriptionID;

@property (nonatomic, strong)NSString *CompanyCode;

@property (nonatomic, copy)BlockChange blockChange;

@end
