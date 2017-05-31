//
//  EditCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalTaskModel.h"


//@protocol EditCellDelegate <NSObject>
//
//- (void)refresh:(NSInteger)picCount row:(NSInteger)row;
//@end

@interface EditCell : UITableViewCell

@property (nonatomic,assign) NSInteger row;
@property (nonatomic,copy) NSString *identifier;

// 第一种单元格
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;

// 第二种单元格
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *titleLab1;
@property (nonatomic,strong) UIButton *heightBtn;
@property (nonatomic,strong) UIButton *middleBtn;
@property (nonatomic,strong) UIButton *lowBtn;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UITextView *tv;
@property (nonatomic,strong) UILabel *decribeLab;

@property (nonatomic,strong) UIButton *imgBtn;

//@property (nonatomic,strong) id<EditCellDelegate> delegate;

@property (nonatomic,strong) LocalTaskModel *model;

@end
