//
//  KeepAcountModel.m
//  XiaoYing
//
//  Created by ZWL on 15/12/28.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "KeepAcountModel.h"

@implementation KeepAcountModel

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
}
@end
