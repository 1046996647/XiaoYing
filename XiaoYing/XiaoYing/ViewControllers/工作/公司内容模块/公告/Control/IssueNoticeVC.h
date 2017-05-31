//
//  IssueNoticeVC.h
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
typedef void(^SendBBlock) ();
@interface IssueNoticeVC : BaseSettingViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)NSArray *departmentIdArray;
@property(nonatomic,strong)NSArray *deparments;
@property(nonatomic,copy)SendBBlock sendBlock;
@end
