//
//  ImageBrowseVC.h
//  Memory
//
//  Created by ZWL on 16/8/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowseVC : UIViewController

@property (nonatomic,strong) NSString *sizeType;

@property (nonatomic,strong) UIImage *tempImage;
@property (nonatomic,strong) NSData *imgData;
@property (nonatomic,strong) NSString *urlStr;

@end
