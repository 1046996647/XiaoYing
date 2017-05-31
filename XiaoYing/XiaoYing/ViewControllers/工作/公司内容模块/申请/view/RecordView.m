//
//  RecordView.m
//  XiaoYing
//
//  Created by ZWL on 16/4/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "RecordView.h"

@interface RecordView ()<LVRecordToolDelegate>

@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 录音工具对象
//        self.recordTool = [LVRecordTool sharedRecordTool];
        
        // 初始化子视图
        [self initSubviews];
        
    }
    return self;
}

// 初始化子视图
- (void)initSubviews
{
    // 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    [button setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [button setTitle:@"按住说话" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
    [button addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    // 音量视图
    self.voiceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-90)/2.0, button.top-154, 90, 90)];
    self.voiceImgView.layer.cornerRadius = 5;
    self.voiceImgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.4];
    self.voiceImgView.clipsToBounds = YES;
    self.voiceImgView.hidden = YES;
    self.voiceImgView.image = [UIImage imageNamed:@"voice_playing1"];
    [self addSubview:self.voiceImgView];
    
    // 录音工具代理
    self.recordTool.delegate = self;

}

#pragma mark - 录音按钮事件
// 按下
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    self.voiceImgView.hidden = NO;
    [self.recordTool startRecording];
    [recordBtn setTitle:@"松开结束" forState:UIControlStateNormal];
    [recordBtn setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
}

// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    NSInteger currentTime = (NSInteger)self.recordTool.recorder.currentTime;
    if (currentTime < 2) {
        [self alertWithMessage:@"说话时间太短"];
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];

    } else {
        [self.recordTool stopRecording];
        
        self.voiceImgView.hidden = YES;
        [recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [recordBtn setBackgroundColor:[UIColor clearColor]];

        // 已成功录音
        NSLog(@"已成功录音");
        
        // 创建播放视图
//        if ([self.delegate respondsToSelector:@selector(recordTool:)]) {
//            [self.delegate recordTool:self.recordTool];
//
//        }
    }

}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - 播放录音
- (void)play {
    [self.recordTool playRecordingFile];
}

- (void)dealloc {
    
    if ([self.recordTool.recorder isRecording]) [self.recordTool stopPlaying];
    
    if ([self.recordTool.player isPlaying]) [self.recordTool stopRecording];
    
}

#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
//    self.voiceImgView.hidden = NO;
    NSString *imageName = [NSString stringWithFormat:@"voice_playing%d", no];
    self.voiceImgView.image = [UIImage imageNamed:imageName];
}

@end
