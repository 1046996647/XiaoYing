//
//  DocumentFounctionVC.m
//  XiaoYing
//
//  Created by GZH on 2017/1/6.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DocumentFounctionVC.h"
#import "DocumentFounctionCell.h"
#import "ModuleModel.h"
@interface DocumentFounctionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *documentIDArray;
@property (nonatomic, strong)NSMutableArray *dataSource;


@property (nonatomic, strong)UITableView *tableView;

@end

@implementation DocumentFounctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];

    [self initbasic];

}


- (void)initData {
    _dataSource = [NSMutableArray arrayWithArray:_tempDataSource];
    _selectedDataSource = [NSMutableArray arrayWithArray:_selectedDataSource];
    _documentIDArray = [NSMutableArray array];
    

}

- (void)initbasic {
    
    self.navigationItem.title = @"配置文档功能";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(beSureAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.rowHeight = 44;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    
}

- (void)beSureAction {
    NSLog(@"-------------------------------------------------------%@",_documentIDArray );
    self.blockArray(_documentIDArray, _selectedDataSource);
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentFounctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DocumentFounctionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageMark.tag = indexPath.row + 666;
    [cell.imageMark addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
       
    ModuleModel *model = _dataSource[indexPath.row];
    NSString *str = _selectedDataSource[indexPath.row];
    [cell getModel:model andSelectedMark:str];
   
    if ([str isEqualToString:@"1"]) {
        [_documentIDArray addObject:model.Id];
    }
    
    return cell;
}



- (void)selectedAction:(UIButton *)sender {
  
    [_documentIDArray removeAllObjects];
  
    NSString *str = _selectedDataSource[sender.tag - 666];
    if ([str isEqualToString:@"1"]) {
        [_selectedDataSource replaceObjectAtIndex:sender.tag - 666 withObject:@"0"];
    }else {
        [_selectedDataSource replaceObjectAtIndex:sender.tag - 666 withObject:@"1"];
    }
    [_tableView reloadData];
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
