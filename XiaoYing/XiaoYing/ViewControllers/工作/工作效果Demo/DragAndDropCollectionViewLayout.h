//


#import <UIKit/UIKit.h>
#import "MoveHeader.h"
@interface DragAndDropCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *draggedIndexPath; /**<拖拽单元格的indexPath*/

@property (nonatomic) CGRect draggedCellFrame;/**<拖拽单元格的frame*/

@property (nonatomic, strong) NSIndexPath *finalIndexPath;/**<单元格拖拽之后的indexPath*/

@property(nonatomic,strong) NSIndexPath *endIndexPath;

@property(nonatomic,assign) BOOL isDelete;//是否是删除调用进来

@property (nonatomic) CGPoint draggedCellCenter;/**<拖拽的单元格的中心点*/

@property (nonatomic, readonly) BOOL isDraggingCell;/**<单元格是否能拖拽*/

@property(nonatomic,copy) void(^endBlock)(id endIndexPath);/**<停止拖拽调用的block*/

@property(nonatomic,assign) DemonOperateType operateType;/**<是添加还是删除*/
- (void)exchangeItemsIfNeeded;/**<当达到交换位置的条件*/

- (void)resetDragging;/**<拖拽重新调整*/

- (instancetype)initWithOperaType:(DemonOperateType)operateType;
@end
