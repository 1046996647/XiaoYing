//
//  IssueNoticeVC.m
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "IssueNoticeVC.h"
#import "NewMemoryTableView.h"
#import "PopViewVC.h"
#import "NewMemoryModel.h"
#import "WangUrlHelp.h"
#import "MulSelDepartmentAffVC.h"

@interface IssueNoticeVC ()<UITextViewDelegate,UITextFieldDelegate> {
    UILabel *textViewLabel;
    NSMutableArray *_imagesArray;
}
@property (nonatomic,strong) UITextField *titleField;
//@property (nonatomic,strong) UILabel *labNameApprove;
@property(nonatomic,strong)UIButton *labNameApproveButton;
@property (nonatomic,strong) UIImage *imageviewPicture;
@property (nonatomic,strong) NSMutableAttributedString *attributeString;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,copy) NSMutableArray *arrButton;
@property (nonatomic,copy) NSMutableArray *arrImageview;
@property (nonatomic, strong) NewMemoryTableView *textView;
@property(nonatomic,strong)UILabel *labPeople;//审批人姓名label
@property(nonatomic,strong)NSNumber *CompanyRanks;
@property (nonatomic) CGFloat heightText;
@property(nonatomic,strong)NSMutableArray *selectedArr;//选中的部门ID名称
@property(nonatomic,strong)NSMutableSet *selectedNameSet;//选中的部门名称
@property(nonatomic,strong)NSMutableSet *approvalPeopleNameSet;//审批人数组
@property(nonatomic,strong)MBProgressHUD *hud;//菊花
@property(nonatomic,strong)NSMutableArray *range;//申请发布要传给服务器的range数组
@property(nonatomic,strong)NSMutableArray *notHaveApprovalPeopleArray;//没有审批人的数组
@end

@implementation IssueNoticeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请发布" style:UIBarButtonItemStylePlain target:self action:@selector(Issue)];
    self.CompanyRanks = @1;
    self.selectedArr = [NSMutableArray array];
    self.range = [NSMutableArray array];
    //初始化UI界面
    [self initUI];
    [self initData];
    
    
    
}

//初始化数据
-(void) initData{
    _arrImageview = [[NSMutableArray alloc] init];
    _imagesArray = [NSMutableArray new];
}
//初始化UI界面
-(void) initUI{
    
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.userInteractionEnabled = YES;
    [self.view addSubview:_backView];
    
    
    //输入标题文本框
    _titleField=[[UITextField alloc]initWithFrame:CGRectMake(12,12,kScreen_Width-44, 24)];
    _titleField.delegate=self;
    _titleField.placeholder = @"请输入标题";
    _titleField.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleField.font=[UIFont systemFontOfSize:16];
    _titleField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_backView addSubview:_titleField];
    
    
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(12, _titleField.bottom + 8, kScreen_Width-24, 0.5)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_backView addSubview:viewLine];
    
    UILabel *labApprove = [[UILabel alloc] initWithFrame:CGRectMake(12, viewLine.bottom + 12, 130, 24)];
    labApprove.text = @"公告范围";
    labApprove.textColor = [UIColor grayColor];
    labApprove.font = [UIFont systemFontOfSize:16];
    [_backView addSubview:labApprove];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_set"]];
    imageView.frame = CGRectMake(kScreen_Width - 30, viewLine.bottom + 14, 10, 20);
    [_backView addSubview:imageView];
    
    //公告范围的部门
    _labNameApproveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _labNameApproveButton.frame = CGRectMake(kScreen_Width / 2 - 20, viewLine.bottom + 12, kScreen_Width / 2 - 36 + 20, 24);
    [_labNameApproveButton setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    _labNameApproveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _labNameApproveButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight ;
    [_labNameApproveButton setTitle:@"" forState:UIControlStateNormal];
    [_labNameApproveButton addTarget:self action:@selector(showDepartment) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_labNameApproveButton];
    
    UIView *viewLine1 = [[UIView alloc] initWithFrame:CGRectMake(12, 92, kScreen_Width-24, 0.5)];
    viewLine1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_backView addSubview:viewLine1];
    
    UILabel *labLeader = [[UILabel alloc] initWithFrame:CGRectMake(12,viewLine1.bottom + 12 , 60, 39)];
    labLeader.text = @"审批人:";
    labLeader.font = [UIFont systemFontOfSize:16];
    labLeader.textColor = [UIColor colorWithHexString:@"#333333"];
    [_backView addSubview:labLeader];
    
    //审批人的名字
    _labPeople = [[UILabel alloc] initWithFrame:CGRectMake(70, viewLine1.bottom + 12, kScreen_Width - 70 -24, 39)];
    _labPeople.text = @"";
    _labPeople.font = [UIFont systemFontOfSize:16];
    _labPeople.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _labPeople.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_backView addSubview:_labPeople];
    
    _textView = [[NewMemoryTableView alloc]initWithFrame:CGRectMake(12, labLeader.bottom , kScreen_Width - 24, kScreen_Height - _labPeople.bottom - 49 - 64)];
    [self.view addSubview:_textView];
     __block __weak __typeof(&*self)weakSelf = self;
    _textView.refreshBlock = ^(void){
        NSLog(@"_textView.height:%f",weakSelf.textView.height);
    };
    
    
    UILabel *labelLineDown = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreen_Height - 49 - 64, kScreen_Width, 1)];
    labelLineDown.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_backView addSubview:labelLineDown];
    
    UIButton *downButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreen_Height - 49 - 64, kScreen_Width, 49)];
    [downButton setTitle:@"添加图片" forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(GetCamera:) forControlEvents:UIControlEventTouchUpInside];
    [downButton setTitleColor:[UIColor colorWithHexString:@"#f99740" ] forState:UIControlStateNormal];
    [_backView addSubview:downButton];
    
    
}


#pragma mark - 点击发布按钮之后 methods
-(void)Issue{
    
    if (_notHaveApprovalPeopleArray.count > 0) {
        if (_notHaveApprovalPeopleArray.count == 1) {
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@缺少审批人，不能申请发送！",_notHaveApprovalPeopleArray[0]]];
        }else{
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@等%ld个部门缺少审批人，不能申请发送！",_notHaveApprovalPeopleArray[0],_notHaveApprovalPeopleArray.count]];
        }
    }else{
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载中";
        NSMutableArray *arrM = [NSMutableArray array];
        for (NewMemoryModel *model in _textView.modelArr) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            if (model.fileType == FileTypeText) {
                
                if (model.text.length == 0) {
                    model.text = @"";
                }
                [dic setObject:@"0" forKey:@"type"];
                [dic setObject:model.text forKey:@"content"];
            }
            else {
                
                [dic setObject:@"1" forKey:@"type"];
                
                [dic setObject:model.text forKey:@"content"];
                
            }
            
            
            [arrM addObject:dic];
        }
        NSString *jsonStr = [arrM JSONString];
        
        BOOL contentIsEmpty = NO;//判断公告内容是否为空
        if (arrM.count == 1) {
            NSDictionary *dic = arrM.firstObject;
            NSString *content = dic[@"content"];
            if ([content isEqualToString:@""]) {
                contentIsEmpty = YES;
            }
        }
        
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"0" forKey:@"departmentId"];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:@"0" forKey:@"profileId"];
        [array addObject:dic];
        [array addObject:dic1];
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:_titleField.text forKey:@"Title"];
        [paraDic setObject:jsonStr forKey:@"Content"];
        [paraDic setObject:[UserInfo userID] forKey:@"Creator"];
        [paraDic setObject:_range forKey:@"Ranges"];
        [paraDic setObject:[UserInfo getCompanyId] forKey:@"CompanyId"];
        
        if (![_titleField.text isEqualToString:@""] && _range.count!=0 && contentIsEmpty == NO) {//公告的内容齐全
            [AFNetClient POST_Path:AFFICHE_CREAT params:paraDic completed:^(NSData *stringData, id JSONDict) {
                NSNumber *code=[JSONDict objectForKey:@"Code"];
                if ([code isEqual:@0]) {
                    NSLog(@"发布>>>>>> 成功--%@",JSONDict);
                    [_hud hide:YES];
                    _hud = nil;
                    [self.navigationController popViewControllerAnimated:YES];
                    self.sendBlock();
                }else{
                    [_hud hide:YES];
                    _hud = nil;
                    [MBProgressHUD showMessage:JSONDict[@"Message"]];
                }
            } failed:^(NSError *error) {
                [_hud hide:YES];
                _hud = nil;
                [MBProgressHUD showMessage:@"申请发送失败"];
                NSLog(@"失败******发布=======>>>%@",error);
            }];
        }else{
            [_hud hide:YES];
            _hud = nil;
            if ([_titleField.text isEqualToString:@""]) {
                [MBProgressHUD showMessage:@"公告标题不能为空！"];
                return;
            }else if (_range.count == 0){
                [MBProgressHUD showMessage:@"未选择公告范围！"];
                return;
            }else if (contentIsEmpty == YES){
                [MBProgressHUD showMessage:@"公告内容不能为空！"];
                return;
            }
        }
    
    }
    
}

-(void)GetCamera:(UIButton *)btn{

    PopViewVC *popViewVC  = [[PopViewVC alloc] init];
    popViewVC.titleArr = @[@"相册",@"拍照"];
    popViewVC.clickBlock = ^(NSInteger indexRow) {
        
        if (indexRow == 0) {
            
           [[NSNotificationCenter defaultCenter]postNotificationName:@"AddPicture" object:@"0"];

        } else {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AddPicture" object:@"1"];
        }
    };
    popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //  self.definesPresentationContext = YES; //不盖住整个屏幕
    popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:popViewVC animated:YES completion:nil];

}

#pragma mark -----//实现点击图片预览功能 滑动放大或缩小，带动画


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    /*
     
     if (m_countFlag==0) {
     
     }else{
     isFullScreen = !isFullScreen;
     
     
     UITouch *touch = [touches anyObject];
     
     CGPoint touchPoint = [touch locationInView:self.view];
     
     UIImageView *ima = _arrImageview[m_countFlag-1];
     CGPoint imagePoint = ima.frame.origin;
     //touchPoint.x ，touchPoint.y 就是触点的坐标
     
     // 触点在imageView内，点击imageView时 放大,再次点击时缩小
     if(imagePoint.x <= touchPoint.x && imagePoint.x +ima.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+ima.frame.size.height >= touchPoint.y)
     {
     // 设置图片放大动画
     [UIView beginAnimations:nil context:nil];
     // 动画时间
     [UIView setAnimationDuration:1];
     
     if (isFullScreen) {
     // 放大尺寸
     
     ima.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
     }
     else {
     // 缩小尺寸
     ima.frame = CGRectMake(50, 65, 90, 115);
     }
     // commit动画
     [UIView commitAnimations];
     }
     }
     */
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"1");
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"2");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"3");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击公告范围之后进入公告选择界面
-(void)showDepartment{
    [self.view endEditing:YES];
    MulSelDepartmentAffVC *mulVC = [[MulSelDepartmentAffVC alloc]init];
    mulVC.CompanyName = [UserInfo getcompanyName];
    mulVC.CompanyRanks = self.CompanyRanks;
    mulVC.departments = self.deparments;
    mulVC.selectedArr = [self.selectedArr mutableCopy];
    mulVC.allowDepartments = [self.departmentIdArray copy];
    mulVC.title = @"选择公告范围";
    [self.navigationController pushViewController:mulVC animated:YES];
    mulVC.sendBlock = ^(NSMutableArray *arrM){
        self.selectedArr = arrM;
        self.selectedNameSet = [NSMutableSet set];
        for (NSDictionary *subdic in self.deparments) {
            for (NSString *deid in self.selectedArr) {
                if ([deid isEqualToString:subdic[@"DepartmentId"]]) {
                    [self.selectedNameSet addObject:subdic[@"Title"]];
                }
            }
        }
        NSMutableArray *nameArray = [NSMutableArray array];
        for (NSString *str in self.selectedNameSet) {
            [nameArray addObject:str];
        }
        NSLog(@"");
        if (nameArray.count == 1) {
            [_labNameApproveButton setTitle:[NSString stringWithFormat:@"%@",nameArray[0]] forState:UIControlStateNormal];
        }else if(nameArray.count == 2){
            [_labNameApproveButton setTitle:[NSString stringWithFormat:@"%@,%@(2)",nameArray[0],nameArray[1]] forState:UIControlStateNormal];
        }else if (!nameArray.count){//选择了公司层级
            [_labNameApproveButton setTitle:[NSString stringWithFormat:@"%@",[UserInfo getcompanyName]] forState:UIControlStateNormal];
        }else{
            [_labNameApproveButton setTitle:[NSString stringWithFormat:@"%@,%@,%@(%ld)",nameArray[0],nameArray[1],nameArray[2],nameArray.count] forState:UIControlStateNormal];
        }
        [self loadApprovalPeople];
    };
    
}

//获取审批人的名字
-(void)loadApprovalPeople{

    self.approvalPeopleNameSet = [NSMutableSet set];
    self.range = [NSMutableArray array];
    self.notHaveApprovalPeopleArray = [NSMutableArray array];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    NSArray *depaArray = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    NSString *strUrl = AFFICHE_GETDEPARTMENTAPPROVER;
    NSArray *paraArr = nil;
    if (_selectedArr.count == 1 && [_selectedArr.firstObject isEqualToString:@""]) {
        paraArr = @[@"Uzg9"];
    }else{
        paraArr = [_selectedArr copy];
    }
    [AFNetClient POST_Path:strUrl params:paraArr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if (0 == [code integerValue]) {
            NSDictionary *dataDic = JSONDict[@"Data"];
            
            //如果是公司层级的话
            if ([paraArr.firstObject isEqualToString:@"Uzg9"]) {
                [self.selectedArr removeAllObjects];
                self.selectedArr = @[@"Uzg9"].mutableCopy;
            }
            for (NSString *deid in self.selectedArr) {
                NSString *approvalNameID = [dataDic objectForKey:deid];
                if ([approvalNameID isEqualToString:@"0"]) {//没有审批人
                    for (NSDictionary *subdic in depaArray) {
                        if ([deid isEqualToString:[subdic objectForKey:@"DepartmentId"]]) {
                            [_notHaveApprovalPeopleArray addObject:[subdic objectForKey:@"Title"]];
                        }
                    }
                }
                for (NSDictionary *employeeDic in employeesArr) {
                    NSString *approvalName = [employeeDic objectForKey:@"EmployeeName"];
                    NSString *profielID = [employeeDic objectForKey:@"ProfileId"];
                    if ([profielID isEqualToString:approvalNameID]) {
                        NSMutableDictionary *rangeDic = [NSMutableDictionary dictionary];
                        [rangeDic setObject:deid forKey:@"DepartmentId"];
                        [rangeDic setObject:profielID forKey:@"ProfileId"];
                        [_range addObject:rangeDic];
                        //去除重复的审批人
                        NSLog(@"");
//                        if (![_approvalPeopleNameArr containsObject:profielID]) {
                            [_approvalPeopleNameSet addObject:approvalName];
                        //}
                    }
                }
            }
            
            NSMutableArray *peopleNameArray = [NSMutableArray array];
            
            for (NSString *str in _approvalPeopleNameSet) {
                [peopleNameArray addObject:str];
            }
            
            _labPeople .text = @"";
            //审批人label的显示
            for (int i = 0; i<peopleNameArray.count; i++) {
                if (i == 0) {
                    _labPeople .text = [_labPeople.text stringByAppendingFormat:@"%@",peopleNameArray[i]];
                }else{
                    _labPeople.text = [_labPeople.text stringByAppendingFormat:@",%@",peopleNameArray[i]];
                    CGSize textSize = [_labPeople.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
                    if (textSize.width > _labPeople.frame.size.width && i==peopleNameArray.count - 1) {//启用省略号，并在后面加上数字
                        _labPeople.text = [_labPeople.text stringByAppendingFormat:@"(%ld)",peopleNameArray.count];
                    }
                }
            }
            [_hud hide:YES];
            _hud = nil;
        }else{
            [_hud hide:YES];
            _hud = nil;
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [_hud hide:YES];
    }];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
