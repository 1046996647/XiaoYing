//
//  NewApprovalModel.h
//  XiaoYing
//
//  Created by ZWL on 16/7/4.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseModel.h"

/*
{
    ID = 1;
    Name = "Test11:41:06";
    TypesList =             (
                             {
                                 ID = 1;
                                 Name = TestType;
                                 tagType = 1;
                             },
                             {
                                 ID = 2;
                                 Name = TestType22;
                                 tagType = 1;
                             }
                             );
},
*/

@interface NewApprovalModel : BaseModel

@property (nonatomic,copy) NSString *ID;// 暂时的
@property (nonatomic,copy) NSString *ObjectID;
@property (nonatomic,copy) NSString *Name;
//@property (nonatomic,strong) NSArray *TypesList;

@property (nonatomic,assign) BOOL isSelected;


@end
