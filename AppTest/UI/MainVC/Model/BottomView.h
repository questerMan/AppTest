//
//  BottomView.h
//  AppTest
//
//  Created by luyikun on 16/10/1.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BottomViewBlock)();

@interface BottomView : UIView

@property (nonatomic,copy) BottomViewBlock closeBlock;

@end
