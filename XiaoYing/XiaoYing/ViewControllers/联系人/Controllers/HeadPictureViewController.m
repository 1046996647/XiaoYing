
//
//  HeadPictureViewController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/28.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "HeadPictureViewController.h"
#import "ChatViewController.h"
#import "UIImageView+AFNetworking.h"

@interface HeadPictureViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView * personView;
    UIImageView * headImg;
    UILabel * nameLab;
    UIImageView * sexImg;
    UILabel * otherNameLab;
    UITableView * personTab;
    UIButton * sendMessageBtn;
    UIButton * sendVideoBtn;
    UIImage * headImage;
    UIScrollView * backgroundSc;
}
@end

@implementation HeadPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详细资料";
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
   
    if (IS_IPHONE_4) {
        backgroundSc =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height )];
        backgroundSc.showsVerticalScrollIndicator =NO;
        backgroundSc.contentSize =CGSizeMake(kScreen_Width, 568);
        [self.view addSubview:backgroundSc];
        [self creatDetailView];

        [backgroundSc addSubview:personView];
        [backgroundSc addSubview:personTab];
        [backgroundSc addSubview:sendMessageBtn];
        [backgroundSc addSubview:sendVideoBtn];
        
    }
    else{
        [self creatDetailView];
        [self.view addSubview:personView];
        [self.view addSubview:personTab];
        [self.view addSubview:sendMessageBtn];
        [self.view addSubview:sendVideoBtn];
 
    }
    
}

-(void)creatDetailView{
    personView =[[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreen_Width, 80)];
    personView.backgroundColor =[UIColor whiteColor];
    headImg =[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 60, 60)];
    headImg.layer.cornerRadius =3;
    headImg.clipsToBounds =YES;

    [headImg setImageWithURL:[NSURL URLWithString:self.faceImg] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    [personView addSubview:headImg];
    
    nameLab =[[UILabel alloc]initWithFrame:CGRectMake(84, 16, 100, 16)];
    nameLab.textColor =[UIColor colorWithHexString:@"#333333"];
    nameLab.text =self.name;
    nameLab.font =[UIFont systemFontOfSize:16];
    [personView addSubview:nameLab];
    otherNameLab =[[UILabel alloc]initWithFrame:CGRectMake(84, 42, 200, 14)];
    otherNameLab.text =self.SmallYingName;
    otherNameLab.textColor =[UIColor colorWithHexString:@"#848484"];
    otherNameLab.font = [UIFont systemFontOfSize:14];
    [personView addSubview:otherNameLab];
    
    personTab =[[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreen_Width, 256) style:UITableViewStylePlain];
    personTab.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    personTab.dataSource =self;
    personTab.delegate =self;
    
    sendMessageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendMessageBtn.frame =CGRectMake(12,364, kScreen_Width -24, 44);
    sendMessageBtn.backgroundColor =[UIColor colorWithHexString:@"#f99740"];
    sendMessageBtn.layer.cornerRadius =5;
    sendMessageBtn.clipsToBounds =YES;
    [sendMessageBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [sendMessageBtn addTarget:self action:@selector(sendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    sendVideoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendVideoBtn.frame =CGRectMake(12,424, kScreen_Width -24, 44);
    sendVideoBtn.backgroundColor =[UIColor colorWithHexString:@"#ffffff"];
    sendVideoBtn.layer.cornerRadius =5;
    sendVideoBtn.clipsToBounds =YES;
    [sendVideoBtn setTitle:@"视频聊天" forState:UIControlStateNormal];
    [sendVideoBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [sendVideoBtn addTarget:self action:@selector(sendVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

-(void)sendMessageBtnClick{
    NSLog(@"发消息");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendVideoBtnClick{
    NSLog(@"视频聊天");

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else {
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && indexPath.row ==1) {
        return 100;
    }
    else {
       return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str =@"cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    if (!(indexPath.section ==1 && indexPath.row ==0)) {
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section ==0 && indexPath.row ==0) {

        cell.textLabel.text =@"设置备注和标签";
    }
   else if (indexPath.section ==1 && indexPath.row ==0) {
       cell.textLabel.text =@"地区       浙江  杭州";
    }
   else if (indexPath.section ==1 && indexPath.row ==1) {
       cell.textLabel.text =@"个人相册 ";
       for (int i =0; i<3;i++ ) {
           UIImageView * img =[[UIImageView alloc]initWithFrame:CGRectMake(90 +72*i, 24, 52, 52)];
           img.image =[UIImage imageNamed:@""];
           img.backgroundColor =[UIColor greenColor];
           [cell addSubview:img];
       }
   }
   else {
       cell.textLabel.text =@"更多";
   }
    return cell;
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
