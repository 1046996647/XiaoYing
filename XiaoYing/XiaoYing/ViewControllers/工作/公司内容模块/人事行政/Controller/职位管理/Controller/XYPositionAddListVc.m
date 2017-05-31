//
//  XYPositionAddListVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/10.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYPositionAddListVc.h"
#import "CompanyJobViewModel.h"

@interface XYPositionAddListVc ()<UITextFieldDelegate,UITextViewDelegate>{
    
    UIView * _presentView;
    UITextField * _textField;
    
    //提示名称已经存在
    UIImageView  *_iconImageView;
    UILabel *_warningLabel;
    
    MBProgressHUD *_waitHUD;  //waitHUD
}

@end

@implementation XYPositionAddListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //监听到类名输入框的内容改变时，将警告View隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waringViewHided) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)waringViewHided
{
    _iconImageView.hidden = YES;
    _warningLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self waringViewHided];
}

-(void)setupUI{
    
    _presentView = [[UIView alloc]init];
    _presentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_presentView];
    
    //UILabel
    NSString * content = @"添加类别";
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
   
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((270 - size.width)/2, 12, size.width, size.height )];
    titleLabel.text = content;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [_presentView addSubview:titleLabel];
    
    //UITextField
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, titleLabel.bottom + 12, 250, 35)];
    _textField.layer.cornerRadius = 5;
    _textField.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    _textField.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_presentView addSubview:_textField];
    
    //UIImageView
    _iconImageView =[[UIImageView alloc]init];
    [_presentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_presentView).offset(10);
        make.bottom.equalTo(titleLabel.mas_bottom);
        make.width.height.equalTo(@12);
        
        
    }];
    
    _iconImageView.image = [UIImage imageNamed:@"wrong"];
    [_presentView addSubview:_iconImageView];
 
    
    NSString * warning = @"已存在";
    _warningLabel = [[UILabel alloc]init];
    _warningLabel.text = warning;
    _warningLabel.textColor = [UIColor colorWithHexString:@"f94040"];
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.font = [UIFont systemFontOfSize:12];
    [_presentView addSubview:_warningLabel];
    [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_iconImageView.mas_right).offset(6);
        make.bottom.equalTo(_iconImageView.mas_bottom);
        
    }];
    

    //移动textfiled光标
    CGRect rect = _textField.frame;
    rect.size.width = 8;
    UIView *view = [[UIView alloc]initWithFrame:rect];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = view;
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _textField.bottom + 12, 270, 0.5)];
    [_presentView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    
    
    //确定button
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_presentView addSubview:rightBtn];
    rightBtn.frame =CGRectMake(0, lineView.bottom, 270/2 - 0.5, 44);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    
    //两个按钮之间的分割线
    UIView * middleView = [[UIView alloc]initWithFrame:CGRectMake(rightBtn.right, lineView.bottom, 0.5, 44)];
    [_presentView addSubview:middleView];
    middleView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    
    //取消button
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_presentView addSubview:cancelBtn];
    cancelBtn.frame =CGRectMake(middleView.right, lineView.bottom, 270/2, 44);
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    
    
    _presentView.frame = CGRectMake((kScreen_Width - 270)/2, (kScreen_Height - cancelBtn.bottom)/3, 270, cancelBtn.bottom);
    
    
}

//点击确定按钮
-(void)clickRightBtn{
    
    if (_textField.text.length <= 0) {
        
        [MBProgressHUD showMessage:@"类别名字不能为空"];
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(contrastToData:)]) {
            
            if([self.delegate contrastToData:_textField.text]) {
                _iconImageView.hidden = NO;
                _warningLabel.hidden = NO;
            }else {
                _iconImageView.hidden = YES;
                _warningLabel.hidden = YES;
                
                //添加类别
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    //waitHUD
                    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    //发送网络请求
                    [CompanyJobViewModel addCategoryWithCategoryName:_textField.text success:^(NSString *newCategoryId) {
                        
                        NSLog(@"新添加的职位类别返回的ID:%@", newCategoryId);
                        if ([self.delegate respondsToSelector:@selector(refreshDelegationView)]) {
                            [self.delegate refreshDelegationView];
                        }
                        
                        //waitHUD
                        [_waitHUD hide:YES];
                        
                    } failed:^(NSError *error) {
                        
                        //waitHUD
                        [_waitHUD hide:YES];
                        
                        NSLog(@"%@",error);
                    }];
                    
                }];
                
            }
            
        }
        
    }

}

-(void)clickCancelBtn{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Dispose of any resources that can be recreated.
}

@end
