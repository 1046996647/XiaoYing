//
//  GroupListModel.h
//  XiaoYing
//
//  Created by ZWL on 16/11/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseModel.h"
#import "YHCoderObject.h"

/*
"RoomId": 1,
"Name": "sample string 2",
"CreateTime": "2016-11-25 09:53:30",
"Type": 1,
"RoomCode": 3,
"Members": [
            {
                "Id": 1,
                "RoomId": 2,
                "ProfileId": 3,
                "MemberName": "sample string 4"
            },
            {
                "Id": 1,
                "RoomId": 2,
                "ProfileId": 3,
                "MemberName": "sample string 4"
            }
            ],
"RongCloudChatRoomId": "sample string 4"
 */

@interface GroupListModel : BaseModel
@property (nonatomic,copy) NSString *RoomId;

@property (nonatomic,copy) NSString *Name;
//@property (nonatomic,strong) NSNumber *superRanks;
@property (nonatomic,strong) NSArray *Members;
@property (nonatomic,copy) NSString *RongCloudChatRoomId;


@end

@interface ChatMemberModel : BaseModel

@property (nonatomic,copy) NSString *ProfileId;
//@property (nonatomic,strong) NSNumber *superRanks;
@property (nonatomic,strong) NSString *FaceUrl;
@property (nonatomic,copy) NSString *MemberName;


@end
