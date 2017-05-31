//
//  ApprovalNodeModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalNodeModel : NSObject

@property (nonatomic, copy)NSString *commenterFaceFormatUrl; //批复人的头像地址
@property (nonatomic, copy)NSString *receiveTime; //接收到申请的时间
@property (nonatomic, copy)NSString *commneterName; //批复人的名称
@property (nonatomic, copy)NSString *commenterJobName; //批复人的岗位名称
@property (nonatomic, copy)NSString *statusName; //批复状态名称
@property (nonatomic, copy)NSString *tookTime; //已用时
@property (nonatomic, copy)NSString *comment; //批复意见
@property (nonatomic, strong)NSMutableArray *photosArray; //照片数组，其中为Key为id和Url的字典
@property (nonatomic, assign)BOOL isExpand; //标志审批意见中的内容是否已经展开

+ (NSArray*)getModelArrayFromDataDictionary:(NSDictionary*)dataDict applicationStatus:(NSInteger)status;

@end
