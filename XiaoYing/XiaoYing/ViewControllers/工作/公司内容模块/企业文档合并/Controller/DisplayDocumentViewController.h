//
//  DisplayDocumentViewController.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/13.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef NS_ENUM(NSUInteger, DisplayDocumentType) {
    DisplayDocumentTypeCompany = 1,
    DisplayDocumentTypeDepartment,
    DisplayDocumentTypePerson,
};

@interface DisplayDocumentViewController : BaseSettingViewController

@property (nonatomic, assign) DisplayDocumentType displayDocumentType;

@property (nonatomic, copy) NSString *folderName;//文件夹的名称
@property (nonatomic, copy) NSString *folderId;//文件夹的id

@property (nonatomic, copy) NSString *departmentId;//部门id
@property (nonatomic, copy) NSString *departmentName;//部门名称
@property (nonatomic, strong) NSMutableArray *folderAllPathArr; //文件夹过程路径数组

@end
