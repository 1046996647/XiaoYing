//
//  XYAddNewNoteVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYAddNewNoteVc.h"
#import "XYNoteModel.h"
#import "XYNoteTool.h"
#import "XYNoteTool.h"

@interface XYAddNewNoteVc ()<UITextViewDelegate>{
    
    NSInteger NoteIdentifier;
 
}

//占位Label;
@property(nonatomic,strong)UILabel * placeHolderLabel;
@property(nonatomic,strong)UITextView * textView;

@end

@implementation XYAddNewNoteVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self setNav];
    
}


-(void)setNav{
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame= CGRectMake(0, 0, 10, 18);;
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * buttonView = [[UIView alloc]initWithFrame:rightButton.frame];
    [buttonView addSubview:rightButton];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:buttonView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)initUI{
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width -12, kScreen_Height - 64)];
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithHexString:@"#333333"];
    
    //注意这个地方
    NSNumber *defaultID = [[NSUserDefaults standardUserDefaults] objectForKey:@"NoteIdentifier"];
    NoteIdentifier = [defaultID integerValue] + 1;
    
    //对键盘进行监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //添加占位label方法
    [self addPlaceHolderLabel];
    
}

#pragma mark - 键盘通知方法 methodsForKeyBoard

-(void)changeKeyboard:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    CGRect keyBoardframe = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] longValue] animations:^{
        
        if (keyBoardframe.origin.y == kScreen_Height) {
            self.textView.height = kScreen_Height - 64;
        }
        
        self.textView.height = keyBoardframe.origin.y - 64;
        
        //通过动画，修改约束
        [self.view layoutIfNeeded];
    } completion:nil];
}

//取消对键盘的监听
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



-(void)addPlaceHolderLabel{
    
    self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.textView addSubview:self.placeHolderLabel];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:14];
    self.placeHolderLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.placeHolderLabel.contentMode = UIViewContentModeTop;
    self.placeHolderLabel.text = @"内容";
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.enabled = NO;
    
}

#pragma mark textView的代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.placeHolderLabel.hidden = 1;
    
}

#pragma mark 实现方法
-(void)clickSaveButton{
    
    NSLog(@"保存");
    if(self.textView.text.length > 0){
        XYNoteModel *model = [XYNoteModel modelWith:NoteIdentifier content:self.textView.text time:[self getTodayDate]];
        
        BOOL isInsert = [XYNoteTool insertModel:model];
        
        if (isInsert) {
            NSLog(@"插入数据成功");
            NSNumber *newNoteIdentifier = [NSNumber numberWithInteger:NoteIdentifier];
            [[NSUserDefaults standardUserDefaults] setValue:newNoteIdentifier forKey:@"NoteIdentifier"];
            
        } else {
            NSLog(@"插入数据失败");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"您还没有输入任何信息!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"取消了...");
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"确定了...");
//        }];
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        [MBProgressHUD showMessage:@"便签内容不能为空"];
    }

}

- (NSString *)getTodayDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}

//当滚动时，收起键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
