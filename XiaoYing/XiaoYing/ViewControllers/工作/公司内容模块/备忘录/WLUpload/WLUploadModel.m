//
//  UploadModel.m
//  XiaoYing
//
//  Created by ZWL on 16/7/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "WLUploadModel.h"

@implementation WLUploadModel

- (float)calculateFileSizeInUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3)) { return (float) (contentLength / (float)pow(1024, 3)); }
    else if (contentLength >= pow(1024, 2)) { return (float) (contentLength / (float)pow(1024, 2)); }
    else if (contentLength >= 1024) { return (float) (contentLength / (float)1024); }
    else { return (float) (contentLength); }
}

- (NSString *)calculateUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3)) { return @"GB";}
    else if(contentLength >= pow(1024, 2)) { return @"MB"; }
    else if(contentLength >= 1024) { return @"KB"; }
    else { return @"B"; }
}

- (void)encodeWithCoder:(NSCoder *)aCoder //将属性进行编码
{
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeInteger:self.startLength forKey:@"startLength"];
    [aCoder encodeInteger:self.totalSize forKey:@"totalSize"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.token forKey:@"token"];

//    [aCoder encodeInteger:self.isPause forKey:@"isPause"];
//    [aCoder encodeInteger:self.isDownloading forKey:@"isDownloading"];

    
}

- (id)initWithCoder:(NSCoder *)aDecoder //将属性进行解码
{
    self = [super init];
    if (self) {
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.startLength = [aDecoder decodeIntegerForKey:@"startLength"];
        self.totalSize = [aDecoder decodeIntegerForKey:@"totalSize"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.token = [aDecoder decodeObjectForKey:@"token"];

//        self.isPause = [aDecoder decodeIntegerForKey:@"isPause"];
//        self.isDownloading = [aDecoder decodeIntegerForKey:@"isDownloading"];

        
    }
    return self;
}

@end
