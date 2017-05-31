//
//  CompanyDocumentTableView.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/5.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyDocumentTableView : UITableView

@property (nonatomic, strong) NSArray *folderArray; //公司级别的文件夹
@property (nonatomic, strong) NSArray *fileArray;   //公司级别的文件
@property (nonatomic, strong) NSMutableArray *documentListArray;


@end
