//
//  XYAlertTool.m
//  alerttest
//
//  Created by ZWL on 15/12/11.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "XYAlertTool.h"

//是否是iOS 8 及 以上版本
#define iOS_Version_8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface XYAlertTool () <UIAlertViewDelegate>
{
    UIAlertView *_alertView;            // iOS8 以前使用
    UIAlertController *_alertCtrl;      // iOS8 以后使用
    NSMutableArray *_blockArray;        // button对应的事件
    NSMutableArray *_otherTitleArray;   // 按钮名称
    BOOL _isContinue;                   // 是否开启事件循环
    BOOL _hasBlock;                     // 是否需要响应事件
}

@end

@implementation XYAlertTool

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
                 ButtonTitles:(NSString *)otherTitles, ... {
    _isContinue = YES;
    _otherTitleArray = [NSMutableArray array];
    _blockArray = [NSMutableArray array];
    va_list params;
    va_start(params, otherTitles);
    NSString *arg;
    if (otherTitles) {
        NSString *prev = otherTitles;
        [_otherTitleArray addObject:prev];
        while ((arg = va_arg(params, NSString*))) {
            if (arg) {
                [_otherTitleArray addObject:arg];
            }
        }
        va_end(params);
    }
    if (self = [super init]) {
        _blockArray = [NSMutableArray array];
        _hasBlock = hasBlock;
        if (iOS_Version_8) {
            _alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            if (!hasBlock) {
                for (int i = 0; i < _otherTitleArray.count; i++) {
                    [_alertCtrl addAction:[UIAlertAction actionWithTitle:_otherTitleArray[i]
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]];
                }
            }
        } else {
            _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:_otherTitleArray[0] otherButtonTitles:nil];
            for (int i = 1; i < _otherTitleArray.count; i++) {
                [_alertView addButtonWithTitle:_otherTitleArray[i]];
            }
            [_alertView show];
        }
    }
    return self;
}

/**
 *  添加执行的事件
 *
 *  @param block 每个button对应的事件
 */
- (void)addBlocks:(AlertBlock)block, ...{
    va_list params;
    va_start(params, block);
    AlertBlock arg;
    if (block) {
        AlertBlock prev = block;
        [_blockArray addObject:prev];
        while ((arg = va_arg(params, AlertBlock))) {
            if (arg) {
                [_blockArray addObject:arg];
            }
        }
        va_end(params);
    }
    if (iOS_Version_8) {
        for (int i = 0; i < _blockArray.count; i++) {
            AlertBlock block = _blockArray[i];
            NSString *title = _otherTitleArray[i];
            [_alertCtrl addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                block();
            }]];
        }
    } else {
        while (_isContinue) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
        }
    }
}


/**
 *  点击按钮 iOS8 之前UIAlertView
 *
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AlertBlock block = _blockArray[buttonIndex];
    block();
    _isContinue = NO;
}

/**
 *  iOS8 之后
 *
 *  @param vtrl
 */
- (void)showAlertInViewController:(UIViewController *)vtrl {
    if (iOS_Version_8) {
        [vtrl presentViewController:_alertCtrl animated:YES completion:nil];
    }
}

#pragma clang diagnostic pop

//- (void)showAlertInViewController:(UIViewController *)vtrl {
//
//}
//

//
//- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message {
//    if (self = [super init]) {
//        _blockArray = [NSMutableArray array];
//        if (!iOS_Version_8) {
//            _alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        } else {
//            _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        }
//    }
//    return self;
//}
//
//- (void)addButtonWithTitle:(NSString *)title Block:(AlertBlock)block {
//    if (!iOS_Version_8) {
//        [_alertCtrl addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            block();
//        }]];
//    } else {
//        [_alertView addButtonWithTitle:title];
//        [_blockArray addObject:block];
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    AlertBlock block = _blockArray[buttonIndex];
//    block();
//}
//
//- (void)showAlertInViewController:(UIViewController *)vtrl {
//    if (!iOS_Version_8) {
//        [vtrl presentViewController:_alertCtrl animated:YES completion:nil];
//    } else {
//        [_alertView show];
//    }
//
//
//}
//
@end
