//
//  InviteNewStuVC.m
//  XiaoYing
//
//  Created by GZH on 16/9/27.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "InviteNewStuVC.h"
#import "InviteNetStuModel.h"
@interface InviteNewStuVC ()<UISearchBarDelegate>
@property (nonatomic, strong) XYSearchBar *searchBar;//收索框
@property (nonatomic, strong) UIView *backView;  //找不到新同事的时候显示的View
@property (nonatomic, strong) NSString *XiaoYingHao;
@property (nonatomic, strong) InviteNetStuModel *model;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIImageView *moveImage;

@property (nonatomic, strong) UIView *backView1;  //找到新同事的时候显示的View
@property (nonatomic, strong) UIView *backView2;

@end




@implementation InviteNewStuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"新同事";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self initUI];
    
}



- (void)initUI {
    
    _searchBar = [[XYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.placeholder = @"请输入对方帐号";
    [_searchBar.searchButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBar];
    
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom, kScreen_Width, kScreen_Height - _searchBar.bottom - 100)];
    _backView.hidden = YES;
    [self.view addSubview:_backView];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 185) / 2, 50, 185, 161)];
    image.image = [UIImage imageNamed:@"face3"];
    [_backView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, image.bottom + 12, kScreen_Width - 24, 16)];
    label.text = @"对不起, 找不到对象!";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:label];
   
}




#pragma mark --searchBarDelegate--
// 搜索框上的X按钮事件
- (void)clearAction
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    _searchBar.searchButton.hidden = YES;
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
//    _searchBar.searchButton.hidden = NO;
    return YES;
}


//输入框输入字符的时候
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   [self backViewHiddenYESORNO];
    _XiaoYingHao = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    
    NSString *strURL = [findNewSudentsURL stringByAppendingFormat:@"&XiaoYingCode=%@", _XiaoYingHao];
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = [JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0] && ![JSONDict[@"Data"] isKindOfClass:[NSNull class]]) {
//NSLog(@"-------------------------------------------------------%@", JSONDict);
            [_searchBar resignFirstResponder];
            [self backViewHiddenYESORNO];
            [self paraserNetData:JSONDict];
            
        }else {
            _backView.hidden = NO;
        }
         [_hud hide:YES];
    } failed:^(NSError *error) {
         [_hud hide:YES];
        NSLog(@"--%@", error);
    }];

}


- (void)paraserNetData:(id)responder {
    NSMutableDictionary *dic = responder[@"Data"];
    _model = [[InviteNetStuModel alloc]init];
    [_model setValuesForKeysWithDictionary:dic];

    [self initUIOfNewStu];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //没搜到对象的话点击取消，提示图片是否消失
//    [self backViewHiddenYESORNO];

    NSLog(@"4--%@", searchBar.text);
}

- (void)backViewHiddenYESORNO {
    if (_backView.hidden == NO) {
        _backView.hidden = YES;
    }
}


- (void)initUIOfNewStu {


    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom + 25, kScreen_Width, 0)];
    backView.backgroundColor = [UIColor whiteColor];
    self.backView1 = backView;
    [self.view addSubview:backView];
    
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 64, 64)];
    NSString *iconURL = [NSString replaceString:_model.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [imageIcon sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"003"]];
       
    
    imageIcon.layer.masksToBounds = YES;
    imageIcon.layer.cornerRadius = 5.0;
    [backView addSubview:imageIcon];
    
    UILabel *nameLabel = [self Z_createLabelWithTitle:@"(无)" buttonFrame:CGRectMake( imageIcon.right + 12, 35, kScreen_Width / 2, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    if (_model.Nick != nil) {
        nameLabel.text = _model.Nick;
    }else {
        nameLabel.text = @"(无)";
        nameLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    
    [backView addSubview:nameLabel];
    
    UIImageView *imageMan = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.right + 12, nameLabel.top, 15, 19)];
    imageMan.image = [UIImage imageNamed:@"woman-1"];
    [backView addSubview:imageMan];
    
    UILabel *idnumberLabel = [self Z_createLabelWithTitle:@"(无)" buttonFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 10, kScreen_Width / 3, 12) textFont:12 colorStr:@"#848484" aligment:NSTextAlignmentLeft];
    idnumberLabel.text = _XiaoYingHao;
    [backView addSubview:idnumberLabel];
    
    UILabel *birthdayLabel = [self Z_createLabelWithTitle:@"生日 :" buttonFrame:CGRectMake( 12, imageIcon.bottom + 15, imageIcon.width + 9, 16) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    [backView addSubview:birthdayLabel];
    
    UILabel *regionLabel = [self Z_createLabelWithTitle:@"地区 :" buttonFrame:CGRectMake( 12, birthdayLabel.bottom + 15, imageIcon.width + 9, 16) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    [backView addSubview:regionLabel];
    
    UILabel *personalLabel = [self Z_createLabelWithTitle:@"个性签名 :" buttonFrame:CGRectMake( 10, regionLabel.bottom + 15, imageIcon.width + 12, 16) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    [backView addSubview:personalLabel];
    
    UILabel *answerBirthdayLabel = [self Z_createLabelWithTitle:@"(无)" buttonFrame:CGRectMake( birthdayLabel.right + 9, imageIcon.bottom + 15, kScreen_Width - birthdayLabel.right - 12, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    if (_model.Birthday != nil) {
        NSArray *array = [_model.Birthday componentsSeparatedByString:@" "];
        answerBirthdayLabel.text = array[0];
    }else {
        answerBirthdayLabel.text = @"(无)";
        answerBirthdayLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    [backView addSubview:answerBirthdayLabel];
    
    UILabel *answerRegionLabel = [self Z_createLabelWithTitle:@"(无)" buttonFrame:CGRectMake( birthdayLabel.right + 9, answerBirthdayLabel.bottom + 15, kScreen_Width - birthdayLabel.right - 12, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    if (_model.RegionName != nil) {
        answerRegionLabel.text = _model.RegionName;
    }else {
        answerRegionLabel.text = @"(无)";
        answerRegionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    [backView addSubview:answerRegionLabel];
    
    UILabel *answerPersonalLabel = [self Z_createLabelWithTitle:@"(无)" buttonFrame:CGRectMake( birthdayLabel.right + 9, answerRegionLabel.bottom + 15, kScreen_Width - birthdayLabel.right - 12, 75) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    answerPersonalLabel.numberOfLines = 0;
    if (_model.Signature != nil && ![_model.Signature isEqualToString:@""]) {
         answerPersonalLabel.text = _model.Signature;
    }else {
        answerPersonalLabel.text = @"(无)";
        answerPersonalLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    [backView addSubview:answerPersonalLabel];
    backView.frame = CGRectMake(0, _searchBar.bottom + 25, kScreen_Width, answerPersonalLabel.bottom + 15);
    
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom, kScreen_Width, 69)];
    backView1.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.backView2 = backView1;
    [self.view addSubview:backView1];
    
    
    UIButton *button = [self Z_createButtonWithTitle:@"邀请加入公司" buttonFrame:CGRectMake(12, 25, kScreen_Width - 24, 44)];
    [button addTarget:self action:@selector(InviteNewStuURLAction) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:button];
    
    UIButton *deleteButton = [self Z_createButtonWithTitle:@"已加入公司" buttonFrame:CGRectMake(12, 25, kScreen_Width - 24, 44)];
    deleteButton.hidden = YES;
    [deleteButton addTarget:self action:@selector(JoinCompanyAlready) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:deleteButton];
    
}




- (void)JoinCompanyAlready {
    
    NSLog(@"已加入公司");
}


//邀请加入公司
- (void)InviteNewStuURLAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"邀请中...";
    NSString *strURL = [InviteNewStuURL stringByAppendingFormat:@"&XiaoYingHao=%@",_XiaoYingHao];
    [AFNetClient POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
              NSLog(@"yaoqing chenggong ");
            [_hud setHidden:YES];
            [self commitImageView];
        }else {
            [_hud setHidden:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
            
        }
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"%@", error );
    }];
}

- (void)commitImageView {
    _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sended2"]];
    [_moveImage setFrame:CGRectMake((kScreen_Width - 125) / 2, (kScreen_Height - 110) / 2 - 100, 125, 110)];
    [self imageAnimalAction];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(toMakePhotoHiddenAction) userInfo:nil repeats:nil];

}


- (void)imageAnimalAction {
    [self.view addSubview:_moveImage];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:1.0];
    [UIView commitAnimations];
}

- (void)toMakePhotoHiddenAction {
    [_moveImage setHidden:YES];
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame
                           textFont:(CGFloat)font
                           colorStr:(NSString *)colorStr
                           aligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithHexString:colorStr];
    label.textAlignment = aligment;
    return label;
}


- (UIButton *)Z_createButtonWithTitle:(NSString *)title
                          buttonFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    return button;
}



@end
