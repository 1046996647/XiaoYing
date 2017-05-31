//
//  HSBlockButton.h
//  XiaoYing
//
//  Created by chenchanghua on 16/12/1.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonBlock)(UIButton *button);

@interface HSBlockButton : UIButton

@property(nonatomic, copy) ButtonBlock block;

/*UIControlEventTouchUpInside*/
- (void)addTouchUpInsideBlock:(ButtonBlock)block;

@end
