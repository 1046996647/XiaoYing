//
//  SecretController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/16.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "UniversalController.h"
#import "Switch.h"

@interface UniversalController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionArr;
    NSArray *_cellArr;
    Switch *_switch;
}
@property (nonatomic,strong) MBProgressHUD *hud;


@end

@implementation UniversalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //组标题
    _sectionArr = @[@"提醒",@"联系人-好友",@"清理缓存"];
    
    //单元格内容
    _cellArr = @[@[@"声音",@"震动"],
                 @[@"陌生人可以搜索到我"],
                 @[@"清理缓存"]];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init
                                  ];
    [self.view addSubview:_tableView];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_cellArr[section] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //系统设定的frame(248 10; 51 31)
        _switch = [[Switch alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 51, (50 - 31)/2.0, 0, 0)];
        _switch.on = YES;
        _switch.tag = indexPath.row;
        //分开开关点击事件
        _switch.indexPath = indexPath;
        
        [_switch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    if (indexPath.section != 2) {
        [cell.contentView addSubview:_switch];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _cellArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self clearCaches];

    }
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //组标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 150, 20)];
    sectionLab.font = [UIFont systemFontOfSize:14];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLab.text = _sectionArr[section];
    [view addSubview:sectionLab];
    
    return view;
}

//清理缓存
-(void)clearCaches
{
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"清理中...";
    
    [self performSelector:@selector(clearCacheSuccess) withObject:nil afterDelay:2];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //缓存文件的路径
//        NSString *cachPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
//        NSLog(@"cachPath: %@",cachPath);
//        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//        for (NSString *p in files) {
//            NSError *error;
//            NSString *path = [cachPath stringByAppendingPathComponent:p];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//            }
//        }
//        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];

        
//    });
}

- (void)clearCacheSuccess
{
    [_hud hide:YES];
    [MBProgressHUD showSuccess:@"清理成功" toView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开关事件
- (void)switchValueChanged:(Switch*)control
{
    //开关所在的组
    NSInteger section = control.indexPath.section;
    //开关所在的行
    NSInteger row = control.indexPath.row;
    //开关状态
    BOOL isOn = control.on;
    
    //先分组，再分行，再判断开关状态
    if (section == 0) {
        if (row == 0) {
            if (isOn == 0) {
                //处理事情
                NSLog(@"%d",isOn);
            } else {
                //处理事情
                NSLog(@"%d",isOn);
            }
            NSLog(@"%ld",row);
        } else if (row == 1) {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        } else {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        }
    } else {
        if (row == 0) {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        } else if (row == 1) {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        } else {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        }
    }
    //    NSLog(@"%ld",control.indexPath.section);
    //    NSLog(@"%d",c);
}


@end
