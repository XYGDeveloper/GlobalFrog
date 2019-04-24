//
//  OrderCouponView.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderCouponView.h"
#import "OrderConfirmViewConfig.h"

@interface OrderCouponView ()

@property (nonatomic, strong) UILabel *fixLabel;

@property (nonatomic, strong) UILabel *couponExplainLabel;

@property (nonatomic, strong) UILabel *couponAmountLabel;

@property (nonatomic, strong) UIImageView *rightArrowView;

@property (nonatomic, strong) UIButton *bgButton;

@end

@implementation OrderCouponView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        [self.bgButton addTarget:self action:@selector(bgButtonClickd:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.bgButton];
        [self addSubview:self.fixLabel];
        [self addSubview:self.couponExplainLabel];
        [self addSubview:self.couponAmountLabel];
        [self addSubview:self.rightArrowView];
        
        [self configLayout];
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithCouponTips:(NSString *)tips {
    self.couponExplainLabel.text = @"";
    self.couponAmountLabel.text = tips;
}

#pragma mark - Events
- (void)bgButtonClickd:(id)sender {
    if (self.selectCouponBlock) {
        self.selectCouponBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.fixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.centerY.equalTo(self);
    }];
    
    [self.couponExplainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fixLabel.mas_right).offset(30);
        make.centerY.equalTo(self);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-1*ORDER_CONFIRM_RRIGHT_MARGIN);
        make.centerY.equalTo(self);
    }];
    
    [self.couponAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightArrowView.mas_left).offset(-19);
        make.centerY.equalTo(self);
    }];
}


#pragma mark - Properties
- (UILabel *)fixLabel {
    if (!_fixLabel) {
        _fixLabel = [[UILabel alloc] init];
        _fixLabel.backgroundColor = [UIColor clearColor];
        _fixLabel.font = Font(13);
        _fixLabel.textColor = TextColor2;
        _fixLabel.text = @"优惠券";
    }
    
    return _fixLabel;
}

- (UILabel *)couponExplainLabel {
    if (!_couponExplainLabel) {
        _couponExplainLabel = [[UILabel alloc] init];
        _couponExplainLabel.backgroundColor = [UIColor clearColor];
        _couponExplainLabel.font = Font(13);
        _couponExplainLabel.textColor = TextColor3;
    }
    
    return _couponExplainLabel;
}

- (UILabel *)couponAmountLabel {
    if (!_couponAmountLabel) {
        _couponAmountLabel = [[UILabel alloc] init];
        _couponAmountLabel.backgroundColor = [UIColor clearColor];
        _couponAmountLabel.font = Font(13);
        _couponAmountLabel.textColor = TextColor2;
    }
    
    return _couponAmountLabel;
}

- (UIImageView *)rightArrowView {
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_rightArrow"]];
    }
    return _rightArrowView;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.backgroundColor = [UIColor clearColor];
    }
    return _bgButton;
}

@end
