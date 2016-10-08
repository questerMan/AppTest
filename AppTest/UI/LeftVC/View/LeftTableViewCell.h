//
//  LeftTableViewCell.h
//  AppTest
//
//  Created by luyikun on 16/9/30.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *IMGView;
@property (nonatomic,strong) UILabel *titleLable;

-(void)setDataWithImage:(UIImage *)img
               andTitle:(NSString *)title;
@end
