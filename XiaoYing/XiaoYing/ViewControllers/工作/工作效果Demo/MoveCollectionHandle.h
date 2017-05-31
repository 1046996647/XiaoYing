//
//  MoveCollectionHandle.h



#import <Foundation/Foundation.h>
#import "MoveHeader.h"

@interface MoveCollectionHandle : NSObject


/**
 *  
 *
 *  九宫格拖拽的类方法，长按后进行拖拽
 *
 *  @param sender           当前控制器
 *  @param view             九宫格的父视图
 *  @param dataArray        九宫格上需显示的数据
 *  @param frame            九宫格的frame
 *  @param number           每行放item的个数
 *  @param DelectBtnBlock   删除cell回调的方法
 *  @param moveEndBlock     移动视图回调的方法，根据回调值修改数据的顺序
 *  @param selectedBtnBlock 点击cell回调的block，根据回调值，做相应的处理*
 *  @return 九宫格视图（WJXCollectionView)
*/

+ (id)MoveCollectionHandle:(UIViewController *)sender
                  withView:(UIView *)view
                  withData:(NSArray *)dataArray
                 withFrame:(CGRect)frame
                numOfItems:(NSInteger)number
               OperateType:(DemonOperateType)operateType
            DelectBtnBlock:(DelectBtnBlock)DelectBtnBlock
              moveEndBlock:(MoveEndBlock)moveEndBlock
          selectedBtnBlock:(SelectedBtnBlock)selectedBtnBlock;
@end
