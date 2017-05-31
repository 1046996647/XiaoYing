//
//  PersonalCardMyCell.h
//  
//
//  Created by GZH on 2016/12/22.
//
//

#import <UIKit/UIKit.h>
@class PersonalCardModel;
@class InfoModel;
@interface PersonalCardMyCell : UITableViewCell



//个人名片
- (void)getModel:(PersonalCardModel *)model andIndex:(NSInteger)index;

//企业名片
- (void)getModelOfCompanyCard:(InfoModel*)model andIndexPath:(NSIndexPath *)indexPath;
@end
