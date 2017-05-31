//
//  RecordCell.m
//  XiaoYing
//
//  Created by ZWL on 16/5/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "RecordCell.h"
#import "PlayView.h"
#import "ImageCollectionViewCell.h"
#import "RecordVC.h"

@interface RecordCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UILabel *_timeLab;
    UIView *_baseView;
    UILabel *_titleLab;
    UILabel *_opinionLab;
    UILabel *_stateLab;
    PlayView *_playView;
    UIButton *_changeBtn;
    UIView *_lineView;
    UILabel *_taskLab;
    CGFloat width;

}

@end

@implementation RecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubviews];
        
    }
    return self;
}

- (void)initSubviews
{
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab.font = [UIFont systemFontOfSize:10];
    _timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [self.contentView addSubview:_timeLab];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectZero];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.contentView addSubview:_baseView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:_titleLab];
    
    _opinionLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _opinionLab.font = [UIFont systemFontOfSize:12];
    _opinionLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:_opinionLab];
    
    _stateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _stateLab.font = [UIFont systemFontOfSize:14];
    _stateLab.textAlignment = NSTextAlignmentRight;
//    _stateLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:_stateLab];
    
    // 播放语音视图
    _playView = [[PlayView alloc] initWithFrame:CGRectZero];

//    PlayView *playView = [[PlayView alloc] initWithFrame:CGRectMake(10, _detailLab.bottom+6, _baseView.width-20, 30)];
    //    playView.contentURL = url;
    [_baseView addSubview:_playView];
    
    //分割线
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
//    _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _playView.bottom, _baseView.width, .5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:_lineView];
    
    _taskLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _taskLab.font = [UIFont systemFontOfSize:12];
    _taskLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:_taskLab];
    
    width = ((self.contentView.width-24)-5*12)/4.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12; //上下的间距 可以设置0看下效果
    
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.pictureCollectonView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
    [self.pictureCollectonView registerClass:[ImageCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    self.pictureCollectonView.backgroundColor = [UIColor clearColor];
    self.pictureCollectonView.delegate = self;
    self.pictureCollectonView.dataSource = self;
    //            self.pictureCollectonView.backgroundColor = [UIColor greenColor];
    [_baseView addSubview:self.pictureCollectonView];
    
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_changeBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
    [_changeBtn setImage:[UIImage imageNamed:@"opinion_read"] forState:UIControlStateNormal];
    [_changeBtn setImage:[UIImage imageNamed:@"opinion_reading"] forState:UIControlStateSelected];
    [_changeBtn addTarget:self action:@selector(chengeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_changeBtn];
    
}

- (void)chengeAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.model.isSelected = btn.selected;
    
    RecordVC *recordVC = (RecordVC *)self.viewController;
    [recordVC relodTableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _timeLab.frame = CGRectMake(12, 20, 200, 10);
    _timeLab.text = @"2016-11-12 21:00";
    
    _baseView.frame = CGRectMake(12, _timeLab.bottom+6, self.width-24, 0);
    
    _titleLab.frame = CGRectMake(10, 10, _baseView.width-20, 14);
    _titleLab.text = @"批改意见";
    
    _opinionLab.frame = CGRectMake(10, _titleLab.bottom+6, _baseView.width-20, 14);
    _opinionLab.text = @"批改建议批改建议批改建议批改建议批改建议批改建议批改建议";
    
    _stateLab.frame = CGRectMake(_baseView.width-40-10, _titleLab.top, 40, 14);
    _stateLab.textColor = [UIColor colorWithHexString:@"#f99740"];
    _stateLab.text = @"重交";
    
    _playView.frame = CGRectMake(10, _opinionLab.bottom+6, _baseView.width-50, 30);
    _playView.timeStr = @"60";

    
    _changeBtn.frame = CGRectMake(_baseView.width-(21/2)-10, _playView.top+10, 21/2, 25/2);
    

    _lineView.frame = CGRectMake(10, _playView.bottom+10, _baseView.width-20, .5);
    
    _taskLab.frame = CGRectMake(10, _lineView.bottom+10, _baseView.width-20, 14);
    _taskLab.text = @"成果成果成果成果成果成果成果成果成果成果成果成果";
    
    self.pictureCollectonView.frame = CGRectMake(0, _taskLab.bottom+6, self.width-24, width);
    
//    _baseView.height = self.pictureCollectonView.bottom+10;
    
    if (self.model.isSelected) {
        _changeBtn.selected = YES;
        _lineView.hidden = NO;
        _taskLab.hidden = NO;
        self.pictureCollectonView.hidden = NO;
        _baseView.height = self.pictureCollectonView.bottom+10;
        
    } else {
        _changeBtn.selected = NO;
        _lineView.hidden = YES;
        _taskLab.hidden = YES;
        self.pictureCollectonView.hidden = YES;
        _baseView.height = _playView.bottom+10;

    }

}

#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"003"];
    
    return cell;

}



@end
