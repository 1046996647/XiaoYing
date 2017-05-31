//
//  LocalFileForUpload.m
//  XiaoYing
//
//  Created by GZH on 2017/1/17.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "LocalFileForUpload.h"
#import "ZFDownloadManager.h"
#import "LocalFileCell.h"

@interface LocalFileForUpload ()

@property (nonatomic, strong)NSMutableArray *downloadedArray;
@property (nonatomic, strong)ZFSessionModel *tempModel;

@end

@implementation LocalFileForUpload

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"本地文档";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *beSureItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    beSureItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = beSureItem;
    
    //设置导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    //消除底部横线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
     _downloadedArray = [ZFDownloadManager sharedInstance].downloadedArray;
    for (ZFSessionModel *downloadModel in _downloadedArray) {
        downloadModel.isSelected = NO;
    }
    
}

- (void)leftBarButtonAction {
    _tempModel = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_documentIDBlock) {
            _documentIDBlock(_tempModel);
        }
    }];
}

- (void)rightBarButtonAction {
    
    NSLog(@"-------------------------------------------------------%@", _tempModel.fileName);

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_documentIDBlock) {
            _documentIDBlock(_tempModel);
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _downloadedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocalFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoaclFileCELL"];
    if (!cell) {
        cell = [[LocalFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoaclFileCELL"];
    }
    
    cell.type = @"1";
    
    [cell.extandBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.extandBtn.tag = indexPath.row + 234;
    
    ZFSessionModel *downloadModel = _downloadedArray[indexPath.row];
    cell.model = downloadModel;
    
    return cell;
}


- (void)selectedAction:(UIButton *)sender {
    ZFSessionModel *downloadModel = _downloadedArray[sender.tag - 234];
    _tempModel = downloadModel;

    for (ZFSessionModel *downloadModel in _downloadedArray) {
        downloadModel.isSelected = NO;
    }
    downloadModel.isSelected = !downloadModel.isSelected;
    
    [self.tableView reloadData];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
