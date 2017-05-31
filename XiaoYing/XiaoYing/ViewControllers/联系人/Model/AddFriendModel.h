//
//  AddFriendModel.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/3.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

/*
"RequestTime": "2016-10-26 15:38:38",
"FaceUrl": "sample string 2",
"ProfileId": "sample string 3",
"Nick": "sample string 4",
"Status": 5,
"Viewed": true
 */

@interface AddFriendModel : BaseModel

@property (nonatomic, copy) NSString *RequestTime; 
@property (nonatomic, copy) NSString *FaceUrl;
@property (nonatomic, copy) NSString *ProfileId;
@property (nonatomic, copy) NSString *Nick;
@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, strong) NSNumber *Status;
@property (nonatomic, assign) BOOL Viewed;


@end


