//
//  RealNameView.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "RealNameView.h"
#define ORDER_CONFIRM_BACKGROUND_COLOR [UIColor whiteColor]
#define ORDER_CONFIRM_LEFT_MARGIN 12.0
#define ORDER_CONFIRM_RRIGHT_MARGIN 12.0
#import "RealListModel.h"
@interface RealNameView ()


@end

@implementation RealNameView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
      
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgButton];
        [self.bgButton addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.realNameAuthoLabel = [[UILabel alloc]init];
        
        self.realNameAuthoLabel.backgroundColor = [UIColor clearColor];
        
        self.realNameAuthoLabel.font = Font(13);
        self.realNameAuthoLabel.textColor = TextColor2;
        self.realNameAuthoLabel.text = @"实名认证";
        [self addSubview:self.realNameAuthoLabel];
        self.isDefaultLabel = [[UILabel alloc]init];
        
        self.isDefaultLabel.backgroundColor = [UIColor clearColor];
        
        self.isDefaultLabel.font = Font(12);
        self.isDefaultLabel.textColor = TextColor2;
        self.isDefaultLabel.text = @"默认";
        self.isDefaultLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = Font(13);
        self.nameLabel.textColor = TextColor2;
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLabel];
        self.rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_rightArrow"]];
        [self addSubview:_rightArrowView];
        
        if (!self.defaultTagView) {
            self.defaultTagView = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.defaultTagView setImage:[UIImage imageNamed:@"vip_name_selected"] forState:UIControlStateNormal];
            [self.defaultTagView setTitle:@"默认" forState:UIControlStateNormal];
            [self.defaultTagView setTitleColor:AppStyleColor forState:UIControlStateNormal];
            self.defaultTagView.titleLabel.font = Font(11);
            self.defaultTagView.adjustsImageWhenHighlighted = NO;
            
            self.defaultTagView.layer.cornerRadius = 2.0;
            self.defaultTagView.layer.masksToBounds = YES;
            self.defaultTagView.layer.borderColor = AppStyleColor.CGColor;
            self.defaultTagView.layer.borderWidth = 1.0;
        }
        
        [self addSubview:self.defaultTagView];
        
        [self configLayout];
        
    }
    
    return self;

}

- (void)refreshWithRealNameAuthoTips:(RealListModel *)model
{

    self.nameLabel.text = model.realname;
    if ([model.is_default isEqualToString:@"1"]) {
        self.defaultTagView.hidden = NO;
        
    }else
    {
        self.defaultTagView.hidden = YES;
    }
    NSLog(@"model.realname:---------------%@",model.realname);
}


#pragma mark - Events
- (void)bgButtonClicked:(id)sender {
   
    if (self.selectRealNameAuthoBlock) {
        
        self.selectRealNameAuthoBlock();
        
    }
    
}


- (void)configLayout{

    //背景button
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];

    //右侧箭头
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@12);
    }];
    
    [self.defaultTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.realNameAuthoLabel.mas_right).mas_equalTo(5);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@15);
    }];
    
    //实名认证label
    [self.realNameAuthoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    //实名认证姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightArrowView.mas_left).offset(-19);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        
    }];

    

}

@end
