//
//  XYWorkShowWrongVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYWorkShowWrongVc.h"

@interface XYWorkShowWrongVc (){
    UIView * _reminderView;
    UIImageView * _reminderImageView;
}

@end

@implementation XYWorkShowWrongVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reminderView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 380/2)/2, (kScreen_Height - 180/2)/2, 190, 90)];
    [self.view addSubview:_reminderView];
    
    _reminderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _reminderView.width, _reminderView.height)];
    [_reminderView addSubview:_reminderImageView];
    _reminderImageView.image = [UIImage imageNamed:@"noname"];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view  ==  self.view) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
