//
//  UniversalController.m
//  XiaoYing
//
//  Created by ZWL on 15/12/15.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "CompanyFileManageController.h"
#import "FileManageTableView.h"
#import "CreateFolderController.h"
#import "MoveController.h"
#import "DeleteDocumentController.h"
#import "CompanyFileManageModel.h"
#import "VisibleRangeVC.h"
#import "UPloadManagerVC.h"
#import "AlertViewVC.h"
#import "FilleMorechooseVC.h"

#import "DocumentViewModel.h"
#import "DocumentModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DocumentUploadFileModel.h"

#import "XYExtend.h"
#import "FileManagerSearchTableView.h"//搜索tableView
#import "UITableView+showMessageView.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface CompanyFileManageController()<UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) FileManageTableView *tableView;
@property (nonatomic, strong) AlertViewVC *alertVC;  //推出的Alertview
@property (nonatomic, strong) UIView *baseView; //底部上传,上传管理视图
@property (nonatomic, strong) UPloadManagerVC *upLoadManagerVC; //上传管理VC

@property (nonatomic, strong) UISearchBar *searchBar;//查找控件
@property (nonatomic, strong) NSMutableArray *fileSearchArray; //搜索栏的搜索结果数组
@property (nonatomic, strong) FileManagerSearchTableView *fileSearchTableView; //搜索结果展示的tableView

@end

@implementation CompanyFileManageController
@synthesize fileSearchArray = _fileSearchArray;

- (UPloadManagerVC *)upLoadManagerVC
{
    if (!_upLoadManagerVC) {
        _upLoadManagerVC = [[UPloadManagerVC alloc] init];
    }
    return _upLoadManagerVC;
}

- (NSString *)parentFolderId
{
    if (!_parentFolderId) {
        _parentFolderId = @"";//初始化默认值
    }
    return _parentFolderId;
}

- (NSMutableArray *)fileSearchArray
{
    if (!_fileSearchArray) {
        _fileSearchArray = [NSMutableArray array];
    }
    return _fileSearchArray;
}

- (void)setFileSearchArray:(NSMutableArray *)fileSearchArray
{
    _fileSearchArray = fileSearchArray;
    
    //将数据传递给tableView，作为其展示view的数据源
    self.fileSearchTableView.fileSearchArray = fileSearchArray;
}

- (FileManagerSearchTableView *)fileSearchTableView
{
    if (!_fileSearchTableView) {
        _fileSearchTableView = [[FileManagerSearchTableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
        _fileSearchTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    }
    return _fileSearchTableView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.searchBar.top != 0) {//如果还在搜索阶段，隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];

    [self setupBasicTableView];
    
    //表的头视图
    [self setupHeaderView];
    
    //上传,上传管理工具条的初始化
    [self setupBottomView];
    
    //导航栏的多选按钮
    [self setupNavigationRightBtn];

    //根据文件夹id查看该文件夹包含的文件夹以及文件
    [self getDocumentDataList];
}

- (void)refreshDocumentTableView
{
    //根据文件夹id查看该文件夹包含的文件夹以及文件
    [self getDocumentDataList];
}

// 根据文件夹id查看该文件夹包含的文件夹以及文件
- (void)getDocumentDataList
{
    [DocumentViewModel getDocumentListDataWithFolderId:self.parentFolderId success:^(NSArray *documentListArray) {
        //根据传过来测总的文档数据，按文件夹和文件两种类型进行分类
         NSMutableArray *folderArray = [NSMutableArray array];
         NSMutableArray *fileArray = [NSMutableArray array];
         for (DocumentModel *documentModel in [DocumentModel getModelArrayFromModelArray:documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }else { //代表文件
                [fileArray addObject:documentModel];
            }
        }
        
        NSLog(@"folderArray~~%@", folderArray);
        NSLog(@"FileArray~~%@", fileArray);
        
        self.tableView.folderSectionArray = [self sortFolderArrayWithNameFromOriginArray:folderArray];
        self.tableView.completeFileSectionArray = [self sortFileArrayWithTimeFromOriginArray:fileArray];
        
        NSLog(@"self.tableView.folderSectionArray~~%@", [self sortFolderArrayWithNameFromOriginArray:folderArray]);
        NSLog(@"self.tableView.completeFileSectionArray~~%@", [self sortFileArrayWithTimeFromOriginArray:fileArray]);
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

//tableView的设置
- (void)setupBasicTableView
{
    _tableView=[[FileManageTableView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height-64-44-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

//导航栏的多选按钮(moreChooseAction)
- (void)setupNavigationRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"多选" forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(moreChooseAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

//点击多选按钮
- (void)moreChooseAction
{
    NSLog(@"多选");
    FilleMorechooseVC *fileVC = [[FilleMorechooseVC alloc]init];
    fileVC.parentFolderId = self.parentFolderId;
    [self.navigationController pushViewController:fileVC animated:NO];
}

//新建文件夹
- (void)addFolderNew
{
    CreateFolderController *createFolderController = [[CreateFolderController alloc] init];
    createFolderController.parentFolderId = self.parentFolderId;
    createFolderController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    createFolderController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    createFolderController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:createFolderController animated:YES completion:nil];
}

//上传,上传管理工具条的初始化
- (void)setupBottomView {
    
    //滑动视图引起的特殊位置，再减64
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:topView];
    
    NSArray *titleArr = @[@"上传",@"上传管理"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(kScreen_Width/2.0), 0, kScreen_Width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:btn];
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 0.5 , 8, 1, 28)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:lineView];
}


//表的头视图
- (void)setupHeaderView
{
    //背景view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //新建文件夹按钮(addFolderNew)
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(12, 11, 25, 21);
    [addbtn setImage:[UIImage imageNamed:@"folderjia"] forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addFolderNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbtn];
    
    //一根竖线
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(addbtn.right + 12, 9, 1, 26)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    viewLine.alpha = 0.4;
    [self.view addSubview:viewLine];

    //排序文件按钮(srotDataArray)
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(viewLine.right + 12, 11, 25, 21);
    [sortBtn setImage:[UIImage imageNamed:@"sorting"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(srotDataArray) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortBtn];
    
    //一根竖线
    UIView *viewLineT = [[UIView alloc]initWithFrame:CGRectMake(sortBtn.right + 12, 9, 1, 26)];
    viewLineT.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    viewLineT.alpha = 0.4;
    [self.view addSubview:viewLineT];
    
    //搜索栏
    __weak typeof(self) weakSelf = self;
    HSSearchTableView *searchTableView = [[HSSearchTableView alloc] initWithPreviousViewController:self searchResultTableView:self.fileSearchTableView searchResultDataArray:self.fileSearchArray searchHappenBlock:^{
        
        //从服务器搜索
        [DocumentViewModel searchDocumentWithKeyText:weakSelf.searchBar.text success:^(NSArray *documentListArray) {
            
            NSMutableArray *fileArray = [NSMutableArray array];
            for (DocumentModel *documentModel in [DocumentModel getModelArrayFromModelArray:documentListArray]) {
                if (documentModel.documentType != 0) { //代表不是文件夹
                    [fileArray addObject:documentModel];
                }
            }
            weakSelf.fileSearchArray = fileArray.mutableCopy;
            
            //如果没有搜索结果的时候，显示没有搜索到结果图片
            [weakSelf.fileSearchTableView tableViewDisplayNotFoundViewWithRowCount:weakSelf.fileSearchArray.count];
            
        } failed:^(NSError *error) {
            
            
        }];
        
        
    }];
    [self.view addSubview:searchTableView];//只是为了长持有
    self.searchBar = searchTableView.searchBar;
    searchTableView.beforeShowSearchBarFrame = CGRectMake(viewLineT.right + 6, 0, kScreen_Width - viewLineT.left - 12, 44);
    self.searchBar.frame = CGRectMake(viewLineT.right + 6, 0, kScreen_Width - viewLineT.left - 12, 44);
    self.searchBar.placeholder = @"查找文档";
    [self.view addSubview:self.searchBar];
    
    //tableView的headerView
    //_tableView.tableHeaderView = view;
    
}

//按时间排序按钮
- (void)srotDataArray
{
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    
    __weak typeof(self)weakSelf = self;
    
    _alertVC = [[AlertViewVC alloc] init];
    
    [_alertVC addAlertMessageWithAlertName:@"按时间顺序排序" andEventBlock:^{
        
        weakSelf.tableView.completeFileSectionArray = [weakSelf sortFileArrayWithTimeFromOriginArray:weakSelf.tableView.completeFileSectionArray];
        NSLog(@"按时间顺序排序");
    }];
    
    [_alertVC addAlertMessageWithAlertName:@"按名称顺序排序" andEventBlock:^{
        
        weakSelf.tableView.completeFileSectionArray = [weakSelf sortFileArrayWithNameFromOriginArray:weakSelf.tableView.completeFileSectionArray];
        NSLog(@"按名称顺序排序");
    }];
    
    [_alertVC addAlertMessageWithAlertName:@"取消" andEventBlock:^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    _alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_alertVC animated:YES completion:nil];
}

- (void)bottomBtnAction:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"上传"]) { //点击上传直接进入相册
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
            [self presentViewController:picker animated:YES completion:nil];
            
        } else {
            NSLog(@"模拟无效,请真机测试");
        }
       
    }else { //点击上传管理
        
        UPloadManagerVC *upLoadManagerVC = [[UPloadManagerVC alloc] init];
        
        [self.navigationController pushViewController:upLoadManagerVC animated:YES];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
    
}

/**一次性上传
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //判断媒体的来源，如果是拍照所得，先将它存储在系统相册
    
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    NSLog(@"image~~~%@", image);
    
    //根据当前系统时间生成图片名称
    NSString *fileName = [[NSString alloc] init];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    fileName = [[formatter stringFromDate:date] stringByAppendingPathExtension:@"png"];
    
    //将image转换成二进制格式的NSData数据
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil)
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    //上传该图片
    [DocumentViewModel uploadFileWithFileName:fileName fileType:2 fileData:imageData destributeFolderId:self.parentFolderId creatorId:[UserInfo userID] success:^(NSDictionary *dataList) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"上传企业文档管理的图片成功:%@", dataList);
        
    } failed:^(NSError *error) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"上传企业文档管理的图片失败:%@", error);
    }];
}
**/

//**续点上传
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ALAssetsLibrary *DeviceDataLibrary = [[ALAssetsLibrary alloc] init];
    
    NSLog(@"[info objectForKey:UIImagePickerControllerReferenceURL]~~%@", [info objectForKey:UIImagePickerControllerReferenceURL]);
    //NSLog(@"[info objectForKey:UIImagePickerControllerReferenceURL]~~%@", [info objectForKey:UIImagePickerControllerMediaURL]);  只有选择的是视频的时候，该值才不为null。图片的话为null
    
    __weak typeof(self)weakSelf = self;
    
    [DeviceDataLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        DocumentUploadFileModel * documentUploadFileModel = [[DocumentUploadFileModel alloc] initWithRepresentation:representation];
        documentUploadFileModel.destributeFloderId = weakSelf.parentFolderId;
        
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
            [weakSelf uploadDataWithProgressControl];
            
            //3.回到主界面
            [picker dismissViewControllerAnimated:YES completion:nil];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        } failed:^(NSError *error) {
            
            NSLog(@"得到文件token失败%@", error);
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        }];
  
    } failureBlock:^(NSError *error) {
        
        NSLog(@"从相册资源库获取文件失败:%@", error);
    }];
    
}
//**/

- (void)beginOrRestoreUpload
{
    [self uploadDataWithProgressControl];
}

- (void)uploadDataWithProgressControl
{
    __block DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    NSLog(@"uploadPause~~%d", documentUploadFileModel.uploadPause);
    
    __weak typeof(self)weakSelf = self;
    
    //确定该documentUploadFileModel已经上传的节点
    NSInteger currentDrop = 0;
    NSLog(@"documentUploadFileModel.fileDropStateArray~~%@", documentUploadFileModel.fileDropStateArray);
    for (int i = 0; i < documentUploadFileModel.fileDropStateArray.count; i ++) {
        if ([documentUploadFileModel.fileDropStateArray[i] isEqualToNumber:@0]) {
            currentDrop = i;
            NSLog(@"currentDrop~~%ld", (long)currentDrop);
            break;
        }
    }
    
    //文件在沙盒中的路径
    NSLog(@"documentUploadFileModel.fileHomePath~~%@", documentUploadFileModel.fileHomePath);
    
    //根据documentUploadFileModel的沙盒路径，让NSFileHandle持有控制该文件
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:documentUploadFileModel.fileHomePath];
    
    //确定好这一次读取文件的开始位置
    [readHandle seekToFileOffset:documentUploadFileModel.fileOffSize * currentDrop];
    
    //每一次都读取一个片段，最后一个片段的大小会自动以实际的大小为准
    NSData *currentData = [readHandle readDataOfLength:documentUploadFileModel.fileOffSize];
    
    //读完后，关闭该文件
    [readHandle closeFile];
    
    NSLog(@"documentUploadFileModel.filePath~~%@", documentUploadFileModel.filePath);
    NSLog(@"documentUploadFileModel.fileOffSize```%lu",(long)documentUploadFileModel.fileOffSize);
    NSLog(@"(unsigned long)currentData.length```%lu",(unsigned long)currentData.length);
    
    //将这次的文件片段数据按base64格式编码，并将此作为这次POST请求的body参数
    NSString *encodedFileData = [currentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    paramDic[@"Data"] = encodedFileData;
    
    //确定好POST请求的路径，此处需要用到documentUploadFileModel的文件Token
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/bigfile/upload?token=%@", BaseUrl1, documentUploadFileModel.fileToken];
    
    if (currentDrop < documentUploadFileModel.fileChunks) {
        
        [AFNetClient POST_Path:urlStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
            
            NSLog(@"%@",JSONDict);
            
            //已经上传的大小，用比例显示
            NSInteger completeNum = [JSONDict[@"start"] integerValue];
            documentUploadFileModel.fileCompleteUploadNum = completeNum / 1024;
            NSLog(@"上传进度~~%ld/%ld", (long)completeNum, (long)documentUploadFileModel.fileSize);
            
            //上传的速度，只有开始上传的时候才能计算
//            NSTimeInterval gapUploadTime = [NSDate date].timeIntervalSince1970 - documentUploadFileModel.fileDropUploadTime;
//            NSInteger uploadSpeed = (documentUploadFileModel.fileOffSize / 1024) / gapUploadTime;
//            documentUploadFileModel.fileUploadSpeed = uploadSpeed;
//            NSLog(@"%ldKB/S", (long)uploadSpeed);
            
            //文件片段的状态的更改
            documentUploadFileModel.fileDropStateArray[currentDrop] = @1;
            
            //记录下这个片段上传成功后的时刻
//            documentUploadFileModel.fileDropUploadTime = [NSDate date].timeIntervalSince1970;
            
            //归档前，需要
            DocumentUploadFileModel *tempUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
            documentUploadFileModel.uploadPause = tempUploadFileModel.uploadPause;
            
            //这个文件片段已经成功上传，为避免信息丢失，保存
            [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
            
            //每完成一个片段的上传，就发出广播,代号@"CompanyFileUploadProgressNotification"
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:@"CompanyFileUploadProgressNotification" object:nil];
            
            documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
            
            //如果不是最后一个文件片段，就继续循环
            if (!(currentDrop == documentUploadFileModel.fileChunks - 1)) {
                
                //每一次循环前，检测下是否按下暂停按钮
#warning 将这个判断的依据来源，放进模型中
                if (documentUploadFileModel.uploadPause == NO) {
                    [weakSelf uploadDataWithProgressControl];
                }else {
                    return ;
                }
                
            }else {
            
                NSLog(@"文件已经上传完成");
                documentUploadFileModel.fileCompleteUploadNum = documentUploadFileModel.fileSize / 1024;
                documentUploadFileModel.fileUploadSpeed = 0;
                //这个文件片段已经成功上传，为避免信息丢失，保存
                [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
                
                //每完成一个片段的上传，就发出广播,代号@"CompanyFileUploadProgressNotification"
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:@"CompanyFileUploadProgressNotification" object:nil];
                
                //将文件上传至企业文档管理，返回该文件的id
                NSString *url = [NSString stringWithFormat:@"%@/api/doc/upload?Token=%@", BaseUrl1, [UserInfo getToken]];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"Name"] = documentUploadFileModel.fileName;
                params[@"Type"] = [NSNumber numberWithInteger:2];
                params[@"Url"] = documentUploadFileModel.fileWebPath;
                params[@"CatalogId"] = documentUploadFileModel.destributeFloderId;
                params[@"CompanyId"] = [UserInfo getCompanyId];
                params[@"Size"] = [NSNumber numberWithInteger:(documentUploadFileModel.fileSize / 1024)];
                params[@"Creator"] = [UserInfo userID];
                
                [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {

                    NSLog(@"文件上传至企业文档管理成功old:%@---%@", url, params);
                    
                    NSLog(@"文件上传至企业文档管理成功:%@", JSONDict);
                    //文件上传完成后，将该文件在沙盒中删除
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [fileManager removeItemAtPath:documentUploadFileModel.fileHomePath error:nil];
                    
                    
                } failed:^(NSError *error) {
                    
                    NSLog(@"文件上传至企业文档管理失败:%@", error);
                    
                }];
                
            }
            
        } failed:^(NSError *error) {
            
            NSLog(@"错了错啦%@", error);
            
        }];
    }

}

// 用户选择取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//_______________________
- (NSMutableArray *)sortFolderArrayWithNameFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentName];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

- (NSMutableArray *)sortFileArrayWithNameFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentName];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

- (NSMutableArray *)sortFileArrayWithTimeFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *timeArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [timeArray addObject:model.documentCreateTime];
    }
    return [NSMutableArray SortOfTimeWithArray:timeArray AndTargetArray:originArray];
}

@end
