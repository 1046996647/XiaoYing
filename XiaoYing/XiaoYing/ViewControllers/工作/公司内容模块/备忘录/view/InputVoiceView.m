//
//  InputVoiceView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "InputVoiceView.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface InputVoiceView () <UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    UIImageView *_recordBtn;        // 按住录音
    UILabel *_recordLab;        // 按住录音
    UIButton *_playerBtn;           // 播放录音
    UIButton *_resetBtn;            // 重置录音
    UIButton *_commitBtn;           // 提交审批
    UIView *_backGroundView;        // 背景框
    UIView *_tabBar;                // 最下面类似标签栏
    UITextView *_inputContentTextView;// 输入审批意见
    UILabel *_placeholder;          // 默认提示
    NSTimer *_recordTimer;          // 录音计时器
    NSTimer *_playerTimer;          // 播放定时器
    BOOL _isRecordSuccess;          // 标记是否录音成功
    NSUInteger _recordTime;         // 录音时间长度
    UIImageView *_animationView;    // 动画
    NSArray *images;                // 动画素材
}

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioRecorder *recoder;

@end

@implementation InputVoiceView

static int i = 0;

- (void)removeSelf {
    [_playerTimer invalidate];
    _playerTimer = nil;
    [_recordTimer invalidate];
    _recordTimer = nil;
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        images = @[@"vioce_1",
                   @"vioce_2",
                   @"vioce_3",
                   @"vioce_4"];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self setAudioSession];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _isRecordSuccess = NO;
        self.layer.cornerRadius =5;
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self p_createSubviews];
    }
    return self;
}

#pragma mark - Private
/**
 *  创建视图
 */
- (void)p_createSubviews {
    
    // 容器视图
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(20, 44, kScreenWidth - 40, 270)];
    container.layer.cornerRadius = 5;
    [container.layer setBorderWidth:0.5];
    [container.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    
    CGFloat width = container.frame.size.width;
//    CGFloat height = container.frame.size.height;

    
    // 动画
    _animationView = [[UIImageView alloc] initWithFrame:CGRectMake((container.frame.size.width - 120) / 2, 60, 120, 270 - 44 - 120)];
    _animationView.contentMode = UIViewContentModeScaleAspectFit;
    _animationView.image = [UIImage imageNamed:@"vioce_1"];
    [container addSubview:_animationView];

    // 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self addGestureRecognizer:tap];
    
    [container addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:nil]];
    
    // 下方框
    _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 226, width, 44)];
    [container addSubview:_tabBar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    [_tabBar addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    // 背景框
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(11, 7, width -  70, 30)];
    _backGroundView.layer.cornerRadius = 5;
    [_backGroundView.layer setBorderWidth:0.5];
    [_backGroundView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_tabBar addSubview:_backGroundView];
    
    // 按住说话
    _recordBtn = [[UIImageView alloc] initWithFrame:CGRectMake((width -  70) / 3, 6, 18, 18)];
    _recordBtn.image = [UIImage imageNamed:@"voice"];
    _recordBtn.userInteractionEnabled = YES;
    [_backGroundView addSubview:_recordBtn];
    
    // 按住说话Lab
    _recordLab = [[UILabel alloc] initWithFrame:CGRectMake((width -  70) / 3 + 24, 6, (width -  70) / 3 - 24 + 10, 18)];
    _recordLab.text = @"按住说话";
    _recordLab.font = [UIFont systemFontOfSize:12];
    _recordLab.userInteractionEnabled = YES;
    [_backGroundView addSubview:_recordLab];
    
    // 播放语音
    _playerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _playerBtn.frame =CGRectMake(9, 6, 50, 18);
    [_playerBtn setImage:[UIImage imageNamed:@"voice_done"] forState:UIControlStateNormal];
    //    [_playerBtn setTitle:@"" forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_playerBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    _playerBtn.titleLabel.font =[UIFont systemFontOfSize:10];
    [_backGroundView addSubview:_playerBtn];
    _playerBtn.hidden = YES;
    
    // 重置
    _resetBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _resetBtn.frame =CGRectMake(width -  70 - 30, 6, 18, 18);
    [_resetBtn setImage:[UIImage imageNamed:@"voice_delete"] forState:UIControlStateNormal];
    [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:_resetBtn];
    _resetBtn.hidden =YES;
    
    // 提交
    _commitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame =CGRectMake(width - 48, 6,40,30);
    [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    _commitBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBtn.backgroundColor = [UIColor greenColor];
    [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.layer.cornerRadius = 5;
    [_commitBtn.layer setBorderWidth:0.5];
    [_commitBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_tabBar addSubview:_commitBtn];
}

/**
 *  设置音频会话,设置为播放和录音状态以便可以录制完成后播放
 */
- (void)setAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  获取保存路径
 *
 *  @return 路径
 */
- (NSString *)savePath {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [filePath stringByAppendingString:@"/recoder.caf"];
    NSLog(@"%@", filePath);
    return filePath;
}

#pragma mark - AVAudioRecorder,AVAudioPlayer
/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)recoder {
    if (!_recoder) {
        NSURL *url = [NSURL fileURLWithPath:[self savePath]];
        NSError *error = nil;
        NSMutableDictionary *settings = [@{
                                           AVFormatIDKey : @(kAudioFormatLinearPCM),
                                           AVSampleRateKey : @(8000),
                                           AVNumberOfChannelsKey : @(1),
                                           AVLinearPCMBitDepthKey : @(8),
                                           AVLinearPCMIsFloatKey : @(YES)
                                           } mutableCopy];
        _recoder = [[AVAudioRecorder alloc] initWithURL:url
                                               settings:settings
                                                  error:&error];
        _recoder.delegate=self;
        if (error) {
            NSLog(@"%@", error);
            return nil;
        }
    }
    return _recoder;
}

/**
 *  获得播放对象
 *
 *  @return 播放对象
 */
- (AVAudioPlayer *)player {
    if (!_player) {
        NSError *error = nil;
        NSURL *fileUrl = [NSURL fileURLWithPath:[self savePath]];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl
                                                         error:&error];
        _player.numberOfLoops = 0;
        _player.volume = 1.0;
        _player.delegate = self;
        [_player prepareToPlay];
        if (error) {
            NSLog(@"%@", error);
            return nil;
        }
    }
    return _player;
}


#pragma mark - ShowViewController
/**
 *  播放时候的视图显示
 */
- (void)showPlayerView {
    [_playerBtn setTitle:[NSString stringWithFormat:@"  %i＂", i] forState:UIControlStateNormal];
    _recordLab.hidden = YES;
    _recordBtn.hidden = YES;
    _backGroundView.backgroundColor = [UIColor colorWithHexString:@"#a2e65b"];
    _playerBtn.hidden = NO;
    _resetBtn.hidden = NO;
}

/**
 *  录制的时候的视图显示
 */
- (void)showRecordView {
    _recordLab.hidden = NO;
    _recordBtn.hidden = NO;
    _playerBtn.hidden = YES;
    _resetBtn.hidden = YES;
}

#pragma mark - ButtonEvent
/**
 *  提交
 */
- (void)commitAction {
    NSLog(@"提交");
    [self removeFromSuperview];
}

/**
 *  播放
 */
- (void)playAction {
    if (![self.player isPlaying]) {
        if ([self.player play]) {
            NSLog(@"播放");
            if (_playerTimer == nil) {
                _playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
            }
            _playerTimer.fireDate = [NSDate distantPast];
        } else {
            NSLog(@"失败");
        }
    } else {
        [self.player pause];
        _playerTimer.fireDate = [NSDate distantFuture];
    }
}

/**
 *  重新录音
 */
- (void)resetAction {
    i = 0;
    _animationView.image = [UIImage imageNamed:images[0]];
    [self showRecordView];
    NSLog(@"重置");
}

#pragma mark - TimerAction
/**
 *  录音定时器
 */
- (void)recordAction {
    i++;
    NSLog(@"录音时间:%i", i);
    _animationView.image = [UIImage imageNamed:images[i % 4]];
    if (i == 60) {
        NSLog(@"停止录音, 最多60秒");
        [self.recoder stop];
        _recordTimer.fireDate = [NSDate distantFuture];
        self.recoder = nil;
        [self showPlayerView];
    }
}

/**
 *  播放定时器
 */
- (void)playerTimerAction {
    i --;
    _animationView.image = [UIImage imageNamed:images[i % 4]];
    [_playerBtn setTitle:[NSString stringWithFormat:@" %i＂", i] forState:UIControlStateNormal];
    if (i == 0) {
        _playerTimer.fireDate = [NSDate distantFuture];
        i = (int)_recordTime;
        [_playerBtn setTitle:[NSString stringWithFormat:@" %i＂", i] forState:UIControlStateNormal];
    }
}

#pragma mark - TouchEvent
/**
 *  按住
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isEqual:_recordBtn] || [view isEqual:_recordLab]) {
        [self setAudioSession];
        NSLog(@"录音");
        [self.recoder record];
        if (_recordTimer == nil) {
            _recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordAction) userInfo:nil repeats:YES];
        }
        _recordTimer.fireDate = [NSDate distantPast];
    }
    NSLog(@"%@", view);
}

/**
 *  松开
 *
 *  @param touches
 *  @param event
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isEqual:_recordBtn] || [view isEqual:_recordLab]) {
        _recordTimer.fireDate = [NSDate distantFuture];
        [self.recoder stop];
        self.recoder = nil;
        if (i < 2) {
            NSLog(@"录音时间太短");
            _recordTimer = nil;
            i = 0;
            [self showRecordView];
        } else {
            [self showPlayerView];
            _playerTimer.fireDate = [NSDate distantFuture];
            _animationView.image = [UIImage imageNamed:images[0]];
            _isRecordSuccess = YES;
            _backGroundView.backgroundColor = [UIColor colorWithHexString:@"#a2e65b"];
        }
        NSLog(@"停止录音");
    }
}

#pragma mark - AVAudioPlayerDelegate
// 播放成功
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"完成播放");
}

// 播放出错
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"%@", error);
}

#pragma mark - AVAudioRecorderDelegate
// 录音成功
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    _animationView.image = [UIImage imageNamed: images[0]];
    if (_isRecordSuccess && ![self.player isPlaying]) {
        if ([self.player play]) {
            NSLog(@"播放");
            _recordTime = i;
        } else {
            NSLog(@"失败");
        }
        [self.player pause];
    }
}

#pragma mark - UITextViewDelegate
/**
 *  开始编辑 提示影藏
 *
 *  @param textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_placeholder setHidden:YES];
}

/**
 *  获取输入变化
 *
 *  @param textView
 *  @param range
 *  @param text
 *
 *  @return 是否获取
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_inputContentTextView resignFirstResponder];
    }
    return YES;
}

/**
 *  结束编辑
 *
 *  @param textView
 */
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        _placeholder.hidden = NO;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
