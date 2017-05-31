//
//  ZoomInView.m


#import "ZoomInView.h"

@interface ZoomInView()

@end

@implementation ZoomInView

#pragma mark -
#pragma mark set & get

- (void)setToPoint:(CGPoint)toPoint
{
    _toPoint = toPoint;
    [self startAnimation];
}

#pragma mark -
#pragma mark Help Method
- (void)startAnimation
{
    CAKeyframeAnimation *animation1 = [self arcAnimation];
    CAKeyframeAnimation *animation2 = [self changeSmallAnimation];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.animations = @[animation1,animation2];
    
    group.duration = 0.8;
    group.repeatCount = 1;
    group.autoreverses = NO;
    group.removedOnCompletion = NO;
    group.fillMode =kCAFillModeBoth;
    [self.layer addAnimation:group forKey:nil];
}

//绘制路径
- (CAKeyframeAnimation *)arcAnimation
{
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //2.设置动画属性
    keyframe.values = @[
                        [NSValue valueWithCGPoint:self.center],
                        [NSValue valueWithCGPoint:_toPoint]
                        ];
    keyframe.delegate = self;
    return keyframe;
}

//大小动画
- (CAKeyframeAnimation *)changeSmallAnimation
{
    CGFloat from3DScale = 1+arc4random() % 10 *0.1;
    CGFloat to3DScale = from3DScale * 0.2;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    return scaleAnimation;
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
   
    [self performSelector:@selector(finishBack) withObject:nil afterDelay:0.1];
}

- (void)finishBack
{
    self.fuckOff();
}
@end
