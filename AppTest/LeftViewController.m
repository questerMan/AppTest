//
//  LeftViewController.m
//  LYKSlideMenuDemo
//
//  Created by luyikun on 16/9/29.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import "LeftViewController.h"


@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    _arrayData = [NSMutableArray arrayWithArray:@[@"钱包",@"账户",@"行程",@"服务",@"关于"]];
    
    [self creatTableView];
    

    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, MATCHSIZE_S(400), 50)];
//    btn.backgroundColor = [UIColor yellowColor];
//    [btn addTarget:self action:@selector(btnOnclick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//}
//-(void)btnOnclick{
//    NSLog(@"左边视图按钮点击事件");
//    OtherController *otherVC = [[OtherController alloc] init];
//    [self closeLeftViewToNewsViewWithViewController:otherVC andAnimated:YES];

}


-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(MATCHSIZE(0), MATCHSIZE(0), MATCHSIZE_S(500), SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.tableView.scrollEnabled = NO; //设置tableview 不能滚动

    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.rowHeight = MATCHSIZE_S(55);
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(500), MATCHSIZE_S(300))];
    headerView.backgroundColor = [UIColor grayColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(298), MATCHSIZE_S(500), MATCHSIZE_S(2))];
    line.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:line];
    
    UIImageView *userIMG = [[UIImageView alloc] initWithFrame:CGRectMake(MATCHSIZE_S(160), MATCHSIZE_S(10), MATCHSIZE_S(150), MATCHSIZE_S(150))];
    userIMG.image = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userIMG.layer.cornerRadius = MATCHSIZE_S(75);
    userIMG.layer.masksToBounds = YES;
    userIMG.backgroundColor = [UIColor greenColor];
    [headerView addSubview:userIMG];
    
    [_tableView setTableHeaderView:headerView];
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        OtherController *otherVC = [[OtherController alloc] init];
        [self closeLeftViewToNewsViewWithViewController:otherVC andAnimated:YES];
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
