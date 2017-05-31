//
//  ConnectModel.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/2.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ConnectModel.h"
//*****************************************************
@implementation ConnectWithMyFriend

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if(aDecoder ==nil){
            return self;
        }
        _Fullname = [aDecoder decodeObjectForKey:@"_Fullname"];
        _OrgId = [aDecoder decodeObjectForKey:@"_OrgId"];
        _FaceUrl = [aDecoder decodeObjectForKey:@"_FaceUrl"];
        _Nick = [aDecoder decodeObjectForKey:@"_Nick"];
        _ProfileId = [aDecoder decodeObjectForKey:@"_ProfileId"];
        _DepartmentId = [aDecoder decodeObjectForKey:@"_DepartmentId"];
        _RelationType = [aDecoder decodeObjectForKey:@"_RelationType"];
        _RequestTime = [aDecoder decodeObjectForKey:@"_RequestTime"];
        _pinyin = [aDecoder decodeObjectForKey:@"_pinyin"];
        _Birthday = [aDecoder decodeObjectForKey:@"_Birthday"];
        _RegionName = [aDecoder decodeObjectForKey:@"_RegionName"];
        _RegionId = [aDecoder decodeObjectForKey:@"_RegionId"];
        _Gender = [aDecoder decodeObjectForKey:@"_Gender"];
        _XiaoYingCode = [aDecoder decodeObjectForKey:@"_XiaoYingCode"];
        _Signature = [aDecoder decodeObjectForKey:@"_Signature"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_FaceUrl forKey:@"_FaceUrl"];
    [aCoder encodeObject:_OrgId forKey:@"_OrgId"];
    [aCoder encodeObject:_Fullname forKey:@"_Fullname"];
    [aCoder encodeObject:_Nick forKey:@"_Nick"];
    [aCoder encodeObject:_ProfileId forKey:@"_ProfileId"];
    [aCoder encodeObject:_DepartmentId forKey:@"_DepartmentId"];
    [aCoder encodeObject:_RelationType forKey:@"_RelationType"];
    [aCoder encodeObject:_RequestTime forKey:@"_RequestTime"];
    [aCoder encodeObject:_pinyin forKey:@"_pinyin"];
    [aCoder encodeObject:_Birthday forKey:@"_Birthday"];
    [aCoder encodeObject:_RegionName forKey:@"_RegionName"];
    [aCoder encodeObject:_RegionId forKey:@"_RegionId"];
    [aCoder encodeObject:_Gender forKey:@"_Gender"];
    [aCoder encodeObject:_XiaoYingCode forKey:@"_XiaoYingCode"];
    [aCoder encodeObject:_Signature forKey:@"_Signature"];
    
}

- (instancetype)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        
        _pinyin = [dic[@"Nick"] pinyin];
        
        if ([[dic objectForKey:@"RegionId"] isKindOfClass:[NSNull class]]) {
            self.RegionId= @0;
        }
        if ([[dic objectForKey:@"Birthday"] isKindOfClass:[NSNull class]]) {
            self.Birthday= @"";
        }
        else {
            NSArray *array = [self.Birthday componentsSeparatedByString:@" "];
            self.Birthday= array.firstObject;

        }
        if ([[dic objectForKey:@"Signature"] isKindOfClass:[NSNull class]]) {
            self.Signature= @"";
        }
        if ([[dic objectForKey:@"RegionName"] isKindOfClass:[NSNull class]]) {
            self.RegionName= @"";
        }
    }
    return self;
}



@end


@implementation ConnectModel




@end
