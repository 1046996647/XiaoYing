//

#import "DragAndDropCollectionViewLayout.h"

#define AlphaValue 0.8;

@interface DragAndDropCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableDictionary *itemDictionary;
@property (readonly, nonatomic) NSInteger numberOfItemsPerRow;

- (void)resetLayoutFrames;
- (void)applyDragAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;
- (void)insertDraggedItemAtIndexPath:(NSIndexPath *)intersectPath;
- (NSIndexPath *)indexPathBelowDraggedItemAtPoint:(CGPoint)point;
- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DragAndDropCollectionViewLayout
{
    BOOL _endDragCanBlock;/**<停止拖拽且达到改变位置的条件*/
    CGFloat _height;/**<标记DecorationView的高度*/
}

- (instancetype)initWithOperaType:(DemonOperateType)operateType
{
    self = [super init];
    if (self)
    {
        _operateType = operateType;
        _endDragCanBlock = NO;
        _itemArray = [NSMutableArray array];
        _itemDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context
{
    [super invalidateLayoutWithContext:context];
    if (context.invalidateEverything)
    {
        [self.itemArray removeAllObjects];
    }
}

//每次重新给出layout时都会调用prepareLayout
- (void)prepareLayout
{
    [super prepareLayout];
    //需要画分割线时调用
//    [self registerClass:[DrawSquareView class] forDecorationViewOfKind:@"CDV"];//注册Decoration View
    
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero))
    {
        return;
    }
    if (!_isDelete)
    {
        if (self.itemArray.count > 0)
        {
            return;
        }
    }
    
    _isDelete = NO;
    self.draggedIndexPath = nil;
    self.finalIndexPath = nil;
    self.draggedCellFrame = CGRectZero;
    [self.itemArray removeAllObjects];
    [self.itemDictionary removeAllObjects];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right;
    CGFloat xValue = self.sectionInset.left;
    CGFloat yValue = self.sectionInset.top;
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < sectionCount; section ++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item ++)
        {
            if ((xValue + self.itemSize.width) > collectionViewWidth)
            {
                xValue = self.sectionInset.left;
                yValue += self.itemSize.height + self.minimumLineSpacing;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            attributes.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
            self.itemDictionary[indexPath] = attributes;
            [self.itemArray addObject:attributes];

            xValue += self.itemSize.width + self.minimumInteritemSpacing;
        }
    }
}

//返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize
{
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
   
    NSInteger totalItems = 0;
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++)
    {
        totalItems += [self.collectionView numberOfItemsInSection:i];
    }
    if (totalItems % 2 == 1)
    {
        totalItems = totalItems + 1;
    }
    NSInteger rows = ceil((CGFloat)totalItems / self.numberOfItemsPerRow)-1;
    CGFloat height = (rows * (self.itemSize.height + self.minimumLineSpacing)) + self.sectionInset.top + self.sectionInset.bottom;
    
    return CGSizeMake(collectionViewWidth, height);
}

//返回rect中的所有的元素的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *elementArray = [NSMutableArray array];
    [[self.itemArray copy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attribute = (UICollectionViewLayoutAttributes *)obj;
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [self applyDragAttributes:attribute];
            //需要画分割线时调用
//            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:4 inSection:0];
//            [elementArray addObject:[self layoutAttributesForDecorationViewOfKind:@"CDV"atIndexPath:indexPath]];
            [elementArray addObject:attribute];
        }
    }];
    return elementArray;
}

//返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = self.itemDictionary[indexPath];
    if (!layoutAttributes)
    {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    [self applyDragAttributes:layoutAttributes];
    
    return layoutAttributes;
}

//触发collectionView所对应的layout的对应的动画
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [self.itemDictionary[itemIndexPath] copy];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [self.itemDictionary[itemIndexPath] copy];
    return attributes;
}

//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (!CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size))
    {
        [self.itemArray removeAllObjects];
        return YES;
    }
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop)
    {
        switch (updateItem.updateAction)
        {
            case UICollectionUpdateActionInsert:
            {
                [self insertItemAtIndexPath:updateItem.indexPathAfterUpdate];
                break;
            }
            case UICollectionUpdateActionDelete:
            case UICollectionUpdateActionMove:
            case UICollectionUpdateActionNone:
            case UICollectionUpdateActionReload:
            default:
                break;
        }
    }];
}

//需要画分割线时调用
//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes* att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
//    
//    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//    
//    NSInteger i = kScreenWidth/attributes.size.width;
//    
//    CGFloat height;
//    if (self.itemArray.count%i == 0)
//    {
//        height = (self.itemArray.count/i)*(kScreenWidth/i);
//    }else{
//        height = ((self.itemArray.count/i)+1)*(kScreenWidth/i);
//    }
//    
//    if (height != _height)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
//    }
//    att.frame=CGRectMake(0, 0, kScreenWidth, height);
//    _height = height;
//    att.zIndex=-1;
//    
//    return att;
//}

#pragma mark -
#pragma mark   set & Get
- (NSInteger)numberOfItemsPerRow
{
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right - self.sectionInset.left;
    NSInteger numberOfItems = collectionViewWidth / (self.itemSize.width + self.minimumInteritemSpacing);
    return numberOfItems;
}

#pragma mark -
#pragma mark Drag and Drop methods
- (void)resetDragging
{
    UICollectionViewLayoutAttributes *attributes = self.itemDictionary[self.draggedIndexPath];
    attributes.frame = self.draggedCellFrame;
   
    if (_endDragCanBlock)
    {
        //结束拖拽，且更换位置时回调
        self.endBlock(self.finalIndexPath);
    }
    _endDragCanBlock = NO;
    self.finalIndexPath = nil;
    self.draggedIndexPath = nil;
    
    self.draggedCellFrame = CGRectZero;
    [UIView animateWithDuration:0.2 animations:^{
        [self invalidateLayout];
    }];
}

- (void)resetLayoutFrames
{
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right;
    
    CGFloat xValue = self.sectionInset.left;
    CGFloat yValue = self.sectionInset.top;
    for (NSInteger i = 0; i < self.itemArray.count; i++)
    {
        UICollectionViewLayoutAttributes *attributes = self.itemArray[i];
        
        if ((xValue + self.itemSize.width) > collectionViewWidth)
        {
            xValue = self.sectionInset.left;
            yValue += self.itemSize.height + self.minimumLineSpacing;
        }
        attributes.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
        xValue += self.itemSize.width + self.minimumInteritemSpacing;
    }
}

- (void)applyDragAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([layoutAttributes.indexPath isEqual:self.draggedIndexPath])
    {
        layoutAttributes.transform = CGAffineTransformMakeScale(1.2, 1.2);
        layoutAttributes.center = self.draggedCellCenter;
        layoutAttributes.zIndex = 1024;
        layoutAttributes.alpha = 0.8;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            layoutAttributes.transform = CGAffineTransformIdentity;
        }];
        layoutAttributes.zIndex = 0;
        layoutAttributes.alpha = 1.0;
    }
}

- (void)setDraggedCellCenter:(CGPoint)draggedCellCenter
{
    _draggedCellCenter = draggedCellCenter;
    //在需要更新layout调用
    [self invalidateLayout];
}

- (void)insertDraggedItemAtIndexPath:(NSIndexPath *)intersectPath
{
    UICollectionViewLayoutAttributes *draggedAttributes = self.itemDictionary[self.draggedIndexPath];
    UICollectionViewLayoutAttributes *intersectAttributes = self.itemDictionary[intersectPath];
    
    NSUInteger draggedIndex = [self.itemArray indexOfObject:draggedAttributes];
    NSUInteger intersectIndex = [self.itemArray indexOfObject:intersectAttributes];
    
    [self.itemArray removeObjectAtIndex:draggedIndex];
    [self.itemArray insertObject:draggedAttributes atIndex:intersectIndex];
    
    self.finalIndexPath = intersectPath;
    
    self.draggedCellFrame = intersectAttributes.frame;
    
    [self resetLayoutFrames];
    
    [UIView animateWithDuration:0.10 animations:^{
        [self invalidateLayout];
    }];
    
}

- (void)exchangeItemsIfNeeded
{
    NSIndexPath *intersectPath = [self indexPathBelowDraggedItemAtPoint:self.draggedCellCenter];
    UICollectionViewLayoutAttributes *attributes = self.itemDictionary[intersectPath];
    
    //_endDragCanBlock = NO;
    CGRect centerBox = CGRectMake(attributes.center.x - 30, attributes.center.y - 30, 30 * 2, 30 * 2);
    if (intersectPath != nil && ![intersectPath isEqual:self.draggedIndexPath] && CGRectContainsPoint(centerBox, self.draggedCellCenter))
    {
        //是单元格在不能拖拽到最后两个位置
        if (_operateType == DemonOperateTypeDelete)
        {
            if (_itemArray.count-1 > intersectPath.row)
            {
                [self insertDraggedItemAtIndexPath:intersectPath];
            }
        }
        else
        {
            [self insertDraggedItemAtIndexPath:intersectPath];
        }
        _endDragCanBlock = YES;
    }
}

- (BOOL)isDraggingCell
{
    return self.draggedIndexPath != nil;
}

#pragma mark -
#pragma mark Helper Methods
- (NSIndexPath *)indexPathBelowDraggedItemAtPoint:(CGPoint)point
{
    __block NSIndexPath *indexPathBelow = nil;
    __weak typeof(self)weakSelf = self;
    [self.collectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        if ([self.draggedIndexPath isEqual:indexPath])
        {
            return;
        }
        UICollectionViewLayoutAttributes *attribute = weakSelf.itemDictionary[indexPath];
        
        CGRect centerBox = CGRectMake(attribute.center.x - 30, attribute.center.y - 30, 30 * 2, 30 * 2);
        if (CGRectContainsPoint(centerBox, weakSelf.draggedCellCenter))
        {
            indexPathBelow = indexPath;
            *stop = YES;
        }
    }];
    return indexPathBelow;
}

- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *prevAttributes = self.itemArray[indexPath.row - 1];
    
    CGFloat xValue = CGRectGetMaxX(prevAttributes.frame) + self.minimumInteritemSpacing;
    CGFloat yValue = CGRectGetMinY(prevAttributes.frame);
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right;
    if ((xValue + self.itemSize.width) > collectionViewWidth)
    {
        xValue = self.sectionInset.left;
        yValue += self.itemSize.height + self.minimumLineSpacing;
    }
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    attributes.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
    
    self.itemDictionary[indexPath] = attributes;
    [self.itemArray addObject:attributes];
}

@end
