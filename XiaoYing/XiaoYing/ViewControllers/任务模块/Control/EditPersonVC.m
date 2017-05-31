//
//  EditPersonVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "EditPersonVC.h"
#import "FirstModel.h"
@interface EditPersonVC ()<UITextFieldDelegate>
{
    UITextField *titleField_;
    UILabel *labcount;
    NSString *str;
}
@end

@implementation EditPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(KeepWay)];
    //输入标题文本框
    titleField_=[[UITextField alloc]initWithFrame:CGRectMake(10,16.5,kScreen_Width-40, 30)];
    titleField_.delegate=self;
    titleField_.placeholder = str;
    titleField_.font=[UIFont systemFontOfSize:16];
    
    labcount = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-30, 25, 20, 20)];
    labcount.text = @"30";
    labcount.textColor = [UIColor lightGrayColor];
    labcount.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:labcount];
    
    if ([str isEqualToString:@"未设置"]) {
    }else{
        NSInteger count = 30;
        labcount.text = [NSString stringWithFormat:@"%lu",(count-titleField_.text.length)];
        titleField_.text = str;
        
    }
    [self.view addSubview:titleField_];
    
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, 47, kScreen_Width-20, 0.5)];
    viewLine.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:viewLine];
    

}
-(void)KeepWay{
    [self FixedPlist];
    

    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)FixedPlist{
    if (_mark == 5) {
        _mymodel.RegionId = [titleField_.text integerValue];
    }else if (_mark == 6){
        _mymodel.Address = titleField_.text;
    }else if (_mark == 7){
        _mymodel.Signature = titleField_.text;
    }
    [[FirstStartData shareFirstStartData] PersonCentrePlist:_mymodel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackMark" object:[NSString stringWithFormat:@"%ld",(long)self.mark]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   
}
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField == titleField_) {
        if (textField.text.length >30) {
            textField.text = [textField.text substringToIndex:30];
        }else{
            labcount.text = [NSString stringWithFormat:@"%lu",(30-textField.text.length)];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return YES;
}
-(void)setContent:(NSString *)Content{
    str= Content;
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
