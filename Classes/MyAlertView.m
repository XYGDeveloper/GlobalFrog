//
//  MyAlertView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/29.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        backView = [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 4;
        backView.clipsToBounds = YES;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@30);
            make.right.equalTo(@-30);
            make.center.equalTo(@(self.hidden/2));
            make.height.equalTo(@150);
        }];
        
        titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@20);
        }];
        
        msgLabel = [UILabel new];
        msgLabel.numberOfLines = 2;
        msgLabel.textColor = titleLabel.textColor;
        msgLabel.font = [UIFont systemFontOfSize:14];
        [backView addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(20));
            make.right.equalTo(@-20);
            make.top.equalTo(titleLabel.mas_bottom).offset(13);
        }];
        
        
        okBut = [UIButton buttonWithType:(UIButtonTypeSystem)];
        okBut.tintColor = AppStyleColor;
        [okBut addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:okBut];
        [okBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@45);
        }];
        
        UIView * linView = [UIView new];
        linView.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:linView];
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(okBut.mas_top);
        }];
    }
    return self;
}

-(void)dismiss{
    [self removeFromSuperview];
}

-(void)showWithShoppingCar{
    titleLabel.text = @"运费规则说明";
    msgLabel.text = @"运费与配送方式及配送地址相关，最终运费以填写订单为准";
    [okBut setTitle:@"我知道了" forState:NO];
    [[AppDelegate APP].window addSubview:self];
}

@end
