//
//  Mp3Recorder.m
//  Created by bmind on 15/7/28.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import "Mp3Recorder.h"


@interface Mp3Recorder()<AVAudioRecorderDelegate>
{
    double lowPassResults;
    float _recordTime;
    NSTimer *playTimer;
    AVAudioSession *_session;
    AVAudioRecorder *_recorder;
}

//@property (nonatomic, strong) AVAudioSession *session;
//@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation Mp3Recorder

- (void)encodeWithCoder:(NSCoder *)aCoder //将属性进行编码
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.toallRecordTime forKey:@"toallRecordTime"];

    
}

- (id)initWithCoder:(NSCoder *)aDecoder //将属性进行解码
{
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.toallRecordTime = [aDecoder decodeObjectForKey:@"toallRecordTime"];

        
    }
    return self;
}



#pragma mark - Init Methods

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _path = [self mp3Path];
    }
    return self;
}

- (void)setRecorder
{
    _recorder = nil;
    NSError *recorderSetupError = nil;
    
    //创建保存文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _cafPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]];
    
    NSURL *url = [NSURL fileURLWithPath:_cafPath];
    self.url = url;
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                            settings:settings
                                               error:&recorderSetupError];
    if (recorderSetupError) {
        NSLog(@"%@",recorderSetupError);
    }
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}

- (void)setSesstion
{
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(_session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [_session setActive:YES error:nil];
}

#pragma mark - Public Methods
- (void)setSavePath:(NSString *)path
{
    self.path = path;
}

- (void)startRecord
{
    [self setSesstion];
    [self setRecorder];
    [_recorder record];
    
    _recordTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
}


- (void)stopRecord
{
    if (playTimer) {
        double cTime = _recorder.currentTime;
        [_recorder stop];
//        NSLog(@"%.0f",cTime);

        if (cTime > 1) {
//            [self audio_PCMtoMP3];
            
            self.toallRecordTime = [NSNumber numberWithFloat:_recordTime];
            
            //语音转字符串Base64Str
            NSData *data = [NSData dataWithContentsOfURL:self.url];
            NSString *encodedVoiceStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString *fileName = [[_cafPath componentsSeparatedByString:@"/"] lastObject];
            NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
            [paramDic  setValue:encodedVoiceStr forKey:@"data"];
            [paramDic  setValue:fileName forKey:@"fileName"];
            [paramDic  setValue:@"images" forKey:@"category"];
            
            NSArray *arrM = @[paramDic];
            
            // 请求网络
            [AFNetClient  POST_Path:Bulkupload params:arrM completed:^(NSData *stringData, id JSONDict) {
                
                NSLog(@"%@",JSONDict[@"Message"]);
                self.urlStr = JSONDict[@"Data"];
                
            } failed:^(NSError *error) {
                NSLog(@"请求失败Error--%ld",(long)error.code);
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithRecorder:)]) {
                [_delegate endConvertWithRecorder:self];
            }
            
        }else {
            
            [_recorder deleteRecording];
            [self deleteCafCache];

            if ([_delegate respondsToSelector:@selector(failRecord)]) {
                [_delegate failRecord];
            }
        }
        
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecord
{
    if (playTimer) {
        [_recorder stop];
        [_recorder deleteRecording];
        [playTimer invalidate];
        playTimer = nil;
    }
}


//录音计时
- (void)countVoiceTime
{
    _recordTime += 0.1;
    [_recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    if ([_delegate respondsToSelector:@selector(recording:volume:)]) {
        [_delegate recording:_recordTime volume:lowPassResults];
    }
}



- (void)deleteMp3Cache
{
    [self deleteFileWithPath:[self mp3Path]];
}

- (void)deleteCafCache
{
    [self deleteFileWithPath:_cafPath];
}

- (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [fileManager removeItemAtURL:self.url error:nil];
    }
    
//    if([fileManager removeItemAtPath:path error:nil])
//    {
//        NSLog(@"删除以前的mp3文件");
//    }
}

// 未用到
#pragma mark - Convert Utils
- (void)audio_PCMtoMP3
{
    NSString *cafFilePath = [self cafPath];
    NSString *mp3FilePath = [self mp3Path];
    
    // remove the old mp3 file
    [self deleteMp3Cache];

    NSLog(@"MP3转换开始");
    if (_delegate && [_delegate respondsToSelector:@selector(beginConvert)]) {
        [_delegate beginConvert];
    }
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    [self deleteCafCache];
    NSLog(@"MP3转换结束");
//    if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithData:)]) {
//        NSData *voiceData = [NSData dataWithContentsOfFile:[self mp3Path]];
////        [_delegate endConvertWithData:voiceData];
//    }
}

//#pragma mark - Path Utils
//- (NSString *)cafPath
//{
//    //创建保存文件路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *cafPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]];
//    NSLog(@"filePath: %@",cafPath);
//    return cafPath;
//}

// 暂时未用
- (NSString *)mp3Path
{
    NSString *mp3Path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mp3.caf"];
    return mp3Path;
}

@end
