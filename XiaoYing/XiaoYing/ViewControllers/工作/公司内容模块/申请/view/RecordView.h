//
//  RecordView.h
//  XiaoYing
//
//  Created by ZWL on 16/4/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVRecordTool.h"

@protocol RecordViewDelegate <NSObject>

- (void)recordTool:(LVRecordTool *)recordTool;

@end

@interface RecordView : UIView

@property (nonatomic,strong) UIImageView *voiceImgView;

/** 录音工具 */
@property (nonatomic, strong) LVRecordTool *recordTool;

@property (nonatomic,weak) id<RecordViewDelegate> delegate;

@end
