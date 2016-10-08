//
//  BottomView.m
//  AppTest
//
//  Created by luyikun on 16/10/1.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *topView;
@property (nonatomic ,strong) NSMutableArray *arrayData;
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
        [self creatTopView];
      
        [self creatTableView];
        
    }
    return self;
}
-(void)creatTopView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    _topView .frame = CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(750), SCREEN_HEIGHT);
    _topView.backgroundColor = [UIColor blackColor];
    _topView.alpha = 0.5;
    [self addSubview:_topView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [_topView addGestureRecognizer:tap];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
    }];
}

-(void)closeView:(UITapGestureRecognizer *)closeTap{
 
    if (_closeBlock) {
        _closeBlock();
    }
}





-(void)creatTableView{
    _arrayData = [NSMutableArray arrayWithArray:@[@"出发",@"终点",@"车型",@"时间",@"电话"]];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(750), MATCHSIZE_S(800)) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.rowHeight = MATCHSIZE_S(55);
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    [self addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(MATCHSIZE_S(800));
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    [cell setDataWithImage:[UIImage imageNamed:@"starLocation"] andTitle:_arrayData[indexPath.row]];
    return cell;
}

@end
