//
//  ZoomInView.h
//  RecollectionView
//
 

/**
 *
 *
 *   动画视图
 *
 */

#import <UIKit/UIKit.h>

@interface ZoomInView : UIImageView

@property(nonatomic,assign) CGPoint toPoint;
@property(nonatomic,copy) void(^fuckOff)();
@end
