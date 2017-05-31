//
//  StateItem.m
//  XiaoYing
//
//  Created by ZWL on 15/11/5.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "StateItem.h"

@implementation StateItem

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.CurrentTaskCount forKey:@"CurrentTaskCount"];
    [aCoder encodeObject:self.TotalCount forKey:@"TotalCount"];
    [aCoder encodeObject:self.Type forKey:@"Type"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.CurrentTaskCount=[aDecoder decodeObjectForKey:@"CurrentTaskCount"];
        self.TotalCount=[aDecoder decodeObjectForKey:@"TotalCount"];
        self.Type=[aDecoder decodeObjectForKey:@"Type"];
    }
    
    return self;
}
@end
