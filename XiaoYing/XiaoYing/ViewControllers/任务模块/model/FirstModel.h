//
//  Taskmodel.h
//  XiaoYing
//
//  Created by ZWL on 15/11/30.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

//*********************************************得到个人的信息
@interface ProfileMyModel : NSObject<NSCoding>

@property (nonatomic,assign) NSInteger Gender; //性别
@property (nonatomic,copy) NSString * Email;  //邮箱
@property (nonatomic,copy) NSString * Mobile; //手机号
@property (nonatomic,copy) NSString * Signature; //用户签名
@property (nonatomic,assign) NSInteger RegionId; //区域ID
@property (nonatomic,copy) NSString * RegionName; //区域名称
@property (nonatomic,copy) NSString * Address;   //地址
@property (nonatomic,copy) NSString * ProfileId;  //标示ID
@property (nonatomic,copy) NSString * Fullname;   //用户姓名
@property (nonatomic,copy) NSString * FaceUrl;    //头像URL
@property (nonatomic,copy) NSString * Nick;     //用户昵称
@property (nonatomic,copy) NSString * XiaoYingCode;//小赢号
@property (nonatomic,copy) NSString * Birthday;//生日

@end

/**
 *  公司以及公司职位的详情
 */
@interface ProfileCompanyModel : NSObject <NSCoding>

@property (nonatomic,copy) NSString * companyName; //公司名字
@property (nonatomic,copy) NSString * departmentName; //公司部门
@property (nonatomic,copy) NSString * positionName; //职位
@property (nonatomic,copy) NSString * companyTelephone; //公司电话
@property (nonatomic,copy) NSString * companyAddress; //公司地址
@property (nonatomic,copy) NSString * userName;      //姓名

@end


//*********************************************用户信息
@interface UserPersonCenterModel :NSObject<NSCoding>

@property (nonatomic,copy) NSString * UserName;   //姓名
@property (nonatomic,copy) NSString * UserPassword;  //密码
@property (nonatomic,copy) NSString * UserHeadUrl;  //头像

@end

@interface FirstModel : NSObject

//得到个人的信息
+(ProfileMyModel *)GetProfileMyModel:(NSDictionary *)dic;

@end
