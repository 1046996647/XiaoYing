//
//  AudioCell.m
//  XiaoYing
//
//  Created by ZWL on 16/7/4.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AudioCell.h"

@implementation AudioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 播放语音视图
        _playView = [[PlayView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 24-20, 30)];
//        _playView.timeStr = @"60";
        //    playView.contentURL = url;
//        _playView.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_playView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(_playView.width-35, 0, 35, 30);
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
//        _deleteBtn.backgroundColor = [UIColor cyanColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"voice_delete"] forState:UIControlStateNormal];
        [_playView addSubview:_deleteBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _playView.timeStr = [NSString stringWithFormat:@"%.0f",[self.mp3Recorder.toallRecordTime floatValue]];
    _playView.contentURL = self.mp3Recorder.url;
    
}

- (void)deleteAction
{
//    [_playView removeFromSuperview];
//    _playView = nil;
    
    [_playView cancel];
    
    [self.mp3Recorder deleteCafCache];
    if (self.deleteBlock) {
        self.deleteBlock(self.mp3Recorder);
    }
}

@end
