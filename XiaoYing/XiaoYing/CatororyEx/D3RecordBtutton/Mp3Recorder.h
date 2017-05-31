//
//  Mp3Recorder.h
//  Created by bmind on 15/7/28.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lame.h"
#import <AVFoundation/AVFoundation.h>

@class Mp3Recorder;

@protocol Mp3RecorderDelegate <NSObject>
- (void)failRecord;
- (void)beginConvert;
- (void)recording:(float)recordTime volume:(float)volume;
//- (void)endConvertWithData:(NSData *)voiceData;
- (void)endConvertWithRecorder:(Mp3Recorder *)recorder;

@end

@interface Mp3Recorder : NSObject<NSCoding>

@property (nonatomic, weak) id<Mp3RecorderDelegate> delegate;

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *cafPath;
@property (nonatomic, strong) NSNumber *toallRecordTime;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,copy) NSString *urlStr;

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
- (void)deleteCafCache;





@end
