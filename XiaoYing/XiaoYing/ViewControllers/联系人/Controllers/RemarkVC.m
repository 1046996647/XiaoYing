//
//  InputMemberIinfo.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/6/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "RemarkVC.h"

#define nickNum 12
//#define telNum 11
//#define personalSign 50

@interface RemarkVC ()
{
    UITextView *_tv;
    NSInteger fontNum;      //字数
    NSString *_keyStr;      //要修改的信息的键
    MBProgressHUD *_hud;
    
    
}

@property (nonatomic,strong)UILabel *remindLab;
@property (nonatomic,strong)UILabel *limitLab;

@end

@implementation RemarkVC

- (void)dealloc

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tv = [[UITextView alloc] initWithFrame:CGRectZero];
    _tv.backgroundColor = [UIColor whiteColor];
    //    _tv.delegate = self;
    _tv.font = [UIFont systemFontOfSize:16];
    [_tv becomeFirstResponder];
    _tv.text = self.text;
    [self.view addSubview:_tv];
    _tv.frame = CGRectMake(0, 12, kScreen_Width, 114/2);

    
    // 提醒标签
    _remindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    _remindLab.font = [UIFont systemFontOfSize:16];
    [_tv addSubview:_remindLab];
    
    UILabel *limitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    limitLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    limitLab.font = [UIFont systemFontOfSize:12];
    [_tv addSubview:limitLab];
    self.limitLab = limitLab;
    
    fontNum = nickNum;

    _remindLab.frame = CGRectMake(5, 8, 250, 14);
    _limitLab.frame = CGRectMake(_tv.width-12-12, _tv.height-12-10, 30, 12);
    
    
    
    //导航栏的确定按钮
    [self initRightBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:_tv];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view computeWordCountWithTextView:_tv remindLab:_remindLab warningLabel:_limitLab maxNumber:fontNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏的确定按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

//右上角按钮点击事件
//保存
- (void)saveAction
{
    
    //键盘收起
    [_tv resignFirstResponder];
    
    
    if ([_tv.text isEqualToString:self.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        _hud.labelText = @"正在...";
        NSString *urlStr = [FriendRemark stringByAppendingFormat:@"&friendId=%@&name=%@",_profileId, _tv.text];
        [AFNetClient POST_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
            NSNumber *code=[JSONDict objectForKey:@"Code"];
            
            if (1 == [code integerValue]) {
                [MBProgressHUD showMessage:[JSONDict objectForKey:@"Message"] toView:self.view];
            } else {
                
                if (self.clickBlock) {
                    self.clickBlock(_tv.text);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kAgreeFriendSuccessNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            //        [_hud setHidden:YES];
        } failed:^(NSError *error) {
            //        [_hud setHidden:YES];
            //        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        }];
        
        
    }
    
    
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if ([textView.text containsString:@"\n"]) {
//
//        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
//        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
//        textView.text = mStr;
//        [self saveAction];
//        return;
//    }
//
//    if (textView.text.length > 0) {
//        _remindLab.hidden = YES;
//    } else {
//        _remindLab.hidden = NO;
//
//    }
//
//}

#pragma mark - Notification Method
-(void)textViewEditChanged:(NSNotification *)obj
{
    
    UITextView *textView = (UITextView *)obj.object;
    
    if ([textView.text containsString:@"\n"]) {
        
        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        textView.text = mStr;
        [self saveAction];
        return;
    }
    
    [self.view computeWordCountWithTextView:_tv remindLab:_remindLab warningLabel:_limitLab maxNumber:fontNum];
}



@end
