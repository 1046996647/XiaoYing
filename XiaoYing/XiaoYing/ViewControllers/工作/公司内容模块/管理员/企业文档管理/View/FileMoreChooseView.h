//
//  FileMoreChooseView.h
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileMoreChooseView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedArray;//是否被点击

@property (nonatomic, strong) NSMutableArray *folderArray; //文件夹区头的数组
@property (nonatomic, strong) NSMutableArray *fileArray; //文件区头的数组

@property (nonatomic, strong) NSMutableArray *folderDeleteArray; //要删除的文件夹区头的数组
@property (nonatomic, strong) NSMutableArray *fileDeleteArray; //要删除的文件区头的数组

@property (nonatomic, strong) UIButton *selectBtn; //cell右边的选择按钮

@property (nonatomic, assign) NSInteger sectionTemp;
@property (nonatomic, assign) CGFloat tempHeight;

- (void)selectAllDocument:(BOOL)whether;

@end
