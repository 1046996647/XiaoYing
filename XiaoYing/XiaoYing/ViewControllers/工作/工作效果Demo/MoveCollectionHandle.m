//
 
#import "MoveCollectionHandle.h"
@interface MoveCollectionHandle()
@end

@implementation MoveCollectionHandle

+ (WJXCollectionView *)MoveCollectionHandle:(UIViewController *)sender
                                   withView:(UIView *)view
                                   withData:(NSArray *)dataArray
                                  withFrame:(CGRect)frame
                                 numOfItems:(NSInteger)number
                                OperateType:(DemonOperateType)operateType
                             DelectBtnBlock:(DelectBtnBlock)DelectBtnBlock
                               moveEndBlock:(MoveEndBlock)moveEndBlock
                           selectedBtnBlock:(SelectedBtnBlock)selectedBtnBlock
{
    DragAndDropCollectionViewLayout *flowLayout = [[DragAndDropCollectionViewLayout alloc] initWithOperaType:operateType];
    ;
    
    flowLayout.itemSize = CGSizeMake((kScreenWidth-number*1.0f)/number, (kScreenWidth-number*1.0f)/number);
    flowLayout.minimumInteritemSpacing =1 ;
    flowLayout.minimumLineSpacing = 1;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 1 ,1, 0);

    switch (operateType)
    {
        case DemonOperateTypeAdd:
        {
            WJXCollectionView *collectionView = [[WJXCollectionView alloc] initWithFrame:frame
                                                                    collectionViewLayout:flowLayout
                                                                                withData:dataArray
                                                                             operateType:DemonOperateTypeAdd
                                                                              localBlock:DelectBtnBlock
                                                                            moveEndBlock:moveEndBlock
                                                                        selectedBtnBlock:selectedBtnBlock];
            
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            collectionView.layer.shadowOffset = CGSizeMake(-1, 0);
            collectionView.layer.shadowOpacity = 0.5;
            [view addSubview:collectionView];
            
            return collectionView;
        }
        case DemonOperateTypeDelete:
        {
            WJXCollectionView *collectionView = [[WJXCollectionView alloc] initWithFrame:frame
                                                                    collectionViewLayout:flowLayout
                                                                                withData:dataArray
                                                                             operateType:DemonOperateTypeDelete
                                                                              localBlock:DelectBtnBlock
                                                                            moveEndBlock:moveEndBlock
                                                                        selectedBtnBlock:selectedBtnBlock];
            
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            collectionView.layer.shadowOffset = CGSizeMake(-1, 0);
            collectionView.layer.shadowOpacity = 0.5;
            [view addSubview:collectionView];

            return collectionView;
        }
    }
    return nil;
}


@end
