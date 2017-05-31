//
//  EditCell.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "EditCell.h"
#import "RecordView.h"
#import "ImageCollectionView.h"
#import "UIColor+Expend.h"
#import "UIViewExt.h"
#import "AudioCell.h"
#import "D3RecordButton.h"

//#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
//#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)

@interface EditCell ()<UITableViewDelegate,UITableViewDataSource,D3RecordDelegate,UITextViewDelegate>
{
    CGFloat width;

}

@property(nonatomic,strong) RecordView *recordView;
@property(nonatomic,strong) ImageCollectionView *pictureCollectonView;
@property(nonatomic,strong) UITableView *riverContentTab;
@property(nonatomic,strong) D3RecordButton *btn;



@end

@implementation EditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.identifier = reuseIdentifier;

        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            
            
            UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, kScreen_Width-24, 44)];
            baseView.layer.cornerRadius = 6;
            baseView.clipsToBounds = YES;
            baseView.layer.borderWidth = .5;
            baseView.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
            [self.contentView addSubview:baseView];
            
            _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, 150, 16)];
            _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
            _titleLab.font = [UIFont systemFontOfSize:16];
            [baseView addSubview:_titleLab];
            
            _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _titleLab.bottom+6, baseView.width-24, 12)];
            _detailLab.textColor = [UIColor colorWithHexString:@"#848484"];
            _detailLab.font = [UIFont systemFontOfSize:12];
            [baseView addSubview:_detailLab];
            
        } else {
            
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;

            
            _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_deleteBtn setImage:[UIImage imageNamed:@"delete_task"] forState:UIControlStateNormal];
            _deleteBtn.frame = CGRectMake(12, 15, 19, 19);
            [self.contentView addSubview:_deleteBtn];
            
            _titleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(_deleteBtn.right+6, 17, 150, 16)];
            _titleLab1.textColor = [UIColor colorWithHexString:@"#333333"];
            _titleLab1.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:_titleLab1];
            
            UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width-(70+12*2+30*3)-12, 15, 70+12*2+30*3, 20)];
//            baseView.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:baseView];
            
            UILabel *taskLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 70, 12)];
            taskLab.text = @"任务比重 : ";
            taskLab.textColor = [UIColor colorWithHexString:@"#848484"];
            taskLab.font = [UIFont systemFontOfSize:14];
            [baseView addSubview:taskLab];
            
            _heightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _heightBtn.frame = CGRectMake(taskLab.right, 0, 30, 20);
            [_heightBtn setTitle:@"高" forState:UIControlStateNormal];
            [_heightBtn setTitleColor:[UIColor colorWithHexString:@"fc5834"] forState:UIControlStateNormal];
            _heightBtn.layer.cornerRadius = 6;
            _heightBtn.clipsToBounds = YES;
            _heightBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            _heightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [baseView addSubview:_heightBtn];
            
            _middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _middleBtn.frame = CGRectMake(_heightBtn.right+12, 0, 30, 20);
            [_middleBtn setTitle:@"中" forState:UIControlStateNormal];
            [_middleBtn setTitleColor:[UIColor colorWithHexString:@"fcc234"] forState:UIControlStateNormal];
            _middleBtn.layer.cornerRadius = 6;
            _middleBtn.clipsToBounds = YES;
            _middleBtn.backgroundColor = [UIColor whiteColor];
            _middleBtn.layer.cornerRadius = 6;
            _middleBtn.layer.borderWidth = .5;
            _middleBtn.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
            _middleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [baseView addSubview:_middleBtn];
            
            _lowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _lowBtn.frame = CGRectMake(_middleBtn.right+12, 0, 30, 20);
            [_lowBtn setTitle:@"低" forState:UIControlStateNormal];
            [_lowBtn setTitleColor:[UIColor colorWithHexString:@"1fc688"] forState:UIControlStateNormal];
            _lowBtn.layer.cornerRadius = 6;
            _lowBtn.clipsToBounds = YES;
            _lowBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            _lowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [baseView addSubview:_lowBtn];
            
            UIView *baseView1 = [[UIView alloc] initWithFrame:CGRectMake(12, _deleteBtn.bottom+8, kScreen_Width-24, 40)];
            baseView1.layer.borderWidth = .5;
            baseView1.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
            [self.contentView addSubview:baseView1];
            
            _tf = [[UITextField alloc] initWithFrame:CGRectMake(12+10, baseView1.top, kScreen_Width-24-10, 40)];
            _tf.font = [UIFont systemFontOfSize:14];
            _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            _tf.placeholder = @"标题";
            _tf.textColor = [UIColor colorWithHexString:@"#333333"];
            [self.contentView addSubview:_tf];
            
            _tv = [[UITextView alloc] initWithFrame:CGRectMake(12, baseView1.bottom-.5, kScreen_Width-24, 312/2.0)];
            _tv.layer.borderWidth = .5;
            _tv.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
            _tv.delegate = self;
            _tv.textColor = [UIColor colorWithHexString:@"#333333"];
            _tv.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_tv];
            
            _decribeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, kScreen_Width-24, 14)];
            _decribeLab.text = @"描述";
            _decribeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
            _decribeLab.font = [UIFont systemFontOfSize:14];
            [_tv addSubview:_decribeLab];
        
            // 录音列表
            _riverContentTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 28, kScreen_Width - 24, _tv.height-28) style:UITableViewStylePlain];
            _riverContentTab.backgroundColor = [UIColor redColor];
            _riverContentTab.delegate=self;
            _riverContentTab.dataSource=self;
            _riverContentTab.hidden = YES;
            _riverContentTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            _riverContentTab.separatorStyle = UITableViewCellSeparatorStyleNone;
            //    _riverContentTab.layer.borderColor = [[UIColor grayColor] CGColor];
            //    _riverContentTab.layer.borderWidth = 0.6;
            [_tv addSubview:_riverContentTab];
        
            // 声音视图
            D3RecordButton *btn = [D3RecordButton buttonWithType:UIButtonTypeCustom];
//                btn.backgroundColor = [UIColor redColor];
            btn.frame = CGRectMake(_tv.left, _tv.bottom-.6, _tv.width, 44);
            btn.layer.borderWidth = .6;
            btn.layer.borderColor = [UIColor colorWithHexString:@"d5d7dc"].CGColor;
            [btn initRecord:self maxtime:60 title:@"上滑取消录音"];
            [self.contentView  addSubview:btn];
            self.btn = btn;
            
            // 图片
//            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [imgBtn setImage:[UIImage imageNamed:@"add_picmov"] forState:UIControlStateNormal];
//            imgBtn.frame = CGRectMake(12, recordView.bottom+12, 60, 60);
//            [self.contentView addSubview:imgBtn];
            width = (kScreen_Width-5*12)/4.0;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.itemSize = CGSizeMake(width, width);
            layout.minimumInteritemSpacing = 12;
            layout.minimumLineSpacing = 12; //上下的间距 可以设置0看下效果
            //创建 UICollectionView
            self.pictureCollectonView = [[ImageCollectionView alloc] initWithFrame:CGRectMake(0, btn.bottom+12, self.contentView.width, width) collectionViewLayout:layout];
//            self.pictureCollectonView.backgroundColor = [UIColor greenColor];

            [self.contentView addSubview:self.pictureCollectonView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if ([self.identifier isEqualToString:@"cell1"]) {
        // 第一种单元格
        _titleLab.text = [NSString stringWithFormat:@"任务%ld : 标题",(long)self.row];
        _detailLab.text = @"任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情";
    } else {
        // 第二种单元格
        _titleLab1.text = [NSString stringWithFormat:@"任务%ld",(long)self.row];
        
        self.pictureCollectonView.model = self.model;
        if (_model.voicesArr.count == 0) {

            _riverContentTab.hidden = YES;

        }
        else {
            _riverContentTab.hidden = NO;
        }
        

    
//        NSLog(@"----++++%@",self.model);
    

    }

//    // 第一种单元格
//    _titleLab.text = [NSString stringWithFormat:@"任务%ld : 标题",self.row];
//    _detailLab.text = @"任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情";
//    
//    // 第二种单元格
//    _titleLab1.text = [NSString stringWithFormat:@"任务%ld",self.row];

    
}

#pragma mark---UITableViewDataSource,UITableViewDelegate
// 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.voicesArr.count;
}

// 区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AudioCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[AudioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deleteBlock = ^(Mp3Recorder *recorder) {
            
            [self.model.voicesArr removeObject:recorder];
            [_riverContentTab reloadData];
            
        };
    }
    
    //            [self.delegate timeStr:[NSString stringWithFormat:@"%ld",(long)currentTime] Url:self.recordTool.recordFileUrl];
    
    
    Mp3Recorder *mp3recorder = self.model.voicesArr[indexPath.row];
    
    NSLog(@"!!!!!%@",mp3recorder.url);
    cell.mp3Recorder = mp3recorder;
    return cell;
}

#pragma mark - D3RecordDelegate
- (void)endRecord:(Mp3Recorder *)recorder
{
    //    VoiceModel *model = [[VoiceModel alloc] init];
    _riverContentTab.hidden = NO; 
    
    [self.model.voicesArr addObject:recorder];
    
    [_riverContentTab reloadData];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _decribeLab.hidden = YES;
        
        CGFloat height = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            CGRect textFrame = [[textView layoutManager] usedRectForTextContainer:[textView textContainer]];
            height = textFrame.size.height+11;
            
        }else {
            
            height = textView.contentSize.height+11;
        }
        
        
        //位置变化
        _riverContentTab.top = height;
        
    } else {
        _decribeLab.hidden = NO;
        
    }
}

//- (void)setModel:(LocalTaskModel *)model
//{
//    if (_model != model) {
//        _model = model;
//        self.pictureCollectonView.model = _model;
//
//        if (_model.voicesArr.count > 0) {
//            _riverContentTab.hidden = NO;
//            [_riverContentTab reloadData];
//            
//        }
//    }
//}


@end
