//
//  PlayView.h
//  XiaoYing
//
//  Created by ZWL on 16/4/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "PlayView.h"
#import <AVFoundation/AVFoundation.h>

#define kFSVoiceBubbleShouldStopNotification @"FSVoiceBubbleShouldStopNotification"


@interface PlayView () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSArray       *animationImages;
@property (weak  , nonatomic) UIButton      *contentButton;

@end

@implementation PlayView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.backgroundColor                = [UIColor colorWithHexString:@"#f0f0f0"];

        
        // 初始化
        [self initialize];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceClicked:)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bubbleShouldStop:) name:kFSVoiceBubbleShouldStopNotification object:nil];

        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFSVoiceBubbleShouldStopNotification object:nil];
}

- (void)initialize
{
    // 播放按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(9, 0, 40, self.height);
    [button setImage:[UIImage imageNamed:@"voice_done-拷贝-2"]  forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor redColor];
//    [button setTitle:[NSString stringWithFormat:@"%@  \"",self.timeStr] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font                = [UIFont systemFontOfSize:12];
    button.imageView.animationDuration    = 2.0;
    button.imageView.animationRepeatCount = 30;
    [self addSubview:button];
    self.contentButton = button;
    
    // 叉按钮
    
    
}

- (void)setTimeStr:(NSString *)timeStr
{
    _timeStr = timeStr;
    self.contentButton.frame = CGRectMake(9, 0, 40, self.height);
    [self.contentButton setTitle:[NSString stringWithFormat:@"%@\"",timeStr] forState:UIControlStateNormal];

}



#pragma mark - AVAudioPlayer Delegate

//当播放遇到中断的时候（如来电），调用该方法
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self pause];
}

//中断事件结束后调用下面的方法
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    [self play];
}

//播放播放完毕后就会调用该方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopAnimating];
}


#pragma mark - Target Action

- (void)voiceClicked:(id)sender
{
    if (_player.playing && _contentButton.imageView.isAnimating) {
        [self stop];
    } else {

        [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];

        [self play];
    }
}

- (void)prepareToPlay
{
//    if (!_player) {
//        [_player stop];
//        _player = nil;
//    }
    NSError *error;
    
    NSLog(@"____---%@",_contentURL);
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_contentURL error:&error];
    _player.delegate = self;
    [_player prepareToPlay];

}

- (void)startAnimating
{
    if (!_contentButton.imageView.isAnimating) {
        UIImage *image0 = [UIImage imageNamed:@"yingliang11"];
        UIImage *image1 = [UIImage imageNamed:@"yingliang12"];
        UIImage *image2 = [UIImage imageNamed:@"yingliang13"];
        _contentButton.imageView.animationImages = @[image0, image1, image2];
        [_contentButton.imageView startAnimating];
    }
}

- (void)stopAnimating
{
    if (_contentButton.imageView.isAnimating) {
        [_contentButton.imageView stopAnimating];
    }
}

- (void)play
{
    
    if (!_player) {
        
        [self prepareToPlay];
    }
    if (!_player.playing) {
        [_player play];
        [self startAnimating];
    }
}

- (void)pause
{
    if (_player.playing) {
        [_player pause];
        [self stopAnimating];
    }
}

- (void)stop
{
    if (_player.playing) {
        [_player stop];
        _player.currentTime = 0;
        [self stopAnimating];
    }
}

#pragma mark - Nofication

- (void)bubbleShouldStop:(NSNotification *)notification
{
    if (_player.isPlaying) {
        [self stop];
    }
}

// 自加的
- (void)cancel
{
    if (_player.playing) {
        [_player stop];
        [self stopAnimating];
    }
    _player = nil;
}

@end
