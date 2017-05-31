//
//  NewApprovalVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/16.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "NewApplyVC.h"
#import "ApplyVC.h"
#import "XYDorpDownMenu.h"

#import "ImageCollectionView.h"
#import "AudioCell.h"
#import "D3RecordButton.h"

#import "ApplyViewModel.h"
#import "EmployeeViewModel.h"

#import "XYExtend.h"

#define MAX_TEXTFIELD_LENGTH 8
#define MAX_TEXTVIEW_LENGTH 800

@interface NewApplyVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, XYDropDownMenuDelegate,D3RecordDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scroll;                  // 背后用一个scroll为整体依托
    UIView *_backgroundView;                // 给一个父视图,方便下面所有视图移动
    UIView *_moneyBackgroundView;           // 给一个父视图,方便下面所有视图移动
    
    UITableView *_riverContentTab;          // 语音内容表视图
    UITextField *_moneyTextField;           // 输入金额

    UILabel *_identityLab;                  // 身份Lab
    UILabel *_typeLab;                      // 类型Lab
    UILabel *_kindLab;                      // 种类Lab
    UILabel *_moneyLab;                     // 金额Lab/天数Lab
    UILabel *_yuanLab;                      // 元Lab/天Lab
    
    UITextView *_tv;                        // 申请内容的主体版面
    UILabel *_remindLab;                    // 申请内容的主体版面的提示Label
    
    NSMutableArray *_voices;                // 语音model数组
    
    MBProgressHUD *_waitHUD;                 //waitHUD
    
}

@property (nonatomic, strong) NSArray *identityNameArray;  // 身份名字数组
@property (nonatomic, strong) NSArray *identityIdArray;  // 身份ID数组
@property (nonatomic, strong) XYDorpDownMenu *identityList;  // 身份选择按钮

@property (nonatomic, strong) NSArray *categoryNameArray;  // 类型名字数组
@property (nonatomic, strong) NSArray *categoryIdArray;  // 类型ID数组
@property (nonatomic, strong) XYDorpDownMenu *categoryList;  // 类型选择按钮

@property (nonatomic, strong) NSArray *typeNameArray;  // 种类名字数组
@property (nonatomic, strong) NSArray *typeIdArray;  // 种类ID数组
@property (nonatomic, strong) NSArray *tagTypeArray;  //种类tag数组
@property (nonatomic, strong) XYDorpDownMenu *typeList; // 种类选择按钮

@property (nonatomic, strong) UICollectionView *modelEssayCollectionView; // 范文collectionView
@property (nonatomic, strong) NSMutableDictionary *riverTemplateDic; // 范文数据数组
@property (nonatomic, strong) NSMutableArray *riverTemplateNames;  // 范文名字数组

@property (nonatomic, strong) UITableView *riverContentTab; // 语音内容表视图

@property (nonatomic,strong) D3RecordButton *recordButton; // 按住录音按钮
@property(nonatomic,strong) ImageCollectionView *pictureCollectonView; // 申请附带的图片展示

@end


@implementation NewApplyVC
@synthesize identityNameArray = _identityNameArray, categoryNameArray = _categoryNameArray, typeNameArray = _typeNameArray;

- (NSArray *)identityNameArray
{
    if (!_identityNameArray) {
        _identityNameArray = [[NSArray alloc] init];
    }
    return _identityNameArray;
}

- (void)setIdentityNameArray:(NSArray *)identityNameArray
{
    _identityNameArray = identityNameArray;
    [self.identityList removeFromSuperview];
    self.identityList = nil;
    [_scroll addSubview:self.identityList];
}

- (XYDorpDownMenu *)identityList
{
    if (!_identityList) {
        _identityList = [[XYDorpDownMenu alloc] initWithFrame:CGRectMake(58, 18, kScreen_Width - 65 - 15, 28) MenuTitle:@"点击选择身份" DataSource:self.identityNameArray];
        _identityList.font = [UIFont systemFontOfSize:14];
        _identityList.meneItemTextFont = [UIFont systemFontOfSize:14];
        _identityList.menuItemBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        _identityList.meneItemTextColor = [UIColor whiteColor];
        _identityList.delegate = self;
        _identityList.sectionColor = [UIColor whiteColor];
        _identityList.placeholderColor = [UIColor colorWithHexString:@"#d5d7dc"];
    }
    
    return _identityList;
}

- (NSArray *)categoryNameArray
{
    if (!_categoryNameArray) {
        _categoryNameArray = [[NSArray alloc] init];
    }
    return _categoryNameArray;
}

- (void)setCategoryNameArray:(NSArray *)categoryNameArray
{
    _categoryNameArray = categoryNameArray;
    [self.categoryList removeFromSuperview];
    self.categoryList = nil;
    [_scroll addSubview:self.categoryList];
}

- (XYDorpDownMenu *)categoryList
{
    if (!_categoryList) {
        _categoryList = [[XYDorpDownMenu alloc] initWithFrame:CGRectMake(58, (_identityLab.bottom +18), kScreen_Width - 65 - 15, 28) MenuTitle:@"请先选择身份" DataSource:self.categoryNameArray];
        _categoryList.font = [UIFont systemFontOfSize:14];
        _categoryList.meneItemTextFont = [UIFont systemFontOfSize:14];
        _categoryList.menuItemBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        _categoryList.meneItemTextColor = [UIColor whiteColor];
        _categoryList.delegate = self;
        _categoryList.sectionColor = [UIColor whiteColor];
        _categoryList.placeholderColor = [UIColor colorWithHexString:@"#d5d7dc"];
    }
    
    return _categoryList;
}

- (NSArray *)typeNameArray
{
    if (!_typeNameArray) {
        _typeNameArray = [[NSArray alloc] init];
    }
    return _typeNameArray;
}

- (void)setTypeNameArray:(NSArray *)typeNameArray
{
    _typeNameArray = typeNameArray;
    [self.typeList removeFromSuperview];
    self.typeList = nil;
    [_scroll addSubview:self.typeList];
}

- (XYDorpDownMenu *)typeList
{
    if (!_typeList) {
        _typeList = [[XYDorpDownMenu alloc] initWithFrame:CGRectMake(58, (_typeLab.bottom +18), kScreen_Width - 65 - 15, 28) MenuTitle:@"请先选择类型" DataSource:self.typeNameArray];
        _typeList.font = [UIFont systemFontOfSize:14];
        _typeList.meneItemTextFont = [UIFont systemFontOfSize:14];
        _typeList.menuItemBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        _typeList.meneItemTextColor = [UIColor whiteColor];
        _typeList.delegate = self;
        _typeList.sectionColor = [UIColor whiteColor];
        _typeList.placeholderColor = [UIColor colorWithHexString:@"#d5d7dc"];
    }
    
    return _typeList;
}

- (NSMutableDictionary *)riverTemplateDic
{
    if (!_riverTemplateDic) {
        _riverTemplateDic = [@{
                               @"报销范文" : @[@"请假原因", @"请假时间"],
                               @"差旅费范文" : @[@"报销原因", @"报销金额"],
                               @"报销范文1" : @[@"加班原因", @"加班时间"],
                               @"报销范文2" : @[@"加班原因", @"加班时间"],
                               @"报销范文3" : @[@"加班原因", @"加班时间"],
                               @"报销范文4" : @[@"加班原因", @"加班时间"],
                               @"报销范文5" : @[@"加班原因", @"加班时间"],
                               @"报销范文6" : @[@"加班原因", @"加班时间"],
                               @"报销范文7" : @[@"加班原因", @"加班时间"],
                               } mutableCopy];
    }
    return _riverTemplateDic;
}

- (NSMutableArray *)riverTemplateNames
{
    if (!_riverTemplateNames) {
        _riverTemplateNames = [NSMutableArray array];
        for (NSString *key in self.riverTemplateDic) {
            [_riverTemplateNames addObject:key];
        }
    }
    return _riverTemplateNames;
}

- (UITableView *)riverContentTab
{
    if (!_riverContentTab) {
        _riverContentTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 28, kScreen_Width - 24, _tv.height-28) style:UITableViewStylePlain];
        _riverContentTab.delegate=self;
        _riverContentTab.dataSource=self;
        _riverContentTab.hidden = YES;
        _riverContentTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _riverContentTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _riverContentTab;
}

- (D3RecordButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [D3RecordButton buttonWithType:UIButtonTypeCustom];
        _recordButton.backgroundColor = [UIColor redColor];
        _recordButton.frame = CGRectMake(_tv.left, _tv.bottom-.6, _tv.width, 44);
        _recordButton.layer.borderWidth = .6;
        _recordButton.layer.borderColor = [UIColor colorWithHexString:@"d5d7dc"].CGColor;
        [_recordButton initRecord:self maxtime:60 title:@"上滑取消录音"];
    }
    return _recordButton;
}

- (UICollectionView *)modelEssayCollectionView
{
    if (!_modelEssayCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreen_Width - 30) / 3, 30);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 10);
        
        _modelEssayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.pictureCollectonView.bottom+12, kScreen_Width, (self.riverTemplateDic.count / 3) * 40 ) collectionViewLayout:flowLayout];
        _modelEssayCollectionView.scrollEnabled = NO;
        _modelEssayCollectionView.delegate = self;
        _modelEssayCollectionView.dataSource = self;
        [_modelEssayCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"_riverTemplateBtnCell"];
    }
    return _modelEssayCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"[UserInfo getCompanyId]~~%@", [UserInfo getCompanyId]);
    
    self.navigationItem.title = @"新建申请";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationContent];
    
    [self setupViewContent];
    
    [self setupMonitor];
    
    // 语音对象数组
    _voices = [NSMutableArray array];
    
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 首先从服务器获取该用户的身份信息，即部门名称和部门ID
    [EmployeeViewModel getEmployeeMessageSuccess:^(NSArray *identityNameArray, NSArray *departmentIdArray, NSArray *departmentNameArray) {
        
        NSLog(@"该用户所属的部门名称:%@", identityNameArray);
        NSLog(@"该用户所属的部门ID:%@", departmentIdArray);
 
        self.identityNameArray = identityNameArray;
        self.identityIdArray = departmentIdArray;
        
        //waitHUD
        [_waitHUD hide:YES];

    }failed:^(NSError *error) {
        //waitHUD
        [_waitHUD hide:YES];
    }];
    
    
}

- (void)setupNavigationContent
{
    // 提交按钮
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(0, 0, 30, 30);
    [submit setTitle:@"提交" forState: UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:15];
    [submit sizeToFit];
    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submit];
}

- (void)setupMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCountNotificationAction:) name:@"imageCountNotificationAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_moneyTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:_tv];
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:@"UIKeyboardDidShowNotification" object:nil];
    //监听键盘关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:@"UIKeyboardDidHideNotification" object:nil];
    
}

- (void)submitAction:(UIButton *)btn
{
    NSLog(@"点击提交按钮");
    
    //点击保存时，确保键盘已经收起
    [self.view endEditing:YES];
    
    //______________________________________________________________________________
    if (self.identityList.selectedString == nil) {

        [MBProgressHUD showMessage:@"请选择身份"];
        return;
    }
    if (self.categoryList.selectedString == nil) {
        
        [MBProgressHUD showMessage:@"请选择类型"];
        return;
    }
    if (self.typeList.selectedString == nil) {
        
        [MBProgressHUD showMessage:@"请选择种类"];
        return;
    }
    if ([_moneyTextField.text isEqualToString:@""] && !_moneyBackgroundView.hidden) {
        
        [MBProgressHUD showMessage:@"请填写具体的金额/天数"];
        return;
    }
    if ([_tv.text isEqualToString:@""]) {
        
        [MBProgressHUD showMessage:@"请填写申请说明"];
        return;
    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    NSInteger identityNum = [self.identityNameArray indexOfObject:self.identityList.selectedString];
    NSInteger typeNum = [self.typeNameArray indexOfObject:self.typeList.selectedString];
    _moneyTextField.text = _moneyBackgroundView.hidden? @"" : _moneyTextField.text;
    NSString *pictureIdsStr = [self.pictureCollectonView.itemsPictureIDArray componentsJoinedByString:@","];
    NSString *voidceIdsstr = [[NSString alloc] init];
    
    NSLog(@"申请说明:~~%@", _tv.text);
    
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ApplyViewModel createApplicationWithDepartmentId:[self.identityIdArray objectAtIndex:identityNum] TypeId:[self.typeIdArray objectAtIndex:typeNum] Tag:_moneyTextField.text Content:_tv.text PhotoIds:pictureIdsStr voiceIds:voidceIdsstr success:^(NSDictionary *dataList) {
        
        NSArray  *controlArray = self.navigationController.childViewControllers;
        for (UIViewController * vc in controlArray) {
            
            if ([vc isKindOfClass:[ApplyVC class]]) {
                
                ApplyVC *applyVC = (ApplyVC *)vc;
                [applyVC loadDataFromWeb];
            }
        }
        
        [self.navigationController popViewControllerAnimated:NO];
        NSLog(@"新建申请成功:%@", dataList);
        
        //waitHUD
        [_waitHUD hide:YES];
        
    } failed:^(NSError *error) {
        
        //waitHUD
        [_waitHUD hide:YES];
        
        NSLog(@"新建申请失败:%@", error);
    }];
    
}

- (void)setupViewContent{
    
    // 整体滑动视图
    _scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    
    // 给一个父视图,方便下面所有视图移动
    _backgroundView = [[UIView alloc] initWithFrame:_scroll.bounds];
    [_scroll addSubview:_backgroundView];
    
    // 身份选择
    _identityLab = [self createLabelWithTitle:@"身份:" andFrame:CGRectMake(12, 18, 58, 22)];
    [_scroll addSubview:_identityLab];
    
    // 身份选项
    [_scroll addSubview:self.identityList];
    self.identityList.userInteractionEnabled = NO;
    
    // 申请类型
    _typeLab = [self createLabelWithTitle:@"类型:" andFrame:CGRectMake(12, (_identityLab.bottom +18) ,58 ,22)];
    [_scroll addSubview:_typeLab];
    
    // 类型选项
    [_scroll addSubview:self.categoryList];
    self.categoryList.userInteractionEnabled = NO;
    
    // 申请种类
    _kindLab = [self createLabelWithTitle:@"种类:" andFrame:CGRectMake(12, (_typeLab.bottom +18) ,58 ,22)];
    [_scroll addSubview:_kindLab];
    
    // 种类选项
    [_scroll addSubview:self.typeList];
    self.typeList.userInteractionEnabled = NO;
    
    // 金额背景图
    _moneyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, (_kindLab.bottom +18), kScreen_Width, 22)];
    [_scroll addSubview:_moneyBackgroundView];
    
    // 申请金额
    _moneyLab = [self createLabelWithTitle:@"金额:" andFrame:CGRectMake(12, 0, 58, 22)];
    [_moneyBackgroundView addSubview:_moneyLab];
    
    // 输入金额
    _moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, kScreen_Width - 65, 22)];
    _moneyTextField.delegate = self;
    _moneyTextField.placeholder = @"请输入金额";
    _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyTextField.font = [UIFont systemFontOfSize:14];
    [_moneyBackgroundView addSubview:_moneyTextField];
    
    // 元
    _yuanLab = [self createLabelWithTitle:@"元" andFrame:CGRectMake(kScreen_Width - 30, 0, 30, 22)];
    [_moneyBackgroundView addSubview:_yuanLab];
    
    // 线
    UIView *moneyLine = [[UIView alloc] initWithFrame:CGRectMake(58, 26, kScreen_Width - 65 - 15, 0.5)];
    moneyLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_moneyBackgroundView addSubview:moneyLine];
    
    
    // 文本视图
    _tv = [[UITextView alloc] initWithFrame:CGRectMake(12 , (_moneyBackgroundView.bottom +19), kScreen_Width - 24, 206)];
    _tv.layer.borderWidth = 0.5;
    _tv.textColor = [UIColor colorWithHexString:@"333333"];
    _tv.font = [UIFont systemFontOfSize:14];
    _tv.layer.borderColor = [UIColor colorWithHexString:@"d5d7dc"].CGColor;
    _tv.delegate = self;
    [_backgroundView addSubview:_tv];

    // 提醒标签
    _remindLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 250, 14)];
    _remindLab.text = @"请输入申请说明，限字800个";
    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    _remindLab.font = [UIFont systemFontOfSize:14];
    [_tv addSubview:_remindLab];

    /**
    // 录音列表
    [_tv addSubview: self.riverContentTab];
    
    // 录音按钮
    [_backgroundView addSubview:self.recordButton];
    **/

    // pictureCollectonView
    CGFloat width = (kScreen_Width-4*10)/3.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8; //上下的间距 可以设置0看下效果
    self.pictureCollectonView = [[ImageCollectionView alloc] initWithFrame:CGRectMake(0, _tv.bottom+8, kScreen_Width, width) collectionViewLayout:layout];
    [_backgroundView addSubview:self.pictureCollectonView];
    
    /**
    // 模板按钮
    [_backgroundView addSubview:self.modelEssayCollectionView];
    **/
    
    // 确定scroll的大小
    _scroll.contentSize = CGSizeMake(kScreen_Width, self.modelEssayCollectionView.bottom + 64);

    
}

#pragma mark - 通知方法
- (void)imageCountNotificationAction:(NSNotification *)not
{
    self.modelEssayCollectionView.frame = CGRectMake(0, self.pictureCollectonView.bottom+12, kScreen_Width, 120);
    _backgroundView.height = self.modelEssayCollectionView.bottom;
    _scroll.contentSize = CGSizeMake(kScreen_Width, self.modelEssayCollectionView.frame.origin.y + 120 + 20);
}

//封装一个UILabel的生成器
- (UILabel *)createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

#pragma mark - XYDropDownMenuDelegate
- (void)XYDropDownMenu:(XYDorpDownMenu *)menu didSelectAtIndexPath:(NSIndexPath *)indexPath
{
    if (menu == self.identityList) {
        
        [self.categoryList removeFromSuperview];
        self.categoryList = nil;
        [_scroll addSubview:self.categoryList];
        
        [self.typeList removeFromSuperview];
        self.typeList = nil;
        [_scroll addSubview:self.typeList];
        self.typeList.userInteractionEnabled = NO;
        
        //waitHUD
        _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [ApplyViewModel getUserApplicationCategoryWithDepartmentId:[self.identityIdArray objectAtIndex:indexPath.row] success:^(NSArray *categoryNameArray, NSArray *cateoryIdArray) {
            
            self.categoryNameArray = categoryNameArray;
            self.categoryIdArray = cateoryIdArray;
            
            //waitHUD
            [_waitHUD hide:YES];
            
        } failed:^(NSError *error) {
            
            //waitHUD
            [_waitHUD hide:YES];
            
            NSLog(@"通过身份获取类型时出错:%@", error);
            
        }];
        
    } else if (menu == self.categoryList) {
    
        [self.typeList removeFromSuperview];
        self.typeList = nil;
        [_scroll addSubview:self.typeList];

        NSInteger identityNum = [self.identityNameArray indexOfObject:self.identityList.selectedString];
        NSInteger categoryNum = [self.categoryNameArray indexOfObject:self.categoryList.selectedString];
        
        //waitHUD
        _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [ApplyViewModel getUserApplicationTypeWithDepartmentId:[self.identityIdArray objectAtIndex:identityNum] categoryId:[self.categoryIdArray objectAtIndex:categoryNum] success:^(NSArray *typeNameArray, NSArray *typeIdArray, NSArray *tagTypeArray) {
            
            self.typeNameArray = typeNameArray;
            self.typeIdArray = typeIdArray;
            self.tagTypeArray = tagTypeArray;
            
            //waitHUD
            [_waitHUD hide:YES];
            
        } failed:^(NSError *error) {
            
            //waitHUD
            [_waitHUD hide:YES];
            
            NSLog(@"通过申请类型获取种类时失败:%@", error);
        }];
    
    } else {
    
        switch ([[self.tagTypeArray objectAtIndex:indexPath.row] integerValue]) {
            case 0:  // 无
                
                _moneyBackgroundView.hidden = YES;
                break;
            
            case 1:  // 金额
                
                _moneyBackgroundView.hidden = NO;
                _moneyLab.text = @"金额:";
                _moneyTextField.placeholder = @"请输入金额";
                _yuanLab.text = @"元";
                break;
                
            case 2:  // 天数
                
                _moneyBackgroundView.hidden = NO;
                _moneyLab.text = @"天数:";
                _moneyTextField.placeholder = @"请输入天数";
                _yuanLab.text = @"天";
                break;
        }
        
    
    }
}


#pragma mark---UITexfieldDataSource
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return YES;
}

#pragma mark---UITableViewDataSource,UITableViewDelegate

// 区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _voices.count;
}

// 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AudioCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AUDIOCELL"];
    if (!cell) {
        cell=[[AudioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AUDIOCELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.deleteBlock = ^(Mp3Recorder *recorder) {
            
            [_voices removeObject:recorder];
            [self.riverContentTab reloadData];
        };
    }

    Mp3Recorder *mp3recorder = _voices[indexPath.row];
    
    NSLog(@"!!!!!%@",mp3recorder.url);
    cell.mp3Recorder = mp3recorder;
    return cell;
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
// 行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.riverTemplateNames.count;

}

// cell for item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_riverTemplateBtnCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, cell.frame.size.width *2 / 3, 30);
    btn.center = CGPointMake(cell.frame.size.width / 2 , cell.frame.size.height / 2);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];
    btn.layer.borderWidth = 1;
    btn.tag = indexPath.row;
    [btn setTitle:self.riverTemplateNames[indexPath.row] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [cell addSubview:btn];
    
    return cell;
}

#pragma mark - D3RecordDelegate
- (void)endRecord:(Mp3Recorder *)recorder
{
    self.riverContentTab.hidden = NO;

    [_voices addObject:recorder];

    [self.riverContentTab reloadData];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _remindLab.hidden = YES;
        
        CGFloat height = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            CGRect textFrame = [[textView layoutManager] usedRectForTextContainer:[textView textContainer]];
            height = textFrame.size.height+11;
            
        }else {
            
            height = textView.contentSize.height+11;
        }
        
        
        //位置变化
        self.riverContentTab.top = height;
        
    } else {
        _remindLab.hidden = NO;

    }
}

#pragma mark - Notification Method
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
    [HSWordLimit computeWordCountWithTextView:textView maxNumber:MAX_TEXTVIEW_LENGTH];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITextView class]]) {
        return;
    }
    [self.view endEditing:YES];
}

#pragma mark - Notification Method
- (void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    [HSWordLimit computeWordCountWithTextField:textField maxNumber:MAX_TEXTFIELD_LENGTH];
}

#pragma mark - Notification Method
- (void)keyBoardShow:(NSNotification *)obj
{
    _scroll.frame = CGRectMake(0, -100, self.view.bounds.size.width, self.view.bounds.size.height);
}

#pragma mark - Notification Method
- (void)keyBoardHide:(NSNotification *)obj
{
    _scroll.frame = self.view.bounds;
}

//控制器销毁移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
