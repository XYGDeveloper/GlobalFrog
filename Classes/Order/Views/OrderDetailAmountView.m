//
//  OrderDetailAmountView.m
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailAmountView.h"
#import "OrderModel.h"

@interface OrderDetailAmountView ()

@property (nonatomic, strong) UILabel *goodsAmountLabel;//商品金额
@property (nonatomic, strong) UILabel *goodsAmountFixLabel;

@property (nonatomic, strong) UILabel *freightLabel;//运费
@property (nonatomic, strong) UILabel *freightFixLabel;

@property (nonatomic, strong) UILabel *favLabel;//优惠
@property (nonatomic, strong) UILabel *favFixLabel;

@property (nonatomic, strong) UILabel *amountLabel;//实付款
@property (nonatomic, strong) UILabel *amountFixLabel;

@end

@implementation OrderDetailAmountView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.goodsAmountFixLabel];
        [self addSubview:self.goodsAmountLabel];
        
        [self addSubview:self.freightFixLabel];
        [self addSubview:self.freightLabel];
        
        [self addSubview:self.favFixLabel];
        [self addSubview:self.favLabel];
        
        [self addSubview:self.amountFixLabel];
        [self addSubview:self.amountLabel];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithOrder:(OrderModel *)order {
    self.goodsAmountLabel.text = [Utils priceDisplayStringFromPrice:order.goods_amount];
    self.freightLabel.text = [NSString stringWithFormat:@"+%@", [Utils priceDisplayStringFromPrice:order.shipping_fee]];
    
    //TODO:优惠金额
    self.favLabel.text = [NSString stringWithFormat:@"-%@", [Utils priceDisplayStringFromPrice:order.discount]];
    
    self.amountLabel.text = [Utils priceDisplayStringFromPrice:order.order_amount];
}

#pragma mark - Layout
- (void)configLayout {
    CGFloat hMargin = 10;
    
    [self.goodsAmountFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14);
        make.left.equalTo(@(hMargin));
    }];
    
    [self.goodsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.centerY.equalTo(self.goodsAmountFixLabel);
    }];
    
    [self.freightFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsAmountFixLabel.mas_bottom).offset(6);
        make.left.equalTo(@(hMargin));
    }];
    
    [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.centerY.equalTo(self.freightFixLabel);
    }];
    
    [self.favFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freightFixLabel.mas_bottom).offset(6);
        make.left.equalTo(@(hMargin));
    }];
    
    [self.favLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.centerY.equalTo(self.favFixLabel);
    }];
    
    [self.amountFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favFixLabel.mas_bottom).offset(15);
        make.left.equalTo(@(hMargin));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.centerY.equalTo(self.amountFixLabel);
    }];
}

#pragma mark - Properties
- (UILabel *)goodsAmountLabel {
    if (!_goodsAmountLabel) {
        _goodsAmountLabel = GeneralLabelA(Font(13), TextColor1, NSTextAlignmentRight);
    }
    return _goodsAmountLabel;
}

- (UILabel *)goodsAmountFixLabel {
    if (!_goodsAmountFixLabel) {
        _goodsAmountFixLabel = GeneralLabel(Font(13), TextColor1);
        _goodsAmountFixLabel.text = @"商品金额：";
    }
    return _goodsAmountFixLabel;
}

- (UILabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel = GeneralLabelA(Font(13), TextColor1, NSTextAlignmentRight);
    }
    return _freightLabel;
}

- (UILabel *)freightFixLabel {
    if (!_freightFixLabel) {
        _freightFixLabel = GeneralLabel(Font(13), TextColor1);
        _freightFixLabel.text = @"运费：";
    }
    return _freightFixLabel;
}

- (UILabel *)favLabel {
    if (!_favLabel) {
        _favLabel = GeneralLabelA(Font(13), TextColor1, NSTextAlignmentRight);
    }
    return _favLabel;
}

- (UILabel *)favFixLabel {
    if (!_favFixLabel) {
        _favFixLabel = GeneralLabel(Font(13), TextColor1);
        _favFixLabel.text = @"优惠：";
    }
    return _favFixLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = GeneralLabel(BFont(15), AppStyleColor);
    }
    return _amountLabel;
}

- (UILabel *)amountFixLabel {
    if (!_amountFixLabel) {
        _amountFixLabel = GeneralLabelA(BFont(15), TextColor1, NSTextAlignmentRight);
        _amountFixLabel.text = @"实付：";
    }
    return _amountFixLabel;
}

@end
