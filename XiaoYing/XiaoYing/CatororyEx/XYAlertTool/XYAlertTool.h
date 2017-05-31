//
//  XYAlertTool.h
//  alerttest
//
//  Created by ZWL on 15/12/11.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

// 回调block
typedef void(^AlertBlock)();

@interface XYAlertTool : NSObject

/**
 *  初始化alertView
 *
 *  @param title       提示
 *  @param message     消息
 *  @param hasBlock    是否有回调
 *  @param otherTitles 其他按钮文字若有回调对应相应顺序的block
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                      Message:(NSString *)message
                     HasBlock:(BOOL)hasBlock
                 ButtonTitles:(NSString *)otherTitles,...;

/**
 *  添加回调块
 *
 *  @param block 回掉block
 */
- (void)addBlocks:(AlertBlock)block, ...;

/**
 *  在controller中显示alert
 *
 *  @param vtrl controller
 */
- (void)showAlertInViewController:(UIViewController *)vtrl;

@end
