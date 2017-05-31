//
//  EditorView.h
//  XiaoYing
//
//  Created by ZWL on 15/11/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class taskModel;

@interface EditorView : UIView<UITextViewDelegate>
@property (nonatomic,retain) taskModel *taskmodel;
@property (nonatomic,retain) UITextView *remarkView;//正文
@property (nonatomic,retain)  UILabel *dateLabel1;//时间label
@property (nonatomic,retain) UIButton *button1;//标题栏后面的红绿灯按钮
@property (nonatomic,retain) UIButton *button2;
@property (nonatomic,retain) UIButton *button3;

@property (nonatomic,retain) UISwitch *switch1;



@end
