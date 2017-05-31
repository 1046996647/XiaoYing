//
//  GroupListModel.m
//  XiaoYing
//
//  Created by ZWL on 16/11/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "GroupListModel.h"

@implementation GroupListModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if(aDecoder ==nil){
            return self;
        }
        _RoomId = [aDecoder decodeObjectForKey:@"_RoomId"];
        _Name = [aDecoder decodeObjectForKey:@"_Name"];
        _Members = [aDecoder decodeObjectForKey:@"_Members"];
        _RongCloudChatRoomId = [aDecoder decodeObjectForKey:@"_RongCloudChatRoomId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_RoomId forKey:@"_RoomId"];
    [aCoder encodeObject:_Name forKey:@"_Name"];
    [aCoder encodeObject:_Members forKey:@"_Members"];
    [aCoder encodeObject:_RongCloudChatRoomId forKey:@"_RongCloudChatRoomId"];

    
}

@end

@implementation ChatMemberModel


@end
