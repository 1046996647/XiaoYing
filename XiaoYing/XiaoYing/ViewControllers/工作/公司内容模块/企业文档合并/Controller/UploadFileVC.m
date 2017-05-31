//
//  UploadFileVC.m
//  XiaoYing
//
//  Created by ZWL on 17/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "UploadFileVC.h"
#import "SelectPlaceVC.h"
#import "TransportDropMethod.h"
#import "DocumentUploadFileModel.h"
#import "NSObject+CalculateUnit.h"
#import "AuthorityForDocumentMethod.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface UploadFileVC ()

@property (nonatomic, strong) UIButton *placeBtn;

@end

@implementation UploadFileVC
{
    NSString *_ratioThumWebUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"上传文件";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //取消Bar按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //设置导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    //消除底部横线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //底部view
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //上传按钮
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(kScreen_Width-70-12, 7, 70, 30);
    [uploadBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    uploadBtn.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    uploadBtn.layer.cornerRadius = 6;
    uploadBtn.layer.masksToBounds = YES;
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [uploadBtn addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:uploadBtn];
    
    //选择上传位置按钮
    self.placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.placeBtn.frame = CGRectMake(12, 7, kScreen_Width-12-(10+70+12), 30);
    self.placeBtn.layer.cornerRadius = 6;
    self.placeBtn.layer.masksToBounds = YES;
    self.placeBtn.layer.borderWidth = .5;
    self.placeBtn.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
    [self.placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //对初始路径权限判断
    if (![self.departmentPlaceId isEqualToString:@" "]) { //个人文档不需要判断
        
        BOOL originBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
            
            auth.regionName(@"上传文件").deparmentId(self.departmentPlaceId);
        }];
        
        self.originFolderPath = originBool? self.originFolderPath : @"";
        
    }
    
    [self.placeBtn setTitle:self.originFolderPath forState:UIControlStateNormal];
    
    [self.placeBtn addTarget:self action:@selector(placeAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:self.placeBtn];
    
    [self setupBaseViewContent];
    
    if (self.ratioThum) {
        [self uploadRatioThum:self.ratioThum name:self.fileName];
    }
    else {
        _ratioThumWebUrl = self.localFileModel.thumbnailUrl;
    }
    

}

//上传缩略图至web资源服务器，获取webUrl
- (void)uploadRatioThum:(UIImage *)ratioThum name:(NSString *)name
{
    NSData *ratioThumData;
    if (UIImagePNGRepresentation(ratioThum) == nil) {
        
        ratioThumData = UIImageJPEGRepresentation(ratioThum, 0.5);
        
    } else {
        
        ratioThumData = UIImagePNGRepresentation(ratioThum);
    }
    
    NSString *encodedFileData = [ratioThumData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/file/FileUpload?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Category"] = @1;
    params[@"Data"] = encodedFileData;
    
    //根据当前系统时间生成图片名称
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",dateString];
    
    params[@"FileName"] = fileName;
    
    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
        
        _ratioThumWebUrl = JSONDict[@"Data"][@"FormatUrl"];
        NSLog(@"url--%@--params--%@", url, params);
        
        NSLog(@"JSONDict[]~~~~%@", JSONDict[@"Data"]);
        
    } failed:^(NSError *error) {
        
        
    }];
}

- (void)setupBaseViewContent
{
    //底部的view
    UIView *messageBaseView = [[UIView alloc] init];
    messageBaseView.frame = CGRectMake(0, 0, kScreen_Width, 50);
    [self.view addSubview:messageBaseView];
    
    //文件的缩略图
    UIImageView *ratoiImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 35, 30)];
//    ratoiImage.image = self.ratioThum;
    NSString *imageURL = [NSString replaceString:self.localFileModel.thumbnailUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [ratoiImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.ratioThum];
    [messageBaseView addSubview:ratoiImage];
    
    //文件名称
    UILabel *fileNameLabel = [[UILabel alloc] init];
    fileNameLabel.frame = CGRectMake(ratoiImage.left+ratoiImage.width+12, 0, 177, 50);
    fileNameLabel.text = self.fileName;
    [messageBaseView addSubview:fileNameLabel];
    
    //文件大小
    UILabel *fileSizeLabel = [[UILabel alloc] init];
    CGFloat fileSizeLabelX = fileNameLabel.left + fileNameLabel.width + 10;
    fileSizeLabel.frame = CGRectMake(fileSizeLabelX, 20, 40, 15);

    // 总文件大小
    NSString *fileSize = [NSString stringWithFormat:@"%.2f%@",
                          [DocumentUploadFileModel calculateFileSizeInUnit:(unsigned long long)self.fileSize],
                          [DocumentUploadFileModel calculateUnit:(unsigned long long)self.fileSize]];
    fileSizeLabel.text = fileSize;
    fileSizeLabel.font = [UIFont systemFontOfSize:12];
    fileSizeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    [messageBaseView addSubview:fileSizeLabel];
    
    
    //删除按钮
    UIButton *extandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    extandBtn.frame = CGRectMake(kScreen_Width-14-12, 0, 26, 40);
    extandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    extandBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    extandBtn.imageEdgeInsets = UIEdgeInsetsMake(21, 0, 0, 0);
    [extandBtn setImage:[UIImage imageNamed:@"deletepicyure-1"] forState:UIControlStateNormal];
    [extandBtn addTarget:self action:@selector(extandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [messageBaseView addSubview:extandBtn];
    
    //lineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fileNameLabel.bottom, kScreen_Width, .5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [messageBaseView addSubview:lineView];
    
}


- (void)extandBtnAction:(UIButton *)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//点击选择文件上传的部门、文件夹
- (void)placeAction
{
    __weak typeof(self) weakSelf = self;
    
    SelectPlaceVC *selectPlaceVC = [[SelectPlaceVC alloc] init];
    selectPlaceVC.navigationItem.title = @"选择上传位置";
    selectPlaceVC.getPlaceBlock = ^(NSString *departmentName, NSString *departmentId, NSString *folderName, NSString *folderId){
        
        NSLog(@"%@,%@,%@,%@", departmentName, departmentId, folderName, folderId);
        weakSelf.departmentPlaceId = departmentId;
        weakSelf.folderPlaceId = folderId;
        NSString *tempStr = [NSString stringWithFormat:@"%@>%@", departmentName, folderName];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [weakSelf.placeBtn setTitle:tempStr forState:UIControlStateNormal];
    };
    
    [weakSelf.navigationController pushViewController:selectPlaceVC animated:YES];
}

//点击开始断点上传
- (void)uploadAction
{
    if (self.placeBtn.currentTitle.length == 0) {
        [MBProgressHUD showMessage:@"请选择上传位置"];
        return;
    }
    
    if ([TransportDropMethod isUploading]) {
        [MBProgressHUD showMessage:@"只支持单个文件上传"];
        return;
    }
    
    if (self.fileInfo) {
        ALAssetsLibrary *DeviceDataLibrary = [[ALAssetsLibrary alloc] init];
        
        [DeviceDataLibrary assetForURL:[self.fileInfo objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            
            //资源图片的详细资源信息
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            
            DocumentUploadFileModel * documentUploadFileModel = [[DocumentUploadFileModel alloc] initWithRepresentation:representation];
            [self uploadModel:documentUploadFileModel];
            
        } failureBlock:^(NSError *error) {
            
            NSLog(@"从相册资源库获取文件失败:%@", error);
        }];
    }
    else {
        DocumentUploadFileModel * documentUploadFileModel = [[DocumentUploadFileModel alloc] initWithModel:self.localFileModel];
        [self uploadModel:documentUploadFileModel];
    }
    

    
}

- (void)uploadModel:(DocumentUploadFileModel *)documentUploadFileModel
{
    __weak typeof(self) weakSelf = self;

    documentUploadFileModel.destributeFloderId = self.folderPlaceId;
    documentUploadFileModel.destributeDepartmentId = self.departmentPlaceId;
    documentUploadFileModel.fileRatioThumWebUrl = _ratioThumWebUrl;
    documentUploadFileModel.place = self.placeBtn.currentTitle;
    
    NSLog(@"documentUploadFileModel.fileName~~~%@", documentUploadFileModel.fileName);
    
    //1.根据文件的name和size从服务器得到文件token
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/bigfile/getToken?name=%@&size=%ld", BaseUrl1,documentUploadFileModel.fileName, (long)documentUploadFileModel.fileSize];
    
    [AFNetClient POST_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"根据文件的name和size从服务器得到文件token%@", urlStr);
        NSLog(@"得到文件token成功%@", JSONDict);
        documentUploadFileModel.fileToken = JSONDict[@"token"];
        documentUploadFileModel.fileWebPath = JSONDict[@"message"];
        
        //为避免信息丢失，保存
        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
        
        //2.开始后台进程将文件断点片传
        [TransportDropMethod uploadDataWithProgressControl];
        
        //3.回到主界面
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } failed:^(NSError *error) {
        
        NSLog(@"得到文件token失败%@", error);
        
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }];
}


- (void)leftAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
