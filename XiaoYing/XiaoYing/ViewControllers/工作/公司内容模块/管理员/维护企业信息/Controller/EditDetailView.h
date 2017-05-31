//
//  EditDetailView.h
//  XiaoYing
//
//  Created by GZH on 16/8/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明协议
@protocol DetailViewDelegate <NSObject>

- (void)passvalue:(NSString *)text;

@end

typedef void(^BlockDescriptionId)(NSString *str);

@interface EditDetailView : UIViewController

//2:声明delegate属性存储代理人对象
@property(nonatomic, assign)id<DetailViewDelegate>delegate;

//@property (nonatomic, strong)NSString *mdifyDescriptionID;
@property (nonatomic, strong)NSString *text;
@property (nonatomic)CGFloat textHeight;
@property (nonatomic)int textNumber;


@property (nonatomic)NSInteger type;

@property (nonatomic, copy)BlockDescriptionId blockDescriptionId;

@end
