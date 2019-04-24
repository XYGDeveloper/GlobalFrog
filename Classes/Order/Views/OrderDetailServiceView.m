//
//  OrderDetailServiceView.m
//  Qqw
//
//  Created by zagger on 16/8/22.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailServiceView.h"

@interface OrderDetailServiceView ()

@property (nonatomic, strong) UIButton *phoneButton;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation OrderDetailServiceView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.phoneButton addTarget:self action:@selector(phoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.phoneButton];
        [self addSubview:self.timeLabel];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Events
- (void)phoneButtonClicked:(id)sender {
    if (self.callPhoneBlock) {
        self.callPhoneBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self);
        make.width.equalTo(@75);
        make.height.equalTo(@24);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Properties
- (UIButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_phoneButton setImage:[UIImage imageNamed:@"orderDetail_phone"] forState:UIControlStateNormal];
        [_phoneButton setTitle:@"电话客服" forState:UIControlStateNormal];
        
        _phoneButton.titleLabel.font = Font(12);
        [_phoneButton setTitleColor:TextColor1 forState:UIControlStateNormal];
        
        _phoneButton.layer.cornerRadius = 2.0;
        _phoneButton.layer.masksToBounds = YES;
        _phoneButton.layer.borderWidth = 1.0;
        _phoneButton.layer.borderColor = DividerGrayColor.CGColor;
    }
    return _phoneButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = GeneralLabel(Font(12), TextColor1);
        _timeLabel.text = @"服务时间：9:00-18:00";
    }
    return _timeLabel;
}

@end
