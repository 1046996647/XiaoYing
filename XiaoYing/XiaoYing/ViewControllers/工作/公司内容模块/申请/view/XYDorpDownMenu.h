//
//  XYDorpDownMenu.h
//  XYDropDownListDemo
//
//  Created by ZWL on 16/1/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYDorpDownMenu;

@protocol XYDropDownMenuDelegate <NSObject>

- (void)XYDropDownMenu:(XYDorpDownMenu *)menu didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XYDorpDownMenu : UIView

/**
 *  使用数剧初始化
 *
 *  @param frame      大小
 *  @param MenuTitle  菜单名称
 *  @param dataSource 菜单选项数据
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                    MenuTitle:(NSString *)title
                   DataSource:(NSArray *)dataSource;

#pragma mark - Other Property
@property (nonatomic, readonly, strong) NSArray *dataSource;
@property (nonatomic, weak) id<XYDropDownMenuDelegate> delegate;
@property (nonatomic, copy) NSString *selectedString;
@property (nonatomic, strong) UIColor *sectionColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *placeholderColor;

#pragma mark - MenuItem Property
@property (nonatomic, strong) UIColor *separationLineColor;
@property (nonatomic, assign) UIEdgeInsets separationLineInsets;
@property (nonatomic, strong) UIColor *meneItemTextColor;
@property (nonatomic, strong) UIFont *meneItemTextFont;
@property (nonatomic, strong) UIColor *menuItemBackgroundColor;

@end
