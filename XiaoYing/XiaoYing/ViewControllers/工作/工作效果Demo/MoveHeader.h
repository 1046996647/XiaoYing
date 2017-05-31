//
//  MoveHeader.h
 

#ifndef RecollectionView_MoveHeader_h
#define RecollectionView_MoveHeader_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

typedef void (^DelectBtnBlock)(NSIndexPath *indexPath);/**<按钮点击调用*/
typedef void (^MoveEndBlock)(NSIndexPath *beginIndex,NSIndexPath *endIndex);/**<移动结束调用*/
typedef void (^SelectedBtnBlock)(NSIndexPath *selectedIndex, NSString *selectedTltle);/**<单元点击调用*/
typedef void (^AddBtnBlock)(NSDictionary *addDictionary);/**<添加调用*/
typedef NS_ENUM(NSUInteger, DemonOperateType)
{
    DemonOperateTypeAdd,/**<添加界面*/
    DemonOperateTypeDelete,/**<删除界面*/
};

#endif

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

#import "DragAndDropCollectionViewLayout.h"
#import "WJXCollectionView.h"
#import "FCollectionViewCell.h"
#import "MoveCollectionHandle.h"
#import "MoreViewController.h"
#import "DrawSquareView.h"
#import "ZoomInView.h"
