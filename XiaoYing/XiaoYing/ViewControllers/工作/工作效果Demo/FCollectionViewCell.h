//
//  FCollectionViewCell.h

#import <UIKit/UIKit.h>
#import "MoveHeader.h"
@protocol WJXDraggableCollectionViewCellDelegate <NSObject>

@optional

/**
 *
 *
 *  单元格式否能拖拽
 *
 *  @param cell 用户长按的单元格
 *
 *  @return BOOL
 */
- (BOOL)userCanDragCell:(UICollectionViewCell *)cell;


/**
 *
 *
 *  单元格开始拖拽
 *
 *  @param cell 用户拖拽的按元格
 */
- (void)userDidBeginDraggingCell:(UICollectionViewCell *)cell;


/**
 *
 *
 *  拖拽单元格
 *
 *  @param cell 用户拖拽的按元格
 */
- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell;

/**
 *
 *
 *  用户拖拽单元格
 *
 *  @param cell       用户拖拽的按元格
 *  @param recognizer 平移手势
 */
- (void)userDidDragCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer;


/**
 *
 *
 *  点击删除按钮调用
 *
 *  @param cell 用户要删除的单元格
 */
- (void)delectCell:(UICollectionViewCell *)cell;

/**
 *   
 *
 *  用户长按单元格
 *
 *  @param cell       用户长按的单元格
 *  @param recognizer 长按手势
 */
- (void)longGestureCell:(UICollectionViewCell *)cell withGestureRecognizer:(UILongPressGestureRecognizer *)recognizer;

@end


@interface FCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<WJXDraggableCollectionViewCellDelegate> draggingDelegate;
@property(nonatomic,strong) UIButton *deleButton;
@property(nonatomic,strong) UIImageView *iconImage;
 
 
@property(nonatomic,assign) DemonOperateType operatype;
@property(nonatomic,strong) UILabel *lab1;

@property(nonatomic,copy) NSString *imageName;

@end
