//
//  DetailView.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/15.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
//声明协议
@protocol DetailViewDelegate <NSObject>

- (void)passvalue:(NSString *)text;

@end




@interface DetailView : BaseSettingViewController

//2:声明delegate属性存储代理人对象
@property(nonatomic, assign)id<DetailViewDelegate>delegate;

@property (nonatomic, strong)NSString *text;
@property (nonatomic)CGFloat textHeight;
@property (nonatomic)NSInteger textNumber;

@property (nonatomic, strong)NSString *mdifyDescriptionID;
@property (nonatomic)NSInteger type;


@end
