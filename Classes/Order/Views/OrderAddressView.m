//
//  OrderAddressView.m
//  Qqw
//
//  Created by zagger on 16/8/18.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderAddressView.h"
#import "AddressModel.h"
#import "OrderConfirmViewConfig.h"

@interface OrderAddressView ()

@property (nonatomic, strong) UIImageView *userIcon;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *defaultTagView;

@property (nonatomic, strong) UIImageView *rightArrowView;

@property (nonatomic, strong) UIButton *bgButton;

@end

@implementation OrderAddressView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        
        [self addSubview:self.bgButton];
        [self.bgButton addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.userIcon];
        [self addSubview:self.placeholderLabel];
        
        [self addSubview:self.usernameLabel];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.defaultTagView];
        
        [self addSubview:self.rightArrowView];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithAddress:(AddressModel *)address {
    if (address && [address isKindOfClass:[AddressModel class]] && address.address_id.length > 0) {
        self.userIcon.hidden = YES;
        self.placeholderLabel.hidden = YES;
        
        self.usernameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.addressLabel.hidden = NO;
        self.addressLabel.text = address.fullAddress;

        self.defaultTagView.hidden = !address.is_default;

        

        self.usernameLabel.text = address.name;
        self.phoneLabel.text = address.mobile;
        self.addressLabel.text = address.fullAddress;
        

    } else {
        self.userIcon.hidden = NO;
        self.placeholderLabel.hidden = NO;
        
        self.usernameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.addressLabel.hidden = YES;
        self.defaultTagView.hidden = YES;
    }
}

#pragma mark - Events
- (void)bgButtonClicked:(id)sender {
    if (self.selectAddressBlock) {
        self.selectAddressBlock();
    }
}


#pragma mark - Layout
- (void)configLayout {
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.centerY.equalTo(self);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(50);
        make.centerY.equalTo(self);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-1*ORDER_CONFIRM_RRIGHT_MARGIN);
        make.centerY.equalTo(self);
        make.width.equalTo(@6);
        make.height.equalTo(@12);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.bottom.equalTo(self.mas_centerY).offset(-4);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(25);
        make.centerY.equalTo(self.usernameLabel);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel);
        make.right.equalTo(self.rightArrowView.mas_left).offset(-5);
        make.top.equalTo(self.mas_centerY).offset(4);
    }];
    
    [self.defaultTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.centerY.equalTo(self.addressLabel);
        make.height.equalTo(@15);
    }];
}

#pragma mark - Properties
- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_userIcon"]];
    }
    return _userIcon;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.font = Font(13);
        _placeholderLabel.textColor = TextColor3;
        _placeholderLabel.text = @"请选择你的收货地址";
    }
    return _placeholderLabel;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.font = Font(13);
        _usernameLabel.textColor = TextColor2;
        [_usernameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _usernameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.backgroundColor = [UIColor clearColor];
        _phoneLabel.font = Font(13);
        _phoneLabel.textColor = TextColor2;
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.font = Font(13);
        _addressLabel.textColor = TextColor3;
    }
    return _addressLabel;
}

- (UIButton *)defaultTagView {
    if (!_defaultTagView) {
        _defaultTagView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultTagView setImage:[UIImage imageNamed:@"vip_name_selected"] forState:UIControlStateNormal];
        [_defaultTagView setTitle:@"默认" forState:UIControlStateNormal];
        [_defaultTagView setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _defaultTagView.titleLabel.font = Font(11);
        _defaultTagView.adjustsImageWhenHighlighted = NO;
        
        _defaultTagView.layer.cornerRadius = 2.0;
        _defaultTagView.layer.masksToBounds = YES;
        _defaultTagView.layer.borderColor = AppStyleColor.CGColor;
        _defaultTagView.layer.borderWidth = 1.0;
    }
    return _defaultTagView;
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
