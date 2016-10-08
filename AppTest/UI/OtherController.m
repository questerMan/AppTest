//
//  OtherController.m
//  AppTest
//
//  Created by luyikun on 16/9/29.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import "OtherController.h"

@interface OtherController ()

@end

@implementation OtherController

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他页面";
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(leftback)];
  
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, MATCHSIZE_S(400), 50)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(btnOnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)btnOnclick{
    NSLog(@"按钮点击事件");
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)leftback{
    [self dismissViewControllerAnimated:YES completion:nil];
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
