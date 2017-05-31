//
//  MoreViewController.h
//  RecollectionView
 

#import <UIKit/UIKit.h>
#import "MoveHeader.h"
#import "BaseSettingViewController.h"

@interface MoreViewController :BaseSettingViewController

- (instancetype)initWithNuberItems:(NSInteger)items;
@property(nonatomic,copy) AddBtnBlock addBlock;
@property(nonatomic,strong) NSDictionary *Datadic;
@end
