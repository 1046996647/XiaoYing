//
//  PrintObject.h
//  Model-Json
//
//  Created by ZWL on 16/7/15.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelJson : NSObject

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。

+ (NSDictionary*)getObjectData:(id)obj;



//将getObjectData方法返回的NSDictionary转化成JSON

+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;



//直接通过NSLog输出getObjectData方法返回的NSDictionary

+ (void)print:(id)obj;

@end
