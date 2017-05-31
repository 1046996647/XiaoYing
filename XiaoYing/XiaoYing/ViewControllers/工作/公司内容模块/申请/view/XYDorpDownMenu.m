//
//  XYDorpDownMenu.m
//  XYDropDownListDemo
//
//  Created by ZWL on 16/1/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYDorpDownMenu.h"
#import "LSPaoMaView.h"

@interface XYDorpDownMenu () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *_menuTitle; //提示的文字
    UIButton *_clickStartBtn; //点击该按钮，展示列表
    UIImageView *_clickStartTip;
    UILabel *_menuTitleLab; //提示的文字的UILabel
    
    //跑马灯效果的view
    LSPaoMaView *_menuTitlePaoMaView;
    
    NSArray *_tempDataSource;  //列表中显示的文字组
    CGRect _headViewFrame;
    UIView *_backgroundView;
}

@property (nonatomic, readwrite, strong) NSArray *dataSource; //列表中显示的文字组

@end

@implementation XYDorpDownMenu
@synthesize selectedString = _selectedString; //CCH

- (NSString *)selectedString //CCH
{
    if (!_selectedString) {
        _selectedString = [[NSString alloc] init];
        
        if (self.dataSource.count > 0) {
            _selectedString = self.dataSource.firstObject;
        }
    }
    return _selectedString;
}

- (void)setSelectedString:(NSString *)selectedString //CCH
{
    _selectedString = selectedString;
    _menuTitleLab.text =  _selectedString;
    _menuTitleLab.textColor = [UIColor blackColor];

}

#pragma mark - LifeCycle
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
                   DataSource:(NSArray *)dataSource {
    if (self = [super initWithFrame:frame]) {
        _headViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _menuTitle = title;
        _dataSource = dataSource;
        [self setupContent]; //CCH
        _tempDataSource = [[NSArray alloc] initWithArray:_dataSource copyItems:YES];
        _dataSource = nil;
        [self p_createSubviews];
        
    }
    return self;
}

- (void)setupContent //CCH
{
    _menuTitle = (self.dataSource.count > 0)? self.selectedString : _menuTitle;
    if (self.dataSource.count > 0) {
        _menuTitleLab.textColor = [UIColor blackColor];
    }
}

/**
 *  默认初始化屏蔽
 *
 *  @return nil
 */
- (instancetype)init {
    NSAssert(true, @"请输入菜单数据参数");
    return nil;
}

/**
 *  默认初始化屏蔽
 *
 *  @param frame
 *
 *  @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(true, @"请输入菜单数据参数");
    return nil;
}

// 添加手势,点击空白处移除视图
- (void)tapAction
{
    _clickStartBtn.selected = NO;
    [self p_showCloseMenuView];
}

#pragma mark - SubViews
/**
 *  创建子视图
 */
- (void)p_createSubviews {
    // 点击展开按钮
    _clickStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickStartBtn.frame = CGRectMake(0, 0, _headViewFrame.size.width, _headViewFrame.size.height);
    [_clickStartBtn addTarget:self action:@selector(clickToStartAction:) forControlEvents:UIControlEventTouchUpInside];
    _clickStartBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_clickStartBtn];
    
    // 菜单名字
    _menuTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _headViewFrame.size.width - 25, _headViewFrame.size.height)];
    _menuTitleLab.text = _menuTitle;
    _menuTitleLab.backgroundColor = [UIColor clearColor];
    [_clickStartBtn addSubview:_menuTitleLab];
    
    // 跑马灯效果
    _menuTitlePaoMaView = [[LSPaoMaView alloc] initWithFrame:_menuTitleLab.frame title:_menuTitleLab.text];
    _menuTitlePaoMaView.userInteractionEnabled = NO;
    [_clickStartBtn addSubview:_menuTitlePaoMaView];
    
    //使用KVO
    [_menuTitleLab addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    // 三角形按钮
    _clickStartTip = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 5 - 10.5, _headViewFrame.size.height - 8 - 10.5, 10.5, 10.5)];
    _clickStartTip.image = [UIImage imageNamed:@"opinion_read"];
    [_clickStartBtn addSubview:_clickStartTip];
    
    // 线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _headViewFrame.size.height, _headViewFrame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self addSubview:lineView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor blackColor];
    [self addSubview:_tableView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [_menuTitlePaoMaView removeFromSuperview];
    _menuTitlePaoMaView = nil;
    _menuTitlePaoMaView = [[LSPaoMaView alloc] initWithFrame:_menuTitleLab.frame title:_menuTitleLab.text];
    _menuTitlePaoMaView.userInteractionEnabled = NO;
    [_clickStartBtn addSubview:_menuTitlePaoMaView];
}

#pragma mark - ShowViews
/**
 *  显示展开的视图
 */
- (void)p_showOpenMenuView {
    // 黑色背景
    CGRect rect = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    //    rect = [self convertRect:rect fromView:self.superview];
    _backgroundView = [[UIView alloc] initWithFrame:rect];
    //    _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:_backgroundView];
    
    // 添加手势,点击空白处移除视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_backgroundView addGestureRecognizer:tap];
    
    _dataSource = [[NSArray alloc] initWithArray:_tempDataSource copyItems:YES];
    CGFloat rows = _dataSource.count;
    if (_dataSource.count > 6) {
        rows = 6;
    }
    CGRect frame = self.frame;
    frame.size.height += rows * 40;
    self.frame = frame;
    _tableView.frame = CGRectMake(0, _headViewFrame.size.height, _headViewFrame.size.width, rows * 40);
    _clickStartTip.image = [UIImage imageNamed:@"opinion_reading"];
    [_tableView reloadData];
    UIView *view = self.superview;
    [view addSubview:self];
}

/**
 *  显示收起的视图
 */
- (void)p_showCloseMenuView {
    [_backgroundView removeFromSuperview];
    
    CGFloat rows = _dataSource.count;
    if (_dataSource.count > 6) {
        rows = 6;
    }
    CGRect frame = self.frame;
    frame.size.height -= rows * 40;
    self.frame = frame;
    _tableView.frame = CGRectZero;
    _clickStartTip.image = [UIImage imageNamed:@"opinion_read"];
    _dataSource = nil;
    [_tableView reloadData];
}

#pragma mark - Setter
/**
 *  设置背景颜色
 *
 *  @param color
 */
- (void)setMenuItemBackgroundColor:(UIColor *)menuItemBackgroundColor {
    _menuItemBackgroundColor = menuItemBackgroundColor;
    _tableView.backgroundColor = _menuItemBackgroundColor;
}

- (void)setSectionColor:(UIColor *)sectionColor {
    _sectionColor = sectionColor;
    //_clickStartBtn.backgroundColor = _sectionColor;
}

/**
 *  设置分割线颜色
 *
 *  @param separationLineColor
 */
- (void)setSeparationLineColor:(UIColor *)separationLineColor {
    _separationLineColor = separationLineColor;
    _tableView.separatorColor = _separationLineColor;
}

/**
 *  字体大小
 *
 *  @param font
 */
- (void)setFont:(UIFont *)font {
    _font = font;
    _menuTitleLab.font = _font;
}

/**
 *  默认颜色
 *
 *  @param placeholderColor
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _menuTitleLab.textColor = placeholderColor;
}

#pragma mark - ButtonAction
/**
 *  点击展开按钮事件
 *
 *  @param btn
 */
- (void)clickToStartAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self p_showOpenMenuView];
    } else {
        [self p_showCloseMenuView];
    }
}

#pragma mark - UITableViewDataSource
// 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, cell.size.width, cell.size.height)];
    label.text = _dataSource[indexPath.row];
    // 字体
    if (_meneItemTextFont) {
        label.font = _meneItemTextFont;
    } else {
        label.font = [UIFont systemFontOfSize:10];
    }
    // 字体颜色
    if (_meneItemTextColor) {
        label.textColor = _meneItemTextColor;
    } else {
        label.textColor = [UIColor blackColor];
    }
    label.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark - UITableViewDelegate
/**
 *  调整分割线位置
 *
 *  @param tableView
 *  @param cell
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:_separationLineInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:_separationLineInsets];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

// 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _menuTitleLab.text = _tempDataSource[indexPath.row];
    _selectedString = _menuTitleLab.text;
    [_delegate XYDropDownMenu:self didSelectAtIndexPath:indexPath];
    _clickStartBtn.selected = NO;
    [self p_showCloseMenuView];
    _menuTitleLab.textColor = [UIColor blackColor];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [_menuTitleLab removeObserver:self forKeyPath:@"text"];
}

@end
