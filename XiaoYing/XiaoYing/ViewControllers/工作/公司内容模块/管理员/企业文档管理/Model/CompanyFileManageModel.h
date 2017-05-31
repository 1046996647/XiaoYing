//
//  CompanyFileManageModel.h
//  XiaoYing
//
//  Created by ZWL on 16/1/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseModel.h"

@interface CompanyFileManageModel : BaseModel


@property(nonatomic,strong)NSString *fileName;
@property(nonatomic,strong)NSString *fileSize;
@property(nonatomic,strong)NSString *fileType;
@property(nonatomic,strong)NSString *fileURL;
@property(nonatomic,strong)NSString *time;

//@property (readonly) NSInteger messageType;
@property (nonatomic, assign) BOOL isSelected;
//@property (nonatomic) NSInteger tag;

@end
