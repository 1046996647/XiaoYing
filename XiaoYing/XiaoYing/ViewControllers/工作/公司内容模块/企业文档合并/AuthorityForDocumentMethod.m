//
//  AuthorityForDocumentMethod.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/2/8.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "AuthorityForDocumentMethod.h"

@interface AuthorityForDocumentMethod()
@property (nonatomic, strong) NSMutableArray *regionNameArr;
@property (nonatomic, strong) NSMutableArray *departmentIdArr;
@property (nonatomic, copy) NSString *currentRegion;
@end

@implementation AuthorityForDocumentMethod

- (instancetype)init
{
    if (self = [super init]) {
        self.authorityBool = YES;
    }
    return self;
}

- (NSString *)currentRegion
{
    if (!_currentRegion) {
        _currentRegion = @"";
    }
    return _currentRegion;
}

+ (BOOL)JudgeAuthority:(void(^)(AuthorityForDocumentMethod *auth))block
{
    AuthorityForDocumentMethod *auth = [[AuthorityForDocumentMethod alloc] init];
    block(auth);
    return auth.authorityBool;
}

- (AuthorityForDocumentMethod *(^)(NSString *))regionName
{
    __weak typeof(self) weakSelf = self;
    
    [self dealWithOriginData];
    
    return ^(NSString *str)
    {
        BOOL containBool = [weakSelf.regionNameArr containsObject:str];
        weakSelf.authorityBool = (containBool && weakSelf.authorityBool);
        if (weakSelf.authorityBool) {
            _currentRegion = str;
        }
        return weakSelf;
    };
}

- (AuthorityForDocumentMethod *(^)(NSString *str))deparmentId
{
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str)
    {
        if ([weakSelf.regionNameArr containsObject:weakSelf.currentRegion]) {
            NSUInteger localNum = [weakSelf.regionNameArr indexOfObject:weakSelf.currentRegion];
            NSArray *tempArr = [weakSelf.departmentIdArr objectAtIndex:localNum];
            weakSelf.authorityBool = [tempArr containsObject:str] && weakSelf.authorityBool;
            
        }else {
            weakSelf.authorityBool = NO;
        }
        
        return weakSelf;
    };
}

- (void)dealWithOriginData
{
    //1.获取
    NSMutableArray *array = [ZWLCacheData unarchiveObjectWithFile:PermissionsPath];
    __block NSArray *tempArray = [[NSArray alloc] init];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dic[@"Name"] isEqualToString:@"企业文档"]) {
            tempArray = dic[@"FuncList"];
            *stop = YES;
        }
        
    }];
    
    //2.筛选
    self.regionNameArr = [NSMutableArray array];
    self.departmentIdArr = [NSMutableArray array];

    for (NSDictionary *dic in tempArray) {
        BOOL authBool = [dic[@"Enable"] boolValue];
        if (authBool) {
            [self.regionNameArr addObject:dic[@"Name"]];
            
            NSString *tempStr = dic[@"DepartmentId"];
            NSArray *tempArr = [tempStr componentsSeparatedByString:@","];
            [self.departmentIdArr addObject:tempArr];
        }
    }
}

@end
