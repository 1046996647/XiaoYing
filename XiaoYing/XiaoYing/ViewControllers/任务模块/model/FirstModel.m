//
//  Taskmodel.m
//  XiaoYing
//
//  Created by ZWL on 15/11/30.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "FirstModel.h"
/**
 *  公司信息详情
 *
 *  @return （）
 */
@implementation ProfileCompanyModel

/**
 *  编码的方法
 *
 *  @param aCoder
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_companyAddress forKey:@"companyAddress"];
    [aCoder encodeObject:_companyName forKey:@"companyName"];
    [aCoder encodeObject:_departmentName forKey:@"departmentName"];
    [aCoder encodeObject:_positionName forKey:@"positionName"];
    [aCoder encodeObject:_companyTelephone forKey:@"companyTelephone"];
    [aCoder encodeObject:_userName forKey:@"userName"];
   
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        _companyTelephone = [aDecoder decodeObjectForKey:@"companyTelephone"];
        _companyName = [aDecoder decodeObjectForKey:@"companyName"];
        _departmentName = [aDecoder decodeObjectForKey:@"departmentName"];
        _positionName = [aDecoder decodeObjectForKey:@"positionName"];
        _companyAddress = [aDecoder decodeObjectForKey:@"companyAddress"];
        _userName = [aDecoder decodeObjectForKey:@"userName"];
        
    }
    return self;
}

@end


//*****************************************************个人信息
@implementation ProfileMyModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_Email forKey:@"Email"];
    [aCoder encodeObject:_Mobile forKey:@"Mobile"];
    [aCoder encodeObject:_Signature forKey:@"Signature"];
    [aCoder encodeObject:_RegionName forKey:@"RegionName"];
    [aCoder encodeObject:_Address forKey:@"Address"];
    [aCoder encodeObject:_ProfileId forKey:@"ProfileId"];
    [aCoder encodeObject:_Fullname forKey:@"Fullname"];
    [aCoder encodeObject:_FaceUrl forKey:@"FaceUrl"];
    [aCoder encodeObject:_Nick forKey:@"Nick"];
    [aCoder encodeInteger:_Gender forKey:@"Gender"];
    [aCoder encodeInteger:_RegionId forKey:@"RegionId"];
    [aCoder encodeObject:_XiaoYingCode forKey:@"XiaoYingCode"];
    [aCoder encodeObject:_Birthday forKey:@"Birthday"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _Email = [aDecoder decodeObjectForKey:@"Email"];
        _Mobile = [aDecoder decodeObjectForKey:@"Mobile"];
        _Signature = [aDecoder decodeObjectForKey:@"Signature"];
        _RegionName = [aDecoder decodeObjectForKey:@"RegionName"];
        _Address = [aDecoder decodeObjectForKey:@"Address"];
        _ProfileId = [aDecoder decodeObjectForKey:@"ProfileId"];
        _Fullname = [aDecoder decodeObjectForKey:@"Fullname"];
        _FaceUrl = [aDecoder decodeObjectForKey:@"FaceUrl"];
        _Nick = [aDecoder decodeObjectForKey:@"Nick"];
        _Gender = [aDecoder decodeIntegerForKey:@"Gender"];
        _RegionId = [aDecoder decodeIntegerForKey:@"RegionId"];
        _XiaoYingCode = [aDecoder decodeObjectForKey:@"XiaoYingCode"];
        _Birthday = [aDecoder decodeObjectForKey:@"Birthday"];
    }
    
    return self;
}

@end
//**********************************************用户信息
@implementation UserPersonCenterModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_UserHeadUrl forKey:@"UserHeadUrl"];
    [aCoder encodeObject:_UserName forKey:@"UserName"];
    [aCoder encodeObject:_UserPassword forKey:@"UserPassword"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        _UserPassword = [aDecoder decodeObjectForKey:@"UserPassword"];
        _UserName = [aDecoder decodeObjectForKey:@"UserName"];
        _UserHeadUrl = [aDecoder decodeObjectForKey:@"UserHeadUrl"];
    }
    return self;
}


@end

@implementation FirstModel

//***************************设置个人信息
+(ProfileMyModel *)GetProfileMyModel:(NSMutableDictionary *)dic{
    
    
    ProfileMyModel *profilemy=[[ProfileMyModel alloc]init];
    
    //性别
    profilemy.Gender = [[dic objectForKey:@"Gender"] integerValue];
    
    //小赢号
    profilemy.XiaoYingCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"XiaoYingCode"]];

    
    //生日
    if ([[dic objectForKey:@"Birthday"] isKindOfClass:[NSNull class]]) {
        profilemy.Birthday = @"";
    }else{
        
        NSString *birthday = [dic objectForKey:@"Birthday"];
        birthday = [[birthday componentsSeparatedByString:@" "] firstObject];
        profilemy.Birthday = birthday;
    }
    
    //邮箱
    if ([[dic objectForKey:@"Email"] isKindOfClass:[NSNull class]]) {
        profilemy.Email = @"";
    }else{
        profilemy.Email = [dic objectForKey:@"Email"];
    }
   
    //电话
    if ([[dic objectForKey:@"Mobile"] isKindOfClass:[NSNull class]]) {
        profilemy.Mobile = @"";
    }else{
        profilemy.Mobile = [dic objectForKey:@"Mobile"];
    }
   
    //用户签名
    if ([[dic objectForKey:@"Signature"] isKindOfClass:[NSNull class]]) {
        profilemy.Signature = @"";
    }else{
        profilemy.Signature = [dic objectForKey:@"Signature"];

    }
    //区域ID
    if ([[dic objectForKey:@"RegionId"] isKindOfClass:[NSNull class]]) {
        profilemy.RegionId=0;
    }else{
        profilemy.RegionId = [[dic objectForKey:@"RegionId"] integerValue];
    }
    //区域名称
    if ([[dic objectForKey:@"RegionName"] isKindOfClass:[NSNull class]]) {
        profilemy.RegionName = @"";
    }else{
        profilemy.RegionName = [dic objectForKey:@"RegionName"];
    }
    //地址
    if ([[dic objectForKey:@"Address"] isKindOfClass:[NSNull class]]) {
        profilemy.Address = @"";
    }else{
        profilemy.Address = [dic objectForKey:@"Address"];
    }
    //标示ID，其它需要用到此用户信息的时候使用，注意此编码的大小写
    if ([[dic objectForKey:@"ProfileId"] isKindOfClass:[NSNull class]]) {
        profilemy.ProfileId = @"";
    }else{
        profilemy.ProfileId = [dic objectForKey:@"ProfileId"];
    }
    //用户姓名
    if ([[dic objectForKey:@"Fullname"] isKindOfClass:[NSNull class]]) {
        profilemy.Fullname = @"";
    }else{
        profilemy.Fullname = [dic objectForKey:@"Fullname"];
    }
    //头像URL
    if ([[dic objectForKey:@"FaceUrl"] isKindOfClass:[NSNull class]]) {
        profilemy.FaceUrl = @"默认头像";
    }else{
        profilemy.FaceUrl = [dic objectForKey:@"FaceUrl"];

    }
       //用户昵称
    if ([[dic objectForKey:@"Nick"] isKindOfClass:[NSNull class]]) {
        profilemy.Nick = @"";
    }else{
        profilemy.Nick = [dic objectForKey:@"Nick"];
        
    }
    
    return profilemy;
    
}
@end
