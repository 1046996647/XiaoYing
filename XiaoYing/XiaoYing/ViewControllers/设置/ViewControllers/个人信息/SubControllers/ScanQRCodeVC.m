//
//  ScanQRCode.m
//  XiaoYing
//
//  Created by MengFanBiao on 15/12/30.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ScanQRCodeVC.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "SweepBySweepVC.h"
//#import "JSONKit.h"
@interface ScanQRCodeVC ()
{
    UIImageView *imageview;//二维码图片
    UIImageView *imageHeard;//头像
    UILabel *nameLab;//姓名
    UIView *QRView;//我的二维码下面的view
    UILabel *numLab;//我的小赢号
    UIButton *rightBtn;//右侧的按钮
    UIView *nextView;//下拉框

}

@property (nonatomic,strong) ProfileMyModel *profileMyModel;


@end

@implementation ScanQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"我的二维码";
    
    //个人信息取出
    self.profileMyModel = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
    
//    [self rightbt];
    [self initUI];
}
-(void)rightbt{
    rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame =CGRectMake(kScreen_Width -52, 25, 40, 18);
    [rightBtn setImage:[UIImage imageNamed:@"椭圆-1.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightWithFinishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

static int markflag = 0 ;
-(void)rightWithFinishButtonClick{
    if (markflag == 0) {
        nextView.hidden = NO;
        markflag = 1;
    }else{
        nextView.hidden = YES;
        markflag = 0;
    }
}
-(void)initUI{
    
    
    QRView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-554/2)/2, 37, 554/2, 770/2)];
    QRView.backgroundColor = [UIColor whiteColor];
    QRView.layer.cornerRadius = 5;
    QRView.layer.masksToBounds = YES;
    [self.view addSubview:QRView];
    
    imageview = [[UIImageView alloc] initWithFrame:CGRectMake((QRView.width-490/2)/2, 100, 490/2,490/2)];
    [QRView addSubview:imageview];
//    imageview.backgroundColor = [UIColor redColor];

    
    // 生成二维码
    [self generatecode];
    
    imageHeard = [[UIImageView alloc] initWithFrame:CGRectMake(16, 21, 64, 64)];
    imageHeard.layer.cornerRadius = 5;
    imageHeard.layer.masksToBounds = YES;
    [QRView addSubview:imageHeard];
    //头像
    NSString *iconURL = [NSString replaceString:self.profileMyModel.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [imageHeard sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@""]];
    
    NSString *content = self.profileMyModel.Nick;
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(imageHeard.right+12, 30, size.width, size.height)];
    nameLab.text = self.profileMyModel.Nick;
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [QRView addSubview:nameLab];
    
    UIImageView *sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(nameLab.right+12, nameLab.top, 15, 19)];
    [QRView addSubview:sexImg];
    
    if (self.profileMyModel.Gender == 0) {
        sexImg.image = [UIImage imageNamed:@""];
    }
    else if (self.profileMyModel.Gender == 1) {
        sexImg.image = [UIImage imageNamed:@"man"];
    }
    else {
        sexImg.image = [UIImage imageNamed:@"woman"];
    }
    
    UILabel *regionName = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.left, nameLab.bottom+16, QRView.width-12-nameLab.left, 18)];
    regionName.font = [UIFont systemFontOfSize:16];
    regionName.textColor = [UIColor colorWithHexString:@"#848484"];
    regionName.text = self.profileMyModel.RegionName;
    [QRView addSubview:regionName];
    
    numLab = [[UILabel alloc] initWithFrame:CGRectMake(0 , imageview.bottom+10, QRView.width, 20)];
    numLab.text = [NSString stringWithFormat:@"小赢号：%@", self.profileMyModel.XiaoYingCode];
    numLab.textColor = [UIColor colorWithHexString:@"#848484"];
    numLab.font = [UIFont systemFontOfSize:12];
    numLab.textAlignment = NSTextAlignmentCenter;
    [QRView addSubview:numLab];
    
    
    nextView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-130,0.5, 120, 122)];
    nextView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    nextView.hidden = YES;
    [self.view addSubview:nextView];
    
    UIButton *shareQR = [UIButton buttonWithType:UIButtonTypeCustom];
    shareQR.frame = CGRectMake(0, 0, 120, 40);
    [shareQR setTitle:@"分享二维码" forState:UIControlStateNormal];
    [shareQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareQR.titleLabel.font = [UIFont systemFontOfSize:14];
    shareQR.tag = 1;
    [shareQR addTarget:self action:@selector(jumpQR:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:shareQR];
    
    UIView *firstline = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 100, 0.5)];
    firstline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:firstline];
    
    UIButton *keepQR = [UIButton buttonWithType:UIButtonTypeCustom];
    keepQR.frame = CGRectMake(0, 40.5 , 120, 40);
    [keepQR setTitle:@"保存到手机" forState:UIControlStateNormal];
    [keepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    keepQR.titleLabel.font = [UIFont systemFontOfSize:14];
    keepQR.tag = 2;
    [keepQR addTarget:self action:@selector(jumpQR:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:keepQR];
    
    UIView *secondline = [[UIView alloc] initWithFrame:CGRectMake(10, 80.5, 100, 0.5)];
    secondline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:secondline];
    
    
    UIButton *sweepQR = [UIButton buttonWithType:UIButtonTypeCustom];
    sweepQR.frame = CGRectMake(0, 81 , 120, 40);
    [sweepQR setTitle:@"扫一扫" forState:UIControlStateNormal];
    [sweepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sweepQR.titleLabel.font = [UIFont systemFontOfSize:14];
    sweepQR.tag = 3;
    [sweepQR addTarget:self action:@selector(jumpQR:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:sweepQR];
    

    
}
-(void)jumpQR:(UIButton *)bt{
    
    if (bt.tag == 1) {
     
        NSLog(@"分享二维码");
    
    }else if (bt.tag == 2){
        UIImageWriteToSavedPhotosAlbum(imageview.image, self, nil, nil);
        [MBProgressHUD showError:@"二维码保存成功" toView:self.view];
        nextView.hidden = YES;
        markflag = 0;
   
    }else if (bt.tag == 3){
    
        nextView.hidden = YES;
        markflag = 0;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:[[SweepBySweepVC alloc]init] animated:YES];
    }
}
-(void)generatecode {
    
//    NSString *str = [UserInfo getToken];
    
    NSDictionary *dic = @{@"XiaoYingCode":self.profileMyModel.XiaoYingCode};
    NSString *jsonStr = [dic JSONString];
    imageview.image = [QRCodeGenerator qrImageForString:jsonStr imageSize:imageview.width];

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
