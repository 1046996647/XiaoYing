//
 
#import "WJXCollectionView.h"
#import "PermissionOfWork.h"
static NSString *const kidentify = @"kxietefuckIdentify";
static NSString *const kHeaderViewIdentifier = @"CollectionViewHeader";/**<九宫格headerView 标示*/
@interface WJXCollectionView ()<WJXDraggableCollectionViewCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,copy) DelectBtnBlock delectBtnBlock;
@property(nonatomic,copy) MoveEndBlock moveEndBlock;
@property(nonatomic,copy) SelectedBtnBlock selectedBtnBlock;
@property(nonatomic,copy) NSMutableArray *dataArray;
@property(nonatomic,assign) DemonOperateType operateType;
@property(nonatomic,strong) ZoomInView *zoomInView;
@property(nonatomic,assign) BOOL isEdit;
@property(nonatomic,strong) UIImageView *headerImageView;

@property (nonatomic, strong)PermissionOfWork *model;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *nameArray;
@property (nonatomic, strong)NSMutableArray *enableArray;
@end

@implementation WJXCollectionView
{
    FCollectionViewCell *_fccell;/**<记录按钮*/
    CGPoint _endCenterPoint;/**<记录抛物线结束点*/
    CGPoint _beginCenterPoint;/**<记录起始点*/
    FCollectionViewCell *cocell;/**<记录移动*/
    FCollectionViewCell *deleCell; /**<记录删除*/
    
    NSArray *arrdata1234;
}

#pragma mark -
#pragma mark life Cycle

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                     withData:(NSArray *)dataArray
                  operateType:(DemonOperateType)operateType
                   localBlock:(DelectBtnBlock)localBlock
                 moveEndBlock:(MoveEndBlock)moveEndBlock
             selectedBtnBlock:(SelectedBtnBlock)selectedBtnBlock
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        _delectBtnBlock = localBlock;
        _moveEndBlock  = moveEndBlock;
        _selectedBtnBlock = selectedBtnBlock;
        _dataArray = dataArray.mutableCopy;
        _operateType = operateType;
        
        [self setStep];
        
    }
    return self;
}

#pragma mark -
#pragma mark Private Method
- (void)setStep
{
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[FCollectionViewCell class] forCellWithReuseIdentifier:kidentify];
//    [self initDataOfPicture];

}


- (void)initDataOfPicture {

    _photoArray = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    _enableArray = [NSMutableArray array];

    if (_PermissionsArray.count > 0) {
        for (int i = 0; i < _dataArray.count; i++) {
            for (PermissionOfWork *model in _PermissionsArray) {
                if ([_dataArray[i][@"titleName"] isEqualToString:model.Name]) {
                    
                    [_nameArray addObject:model.Name];
                    [_enableArray addObject:model.Enable];
                    if ([model.Enable isEqual:@1]) {
                        [_photoArray addObject:_dataArray[i][@"imgName"][@"1"]];
                    }else {
                        [_photoArray addObject:_dataArray[i][@"imgName"][@"0"]];
                    }
                    break;
                }
            }
        }
    }
    else {

        for (int i = 0; i < _dataArray.count-1; i++) {

            [_nameArray addObject:_dataArray[i][@"titleName"]];
            [_enableArray addObject:@1];
            [_photoArray addObject:_dataArray[i][@"imgName"][@"1"]];
        }
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    [self initDataOfPicture];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoArray.count;
//    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FCollectionViewCell *cell = (FCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kidentify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.draggingDelegate = self;
    cell.operatype = _operateType;
    

    cell.imageName = _photoArray[indexPath.row];
    cell.lab1.text = _nameArray[indexPath.row];
    cell.iconImage.hidden = NO;
    
    cell.hidden = NO;
    cell.alpha = 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FCollectionViewCell *fccell = (FCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
    //判断视图是否为编辑状态
    if (self.isEdit)
    {
        //如果是编辑状态且 点击的是更多按钮 则退出编辑状态，隐藏出现在cell上按钮
        if (indexPath.row == _dataArray.count-1)
        {
            if (_fccell != nil)
            {
                if (_fccell.deleButton.alpha == 1)
                {
                    [_fccell.deleButton setAlpha:0];
                    _fccell.iconImage.alpha = 1;
                    self.isEdit = NO;
                }
                return;
            }
        }
        else
        {
        
            //如果不是点击的更多按钮
            if (_fccell != nil)
            {
                //则判断是否与上次编辑的按钮是否相同 不同则更换编辑按钮
                if (_fccell != fccell)
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        _fccell.deleButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
                        _fccell.deleButton.alpha = 0;
                        _fccell.iconImage.alpha = 1;
                    }];
                    
                    //清空编辑按钮,并推出编辑状态
                    self.isEdit = NO;
                    _fccell = nil;
                }
                else
                {
                    //相同则退出编辑状态 并将记录的编辑按钮置空
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        fccell.deleButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
                        fccell.deleButton.alpha = 0;
                        fccell.iconImage.alpha = 1;
                    }];
                    
                    self.isEdit = NO;
                    _fccell = nil;
                }
            }
        }
    }
    else
    {
        
        if ([_enableArray[indexPath.row] isEqual:@1]) {
            NSString *selectTitle = _nameArray[indexPath.row];
            _selectedBtnBlock(indexPath, selectTitle);
        }else {
            _selectedBtnBlock(nil, nil);
        }
        
    }
}

#pragma mark -
#pragma mark WJXDraggableCollectionViewCellDelegate
- (void)userDidBeginDraggingCell:(UICollectionViewCell *)cell
{
    if (self.isEdit)
    {
        cocell = (FCollectionViewCell *)cell;
        
        DragAndDropCollectionViewLayout *flowLayout = (DragAndDropCollectionViewLayout *)self.collectionViewLayout;
        flowLayout.draggedIndexPath = [self indexPathForCell:cell];
        flowLayout.draggedCellFrame = cell.frame;
        
        _beginCenterPoint = cell.center;
        NSIndexPath *beginIndexPath = [self indexPathForCell:cell];
        
        flowLayout.endBlock = ^(NSIndexPath *obj)
        {
            self.isEdit = NO;
            [self performSelector:@selector(doReloadData) withObject:nil afterDelay:0.4];
            if (obj.row < _dataArray.count && obj!=nil&&[self canMoveDataCell:cell])
            {
                self.moveEndBlock(beginIndexPath,obj);
                //交换数据
                NSDictionary *dic = _dataArray[beginIndexPath.row];
                [_dataArray removeObjectAtIndex:beginIndexPath.row];
                [_dataArray insertObject:dic atIndex:obj.row];
            }
        };
    }
}

- (void)doReloadData
{
    cocell.deleButton.alpha = 0;
    cocell.iconImage.alpha = 1;
    [self reloadData];
}

//判断是否达到交换位置的条件
- (BOOL)canMoveDataCell:(UICollectionViewCell *)cell
{
    CGFloat resultY = fabs(_endCenterPoint.y-_beginCenterPoint.y)-45.5f;
    CGFloat resultX = fabs(_endCenterPoint.x-_beginCenterPoint.x)-45.5f;
    
    if (resultY>0.f||resultX>0.f)
    {
        return YES;
    }
    return NO;
}

- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell
{
    DragAndDropCollectionViewLayout *flowLayout = (DragAndDropCollectionViewLayout *)self.collectionViewLayout;
    _endCenterPoint = flowLayout.draggedCellCenter;
    [flowLayout resetDragging];
}

- (void)userDidDragCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if (self.isEdit)
    {
        DragAndDropCollectionViewLayout *flowLayout = (DragAndDropCollectionViewLayout *)self.collectionViewLayout;
        CGPoint translation = [recognizer translationInView:self];
        CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                        recognizer.view.center.y + translation.y);
        
        flowLayout.draggedCellCenter = newCenter;
        [recognizer setTranslation:CGPointZero inView:self];
        
        [flowLayout exchangeItemsIfNeeded];
        
        UICollectionViewCell *draggedCell = [self cellForItemAtIndexPath:flowLayout.draggedIndexPath];
        [self scrollIfNeededWhileDraggingCell:draggedCell];
    }
}

- (BOOL)userCanDragCell:(UICollectionViewCell *)cell
{
    if (_operateType == DemonOperateTypeDelete)
    {
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        if (indexPath.row == _dataArray.count-1)
        {
            return NO;
        }
    }
    return YES;
}

/**<删除cell调用的协议*/
- (void)delectCell:(UICollectionViewCell *)cell
{
    DragAndDropCollectionViewLayout *flowLayout = (DragAndDropCollectionViewLayout *)self.collectionViewLayout;
    flowLayout.isDelete = YES;
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    FCollectionViewCell *cell1 = (FCollectionViewCell *)cell;
    self.isEdit = NO;
    switch (_operateType)
    {
        case DemonOperateTypeDelete:
        {
            CGRect frame = [self convertRect:cell.frame toView:self.window];
            self.zoomInView.frame = frame;
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath1];
            
            CGPoint toPoint = [self changeToPoint:attributes.center];
            self.zoomInView.toPoint = toPoint;
            
            self.zoomInView.image = cell1.iconImage.image;
            [self.window addSubview:self.zoomInView];
            cell1.alpha = 1;
            cell1.hidden = YES;
            cell1.iconImage.alpha = 1;
            
            __block typeof(self)blockSelf = self;
            self.zoomInView.fuckOff = ^()
            {
                [blockSelf.dataArray removeObjectAtIndex:indexPath.row];
                [blockSelf deleteItemsAtIndexPaths:@[indexPath]];
                [blockSelf reloadData];
            };
            break;
        }
        case DemonOperateTypeAdd:
        {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [self deleteItemsAtIndexPaths:@[indexPath]];
            [self reloadData];
            break;
        }
    }
    self.delectBtnBlock(indexPath);
}

//转换目地点的坐标
- (CGPoint)changeToPoint:(CGPoint)point
{
    CGPoint toPoint = [self convertPoint:point toView:self.window];
    
    if (kScreenHeight-64.f<toPoint.y)
    {
        return  CGPointMake(toPoint.x, kScreenHeight-64.f);
    }
    return toPoint;
}


- (void)longGestureCell:(UICollectionViewCell *)cell withGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    FCollectionViewCell *fccell =(FCollectionViewCell *) cell;
    
    //判断是否是编辑状态
    if (!self.isEdit)
    {
        //如果不是编辑状态 设置为编辑状态，并开始编辑状态， 展现cell上的视图
        self.isEdit = YES;
        //按钮出现的动画
        fccell.deleButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [UIView animateWithDuration:0.3 animations:^{
            
            fccell.deleButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
            fccell.deleButton.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    fccell.deleButton.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }];
        //将出现按钮的视图记录
        _fccell = fccell;
    }
    else
    {
        //如果是编辑状态，且有按钮的视图出现 判断是否点击的是否为同一个按钮
        if (_fccell != nil)
        {
            if (fccell != _fccell)
            {
                [_fccell.deleButton setAlpha:0];
                _fccell.iconImage.alpha = 1;
                
                fccell.deleButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
                [UIView animateWithDuration:0.3 animations:^{
                    
                    fccell.deleButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    fccell.deleButton.alpha = 1;
                } completion:^(BOOL finished) {
                    
                    if (finished)
                    {
                        [UIView animateWithDuration:0.3 animations:^{
                            fccell.deleButton.transform = CGAffineTransformMakeScale(1, 1);
                        }];
                    }
                }];
                _fccell = fccell;
            }
            else
            {
                //如果是同一个按钮则退出编辑状态
                [UIView animateWithDuration:0.5 animations:^{
                    
                    fccell.deleButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
                    fccell.deleButton.alpha = 0;
                    fccell.iconImage.alpha = 1;
                }];
                //退出编辑状态
                self.isEdit = NO;
                //将记录的按钮置空
                _fccell = nil;
            }
        }
        
    }
}

#pragma mark -
#pragma mark Helper Methods
- (void)scrollIfNeededWhileDraggingCell:(UICollectionViewCell *)cell
{
    
    if (self.isEdit)
    {
        DragAndDropCollectionViewLayout *flowLayout = (DragAndDropCollectionViewLayout *)self.collectionViewLayout;
        if (![flowLayout isDraggingCell])
        {
            return;
        }
        
        CGPoint cellCenter = flowLayout.draggedCellCenter;
        
        CGPoint newOffset = self.contentOffset;
        CGFloat buffer = 10;
        
        CGFloat bottomY = self.contentOffset.y + CGRectGetHeight(self.frame);
        if (bottomY < CGRectGetMaxY(cell.frame) - buffer)
        {
            newOffset.y += 1;
            if (newOffset.y + CGRectGetHeight(self.bounds) > self.contentSize.height)
            {
                return;
            }
            cellCenter.y += 1;
        }
        
        CGFloat offsetY = self.contentOffset.y;
        if (CGRectGetMinY(cell.frame) + buffer < offsetY)
        {
            newOffset.y -= 1;
            if (newOffset.y <= 0)
            {
                return;
            }
            cellCenter.y -= 1;
        }
        
        self.contentOffset = newOffset;
        flowLayout.draggedCellCenter = cellCenter;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollIfNeededWhileDraggingCell:cell];
        });
        
    }
}

#pragma mark -
#pragma mark get & set
- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView=[[UIImageView alloc]init];
        _headerImageView.contentMode=UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds=YES;
        _headerImageView.frame=CGRectMake(0, 0, self.frame.size.width, 200);
        _headerImageView.image=[UIImage imageNamed:@"lifeHeader.png"];
    }
    return _headerImageView;
}

- (ZoomInView *)zoomInView
{
    if (!_zoomInView)
    {
        _zoomInView = [[ZoomInView alloc] init];
    }
    return _zoomInView;
}


- (void)setPermissionsArray:(NSArray *)PermissionsArray {
    _PermissionsArray = PermissionsArray;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
}

@end
