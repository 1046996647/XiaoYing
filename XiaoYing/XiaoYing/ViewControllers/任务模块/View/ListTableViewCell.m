//
//  ListTableViewCell.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "ListTableViewCell.h"
#import "taskModel.h"
#import "HelpMac.h"

@interface ListTableViewCell(){
    NSMutableArray *arr;
}
@end

@implementation ListTableViewCell
/**
 *  ：ListTableViewCell的复用
 *
 *  @param style           用来显示列表
 *  @param reuseIdentifier @“ListCell”
 *
 *  @return cell
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        arr=[[NSMutableArray alloc]init];
        [arr removeAllObjects];
        
        _TitleLab_=[[UILabel alloc]initWithFrame:CGRectMake(55, 15, self.contentView.frame.size.width-150, 17.5)];
        _TitleLab_.font=[UIFont systemFontOfSize:18];
        _TitleLab_.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_TitleLab_];
        
        _TimeLab_=[[UILabel alloc]initWithFrame:CGRectMake(55, 37.5, self.contentView.frame.size.width-150, 8.5)];
        _TimeLab_.font=[UIFont systemFontOfSize:11];
        _TimeLab_.textColor=[UIColor colorWithHexString:@"#848484"];
        [self.contentView addSubview:_TimeLab_];
        
        
        _StateBt=[UIButton buttonWithType:UIButtonTypeCustom];
        _StateBt.frame=CGRectMake(10, 10,40 , 40);
        _StateBt.tag=100;
        [_StateBt addTarget:self action:@selector(selectImportant:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_StateBt];

        _StateBt1=[UIButton buttonWithType:UIButtonTypeCustom];
        _StateBt1.frame=CGRectMake(10, 10,40 , 40);
        _StateBt1.tag=101;
        [_StateBt1 addTarget:self action:@selector(selectImportant:) forControlEvents:UIControlEventTouchUpInside];
        _StateBt1.hidden=YES;
        [self.contentView addSubview:_StateBt1];


        _StateBt2=[UIButton buttonWithType:UIButtonTypeCustom];
        _StateBt2.frame=CGRectMake(10, 10,40 , 40);
        _StateBt2.tag=102;
        _StateBt2.hidden=YES;
        [_StateBt2 addTarget:self action:@selector(selectImportant:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_StateBt2];
        
        
        _ListBt=[UIButton buttonWithType:UIButtonTypeCustom];
        _ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
        [_ListBt setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [_ListBt addTarget:self action:@selector(finishTask_way) forControlEvents:UIControlEventTouchUpInside];
        _ListBt.hidden=NO;
        [self.contentView addSubview:_ListBt];
        
        
        _FinishBt=[UIButton buttonWithType:UIButtonTypeCustom];
        _FinishBt.frame=CGRectMake(kScreen_Width,0,66 ,60);
        [_FinishBt setTitle:@"完成" forState:UIControlStateNormal];
        [_FinishBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _FinishBt.backgroundColor=[UIColor greenColor];
        [_FinishBt addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        _FinishBt.hidden=NO;
        [self.contentView addSubview:_FinishBt];

        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cehua) name:@"FinishNotification1" object:nil];
    }
    return self;
}
/**
 *  选择的任务的重要程度，并将修改的重要程度存储到数据库中
 *
 */
-(void)selectImportant:(UIButton*)bt{

    if (_model.TaskMarkFlag==0) {
       
        //当一个可变数组里面数据进行不断的添加的时候
        [arr removeAllObjects];
        
        if ([_model.TaskImageName isEqualToString:@"green"]) {
            [_StateBt2 setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            [_StateBt1 setImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
            [_StateBt setImage:[UIImage imageNamed:_model.TaskImageName] forState:UIControlStateNormal];
            [arr addObjectsFromArray:@[@"1",@"2",@"3"]];
        }else if ([_model.TaskImageName isEqualToString:@"red"]){
            [_StateBt2 setImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
            [_StateBt1 setImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
            [_StateBt setImage:[UIImage imageNamed:_model.TaskImageName] forState:UIControlStateNormal];
            [arr addObjectsFromArray:@[@"3",@"2",@"1"]];
            
        }else if ([_model.TaskImageName isEqualToString:@"yellow"]){
            [_StateBt2 setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            [_StateBt1 setImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
            [_StateBt setImage:[UIImage imageNamed:_model.TaskImageName] forState:UIControlStateNormal];
            [arr addObjectsFromArray:@[@"2",@"1",@"3"]];
        }
        [UIView animateWithDuration:0.1 animations:^{
            _TitleLab_.frame=CGRectMake(135, 15, self.contentView.frame.size.width-150, 17.5);
            _TimeLab_.frame=CGRectMake(135, 37.5, self.contentView.frame.size.width-150, 8.5);
            _StateBt1.frame=CGRectMake(50, 10,40 , 40);
            _StateBt2.frame=CGRectMake(90, 10,40 , 40);
            _ListBt.frame=CGRectMake(kScreen_Width, 0,40 , 60);
            _StateBt1.hidden=NO;
            _StateBt2.hidden=NO;
            _model.TaskMarkFlag=1;
        } completion:^(BOOL finished) {
            
        }];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ModelTaskMarkFlag" object:self];
    }else{
        NSLog(@"%ld",bt.tag);
        _model.TaskMarkFlag=0;
        if (bt.tag==100) {
            _model.TaskFlag=[arr[0] integerValue];
        }else if (bt.tag==101){
            _model.TaskFlag=[arr[1] integerValue];
        }else if (bt.tag==102){
            _model.TaskFlag=[arr[2] integerValue];
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            _StateBt2.frame=CGRectMake(10, 10,40 , 40);
            _StateBt1.frame=CGRectMake(10, 10,40 , 40);
            _TitleLab_.frame=CGRectMake(55, 15, self.contentView.frame.size.width-150, 17.5);
            _TimeLab_.frame=CGRectMake(55, 37.5, self.contentView.frame.size.width-150, 8.5);
            _ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
        } completion:^(BOOL finished) {
            _StateBt2.hidden=YES;
            _StateBt1.hidden=YES;
          
             [self FixColor];
            
        }];
        
        //修改重要程度返回到服务器
    
        NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
        if ([[userdefaults objectForKey:@"YESORNOTLOGIN"] isEqualToString:@"0"]) {
            _model.TaskUpAndDown=0;
            BOOL sucess = [taskDatabase deleteData:_model.TaskTime];
            if (sucess) {
                NSLog(@"%d",[taskDatabase insertModal:_model]);
            }
            
        }else{
            _model.TaskUpAndDown=1;
            NSNumber *taskid = [NSNumber numberWithInteger:_model.TaskId];
            NSMutableString *urlString = [NSMutableString stringWithString:InsertFlag];
            [urlString appendFormat:@"&taskId=%@&flag=%ld",taskid,(long)_model.TaskFlag];
            [AFNetClient POST_Path:urlString completed:^(NSData *stringData, id JSONDict) {
                
                //数据库里面的数据更新
                
                //        BOOL sucess=[taskDatabase modifyData:model.TaskTime WithFlag:model.TaskFlag];
                //        if (sucess==YES) {
                //            NSLog(@"数据修改成功");
                //        }
                BOOL sucess=[taskDatabase deleteData:_model.TaskTime];
                if (sucess==YES) {
                    
                    NSLog(@"数据库删除数据成功");
                    //将数据更新
                    NSLog(@"%d",[taskDatabase insertModal:_model]);
                }
            } failed:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }
    
}
-(void)FixColor{
    if (_model.TaskFlag==1) {
        [_StateBt setImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
        _model.TaskImageName=@"green";
    }else if (_model.TaskFlag==2){
         [_StateBt setImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _model.TaskImageName=@"yellow";
    }else if (_model.TaskFlag==3){
         [_StateBt setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        _model.TaskImageName=@"red";
    }
    
}
/**
 *给对象赋值
 */
-(void)setModel:(taskModel *)model{
    
    _model=model;
    _TitleLab_.text=model.TaskTitle;
    _TimeLab_.text=model.TaskTime;
   
    if (model.TaskFlag==1||model.TaskFlag==0){
        model.TaskImageName = @"green";
        model.TaskFlag=1;
    } else if(model.TaskFlag==3){
        model.TaskImageName = @"red";
        model.TaskFlag=3;
    } else{
        model.TaskImageName = @"yellow";
        model.TaskFlag=2;
    }
    
    [_StateBt setImage:[UIImage imageNamed:model.TaskImageName] forState:UIControlStateNormal]; ;
}
/**
 *  点击右边的说明的时候调用的方法
 */
static int flag;
-(void)finishTask_way{
    if (flag==0) {
        _ListBt.hidden=YES;
        [UIView animateWithDuration:0.1 animations:^{
            _FinishBt.frame=CGRectMake(kScreen_Width-66,0,66 ,60);
            _TitleLab_.frame=CGRectMake(55-40, 15, self.contentView.frame.size.width-150, 17.5);
            _TimeLab_.frame=CGRectMake(55-40, 37.5, self.contentView.frame.size.width-150, 8.5);
            _StateBt.frame=CGRectMake(10-40, 10,40 , 40);
        } completion:^(BOOL finished) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishNotification" object:self];
            
        }];
    }
}
/**
 *  任务修改其状态;如果点击状态完成则，在界面中不作显示，在数据库中内容改为model.taskState=99;
 */
-(void)finish{
    
    _ListBt.hidden=NO;
    _FinishBt.frame=CGRectMake(kScreen_Width,0,66 ,60);
    _model.TaskState = 99;
  
    BOOL sucess = [taskDatabase deleteData:_model.TaskTime];
    if (sucess) {
        NSLog(@"%d",[taskDatabase insertModal:_model]);
    }
    //同时做刷新tableview来显示刷新后的数据
    /**
     *  表示已经完成的任务
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishButtonNotification" object:self];
}
/**
 *  FinishNotification1,通知名字，当发送通知的时候改变这个方法
 */
-(void)cehua{
    _ListBt.hidden=NO;
    [UIView animateWithDuration:0.1 animations:^{
        _FinishBt.frame=CGRectMake(kScreen_Width,0,66 ,60);
        _TitleLab_.frame=CGRectMake(55, 15, self.contentView.frame.size.width-150, 17.5);
        _TimeLab_.frame=CGRectMake(55, 37.5, self.contentView.frame.size.width-150, 8.5);
        _StateBt1.frame=CGRectMake(10, 10,40 , 40);
        _StateBt2.frame=CGRectMake(10, 10,40 , 40);
        _StateBt.frame=CGRectMake(10, 10,40 , 40);
        _ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
        _StateBt1.hidden=YES;
        _StateBt2.hidden=YES;
         _model.TaskMarkFlag=0;
    } completion:^(BOOL finished) {
        
    }];

}

@end
