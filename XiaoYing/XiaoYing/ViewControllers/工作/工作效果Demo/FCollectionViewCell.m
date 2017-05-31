//
//  FCollectionViewCell.m
 

#import "FCollectionViewCell.h"

@interface FCollectionViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;/**<平移手势*/
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;/**<长按手势*/

@property (nonatomic) BOOL allowPan;

- (void)setupDraggableCell;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture;

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture;
@end

@implementation FCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.layer.borderWidth = .5;
//        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self setupDraggableCell];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupDraggableCell];
}

#pragma mark -
#pragma mark Cell Setup
- (void)setupDraggableCell
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.longPressGestureRecognizer.minimumPressDuration = 0.5f;
    self.longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)createView
{
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.deleButton];
    [self.contentView addSubview:self.lab1];
}

#pragma mark -
#pragma mark UIGestureRecognizer Delegates

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !_allowPan)
    {
        return NO;
    }
    BOOL cellCanDrag = YES;
    if ([self.draggingDelegate respondsToSelector:@selector(userCanDragCell:)])
    {
        cellCanDrag = [self.draggingDelegate userCanDragCell:self];
    }
    return cellCanDrag;
}

#pragma mark -
#pragma mark UIGestureRecognizer Handlers

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.iconImage.alpha = 0.7;

            self.allowPan = YES;
    
            if ([self.draggingDelegate respondsToSelector:@selector(userDidBeginDraggingCell:)])
            {
                [self.draggingDelegate longGestureCell:self withGestureRecognizer:longPressGesture];
            }

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            self.allowPan = YES;
           
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            break;
        }
        case UIGestureRecognizerStateFailed:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }
        case UIGestureRecognizerStateCancelled:
        {
            self.allowPan = NO;
        
            self.panGestureRecognizer.enabled = NO;
            self.panGestureRecognizer.enabled = YES;

            break;
        }
        default:
            break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.draggingDelegate respondsToSelector:@selector(userDidBeginDraggingCell:)])
            {
                [self.draggingDelegate userDidBeginDraggingCell:self];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if ([self.draggingDelegate respondsToSelector:@selector(userDidDragCell:withGestureRecognizer:)])
            {
                [self.draggingDelegate userDidDragCell:self withGestureRecognizer:panGesture];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
           
            break;
        }
        case UIGestureRecognizerStateFailed:
        {
           
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if ([self.draggingDelegate respondsToSelector:@selector(userDidEndDraggingCell:)])
            {
                [self.draggingDelegate userDidEndDraggingCell:self];
            }

                break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark set & get
-(UILabel *)lab1{
    if (!_lab1) {
        _lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5+6+30, self.frame.size.width, 20)];
        _lab1.textColor = [UIColor blackColor];
        _lab1.font = [UIFont systemFontOfSize:11];
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _lab1;
}

- (UIImageView *)iconImage
{
    if (!_iconImage)
    {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-30)/2, 12.5, 30, 30)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}

- (void)setOperatype:(DemonOperateType)operatype
{
    if (_operatype != operatype)
    {
        _operatype = operatype;
    }
    [self createView];
}

- (UIButton *)deleButton
{
    if (!_deleButton)
    {
        _deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 暂时注掉（打开可用）
//        _deleButton.frame = CGRectMake(self.bounds.size.width-25, 5, 20, 20);
        if (_operatype == DemonOperateTypeAdd)
        {
            [_deleButton setBackgroundImage:[UIImage imageNamed:@"work_add"] forState:UIControlStateNormal];
        }
        else
        {
            [_deleButton setBackgroundImage:[UIImage imageNamed:@"work_subtract"] forState:UIControlStateNormal];
        }

        [_deleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleButton.alpha = 0;
    }
    return _deleButton;
}
 
- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName)
    {
        _imageName = imageName;
    }
    [self fullData];
}

- (void)fullData
{
    self.iconImage.image = [UIImage imageNamed:_imageName];
}
#pragma mark -
#pragma mark ButtonAction
- (void)buttonAction:(UIButton *)button
{
    [UIView animateWithDuration:1 animations:^{
        
        button.transform = CGAffineTransformMakeScale(0.8, 0.8);
        button.alpha = 0;
    }];
    [self.draggingDelegate delectCell:self];
}



@end
