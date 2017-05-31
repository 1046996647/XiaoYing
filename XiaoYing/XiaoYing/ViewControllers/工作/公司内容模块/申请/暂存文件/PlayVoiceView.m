//
//  PlayVoiceView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "PlayVoiceView.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface PlayVoiceView ()
{
    NSArray *images;                // 动画素材
    UIImageView *_animationView;    // 动画
    UIButton *_playerBtn;           // 播放录音
    UIView *_backGroundView;        // 背景框
    UIView *_tabBar;                // 最下面类似标签栏
    NSTimer *playTimer;             // 播放计时器
    NSTimer *animationTimer;        // 动画计时器
}

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation PlayVoiceView

static int i = 0;
static NSUInteger leftTime = 60;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        images = @[@"vioce_1",
                   @"vioce_2",
                   @"vioce_3",
                   @"vioce_4"];
        leftTime = 60;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self setAudioSession];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
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
    
    // 动画
    _animationView = [[UIImageView alloc] initWithFrame:CGRectMake((container.frame.size.width - 120) / 2, 60, 120, 270 - 44 - 120)];
    _animationView.contentMode = UIViewContentModeScaleAspectFit;
    _animationView.image = [UIImage imageNamed:@"vioce_1"];
    [container addSubview:_animationView];
    
    // 下方框
    _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 226, width, 44)];
    [container addSubview:_tabBar];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    [_tabBar addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    // 播放语音
    _playerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _playerBtn.frame = _tabBar.bounds;
    [_playerBtn setTitle:@"播放语音" forState:UIControlStateNormal];
    [_playerBtn setTitle:@"停止(60)" forState:UIControlStateSelected];
    [_playerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playerBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    _playerBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [_tabBar addSubview:_playerBtn];
    
    
    // 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self addGestureRecognizer:tap];
    
    [container addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:nil]];
}

- (void)removeSelf {
    [playTimer invalidate];
    playTimer = nil;
    [animationTimer invalidate];
    animationTimer = nil;
    [self removeFromSuperview];
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
    filePath = [filePath stringByAppendingString:@"/voice.caf"];
    NSLog(@"%@", filePath);
    return filePath;
}

#pragma mark - AVAudioRecorder
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
        [_player prepareToPlay];
        if (error) {
            NSLog(@"%@", error);
            return nil;
        }
    }
    return _player;
}

#pragma mark - ButtonAction
- (void)imageAnimation:(NSTimer *)timer {
    
    i++;
    _animationView.image = [UIImage imageNamed:images[i % 4]];
    if (i == 60) {
        timer.fireDate = [NSDate distantFuture];
    }
}

- (void)playerTimerAction:(NSTimer *)timer {
    leftTime--;
    [_playerBtn setTitle:[NSString stringWithFormat:@"停止(%li)", (unsigned long)leftTime] forState:UIControlStateSelected];
    if (leftTime == 0) {
        _playerBtn.selected = NO;
        timer.fireDate = [NSDate distantFuture];
    }
}
/**
 *  播放
 */
- (void)playAction {
    _playerBtn.selected = !_playerBtn.selected;
    if (_playerBtn.selected) {
        if(!animationTimer) {
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(imageAnimation:) userInfo:nil repeats:YES];
        }
        animationTimer.fireDate = [NSDate distantPast];
        if (!playTimer) {
            playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerTimerAction:) userInfo:nil repeats:YES];
        }
        playTimer.fireDate = [NSDate distantPast];
    } else {
        animationTimer.fireDate = [NSDate distantFuture];
        i = 0;
        _animationView.image = [UIImage imageNamed:images[0]];
        playTimer.fireDate = [NSDate distantFuture];
        leftTime = 60;
        _playerBtn.selected = NO;
        playTimer.fireDate = [NSDate distantFuture];
    }

    //[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(imageAnimation) userInfo:nil repeats:YES];
//    if (![self.player isPlaying]) {
//        if ([self.player play]) {
//            NSLog(@"播放");
//            if (_playerTimer == nil) {
//                _playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
//            }
//            _playerTimer.fireDate = [NSDate distantPast];
//        } else {
//            NSLog(@"失败");
//        }
//    } else {
//        [self.player pause];
//        _playerTimer.fireDate = [NSDate distantFuture];
//    }
}

@end
