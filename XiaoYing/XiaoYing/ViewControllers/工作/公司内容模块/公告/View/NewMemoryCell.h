//
//  NewMemoryCell.h
//  Memory
//
//  Created by ZWL on 16/8/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMemoryModel.h"

typedef void(^DeleteBlock)(NewMemoryModel *);
typedef void(^SendBlock)(NSInteger);
typedef void(^ChangeBlock)(NSString *);


@interface NewMemoryCell : UITableViewCell

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *deleteBtn;


@property (nonatomic,strong) NewMemoryModel *model;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger insertIndex;
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) DeleteBlock deleteBlock;
@property (nonatomic,copy) SendBlock sendBlock;
@property (nonatomic,copy) ChangeBlock changeBlock;

@property(nonatomic,assign)BOOL allowEditing;

@end
