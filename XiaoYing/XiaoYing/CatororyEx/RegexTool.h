//
//  TextCheckTool.h
//  sibu
//
//  Created by l.h on 14-8-22.
//  Copyright (c) 2014年 com.gzsibu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexTool : NSObject



+ (BOOL) isEmptyOrNull:(NSString*) string;

+ (BOOL) notEmptyOrNull:(NSString*) string;

+ (NSString *)trimString:(NSString *) str;



/**
 *校验用户手机号码是否合法
 *@param	str	手机号码
 *@return		手机号是否合法
 */

+ (BOOL) validateUserPhone : (NSString *) str;

// 验证邮箱格式
+ (BOOL) validateEmail : (NSString *) str;

// 验证密码格式
+ (BOOL) validatePassword : (NSString *) str;

+ (BOOL)validateValue:(NSString *)content
            withRegex:(NSString *)regexString;

+ (NSString *) datetimeStrFormatter:(NSString *)dateStr formatter:(NSString *)formatterStr;

+ (BOOL)validateMobile:(NSString *)mobileNum;


+(BOOL)isChinese;

+(BOOL)checkUrl:(NSString*)str;

//判断是否含有非法字符代码
+ (BOOL)isHaveIllegalChar:(NSString *)str;

// 判断密码6-16位且同时包含数字和字母
+(BOOL)judgePassWordLegal:(NSString *)pass;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

@end
