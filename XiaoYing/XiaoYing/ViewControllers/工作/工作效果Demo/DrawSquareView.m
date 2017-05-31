//
//  DrawSquareView.m

#import "DrawSquareView.h"


@implementation DrawSquareView
{
    NSInteger _num;/**<标记要显示一排cell的个数*/
    CGFloat height;/**<标记高度*/
}

#pragma mark -
#pragma mark life Cycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        height = frame.size.height;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeight) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Private Method
- (void)changeHeight
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    _num = height/(kScreenWidth/4);
    [self drawLine2:context];
    [self drawLine4:context];
}

//画竖线
- (void)drawLine2:(CGContextRef)context
{
    for (int i=0; i<4; i++)
    {
        CGPoint p1 = {(kScreenWidth/4)*(i),0};
        CGPoint p2 = {(kScreenWidth/4)*(i),(kScreenWidth/4)*_num};
        CGPoint points[] = {p1,p2};
        int len = sizeof(points)/sizeof(CGPoint);
        CGContextAddLines(context, points, len);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        [[UIColor lightGrayColor] setStroke];
        CGContextSetLineWidth(context, 0.4);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

//画横线
- (void)drawLine4:(CGContextRef)context
{
    for (int i=0; i<_num+1; i++)
    {
        CGPoint p1 = {0,(kScreenWidth/4)*(i)};
        CGPoint p2 = {kScreenWidth,(kScreenWidth/4)*(i)};
        CGPoint points[] = {p1,p2};
        int len = sizeof(points)/sizeof(CGPoint);
        CGContextAddLines(context, points, len);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        [[UIColor lightGrayColor] setStroke];
        CGContextSetLineWidth(context, 0.4);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end
