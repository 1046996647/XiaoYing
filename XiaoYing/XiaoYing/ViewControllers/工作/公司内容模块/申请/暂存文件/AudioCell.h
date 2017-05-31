//
//  AudioCell.h
//  XiaoYing
//
//  Created by ZWL on 16/7/4.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "Mp3Recorder.h"


@interface AudioCell : UITableViewCell

typedef void(^DeleteBlock)(Mp3Recorder *);


@property (nonatomic,strong) PlayView *playView;
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, strong) Mp3Recorder *mp3Recorder;


@end
