//
//  LeftTableViewCell.m
//  AppTest
//
//  Created by luyikun on 16/9/30.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
        
    }
    return self;
}

-(void)creatUI{
    
    self.backgroundColor = [UIColor grayColor];
    
    _IMGView = [[UIImageView alloc] initWithFrame:CGRectMake(MATCHSIZE_S(20), MATCHSIZE_S(10), MATCHSIZE_S(35), MATCHSIZE_S(35))];
    [self.contentView addSubview:_IMGView];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(MATCHSIZE_S(100), MATCHSIZE_S(10), MATCHSIZE_S(400), MATCHSIZE_S(35))];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    [_titleLable setTextColor:[UIColor whiteColor]];
    _titleLable.font = [UIFont systemFontOfSize:MATCHSIZE_S(30)];
    [self.contentView addSubview:_titleLable];
}
-(void)setDataWithImage:(UIImage *)img
               andTitle:(NSString *)title{
    
    _IMGView.image = img;
    
    _titleLable.text = title;
    NSLog(@" title %@",title);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
