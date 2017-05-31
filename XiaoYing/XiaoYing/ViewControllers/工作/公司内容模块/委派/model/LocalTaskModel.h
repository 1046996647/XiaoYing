//
//  LocalTaskModel.h
//  Demo
//
//  Created by ZWL on 16/6/14.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "YHCoderObject.h"

@interface FileModel : YHCoderObject

/*
 {
 "Url": "sample string 1",
 "Order": 2,
 "FileType": 3
 }
 */

@property (nonatomic,strong) NSNumber *Order;
@property (nonatomic,strong) NSNumber *FileType;
@property (nonatomic,copy) NSString *Url;


@end

@interface LocalTaskModel : YHCoderObject

/*
 "DesignateId": 1,
 "Order": 1,
 "Title": "sample string 1",
 "Content": "sample string 2",
 "Rank": 1,
 "Achments": [
 {
 "Url": "sample string 1",
 "Order": 2,
 "FileType": 3
 },
 {
 "Url": "sample string 1",
 "Order": 2,
 "FileType": 3
 }
 ]
 */

@property (nonatomic,strong) NSNumber *designateId;
@property (nonatomic,strong) NSNumber *order;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSNumber *rank;
@property (nonatomic,strong) NSMutableArray *achments;

// 图片数组
@property (nonatomic,strong) NSMutableArray *imagesArr;

// 语音数组
@property (nonatomic,strong) NSMutableArray *voicesArr;


@end



@interface DelegateTaskModel : YHCoderObject

/*
"DesignateId": 1,
"Order": 1,
"Title": "sample string 1",
"Content": "sample string 2",
"Rank": 1,
"Achments": [
             {
                 "Url": "sample string 1",
                 "Order": 2,
                 "FileType": 3
             },
             {
                 "Url": "sample string 1",
                 "Order": 2,
                 "FileType": 3
             }
             ]
 */

@property (nonatomic,strong) NSNumber *designateId;
@property (nonatomic,strong) NSNumber *order;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSNumber *rank;
@property (nonatomic,strong) NSMutableArray *achments;



@end
