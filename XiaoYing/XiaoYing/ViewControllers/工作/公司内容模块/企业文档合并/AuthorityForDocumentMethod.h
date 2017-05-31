//
//  AuthorityForDocumentMethod.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/2/8.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AuthorityForDocumentMethod;

@interface AuthorityForDocumentMethod : NSObject

@property (nonatomic, assign) BOOL authorityBool;

+ (BOOL)JudgeAuthority:(void(^)(AuthorityForDocumentMethod *auth))block;

- (AuthorityForDocumentMethod *(^)(NSString *str))regionName;

- (AuthorityForDocumentMethod *(^)(NSString *str))deparmentId;

@end
