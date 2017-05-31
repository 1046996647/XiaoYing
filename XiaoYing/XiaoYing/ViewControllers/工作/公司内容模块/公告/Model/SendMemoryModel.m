//
//  SendMemoryModel.m
//  Memory
//
//  Created by ZWL on 16/8/24.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SendMemoryModel.h"

@implementation SendMemoryModel

- (instancetype)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        _HasImage = [dic[@"HasImage"] integerValue];
        
        _Id = [dic[@"Id"] integerValue];
        
        NSString *createTime = [dic[@"CreateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@"  "];
        NSArray *arr = [createTime componentsSeparatedByString:@":"];
        createTime = [NSString stringWithFormat:@"%@:%@",arr[0],arr[1]];
        _CreateTime = createTime;
        
        NSArray *contenArr = [dic[@"Content"] objectFromJSONString];
//        NSArray *contenArr = dic[@"Content"];
        self.dataArr = contenArr;
        for (NSDictionary *subDic in contenArr) {
            
            NSInteger num = [subDic[@"type"] integerValue];
            
            if (1 == num) {                
                NSDictionary *diction = subDic[@"content"];
                NSString *formatUrl = diction[@"FormatUrl"];
                NSString *url = [NSString replaceString:formatUrl Withstr1:@"100" str2:@"100" str3:@"c"];
                self.urlStr = url;
                
//                NSLog(@"dss");
                break;
                
            }
        }
        
        for (NSDictionary *subDic in contenArr) {
//            NSLog(@"%ld",str.length);空字符长度为0

            NSInteger num = [subDic[@"type"] integerValue];
            
            NSString *subStr = subDic[@"content"];

            if (0 == num && subStr.length > 0) {
                _Content = subStr;

                break;
                
            }

        }
    }
    return self;
}



@end
