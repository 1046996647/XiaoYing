//
 
#import <UIKit/UIKit.h>
#import "MoveHeader.h"
@interface WJXCollectionView : UICollectionView

@property (nonatomic, strong)NSArray *PermissionsArray;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                     withData:(NSArray *)dataArray
                  operateType:(DemonOperateType)operateType
                   localBlock:(DelectBtnBlock)localBlock
                 moveEndBlock:(MoveEndBlock)moveEndBlock
             selectedBtnBlock:(SelectedBtnBlock)selectedBtnBlock;


@end
