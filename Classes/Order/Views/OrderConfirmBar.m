//
//  OrderConfirmBar.m
//  Qqw
//
//  Created by zagger on 16/8/19.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderConfirmBar.h"
#import "OrderConfirmViewConfig.h"

@interface OrderConfirmBar ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation OrderConfirmBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        
        [self.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.topLineView];
        [self addSubview:self.priceLabel];
        [self addSubview:self.confirmButton];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithPrice:(NSString *)price {
    NSString *priceStr = [Utils priceDisplayStringFromPriceValue:price.floatValue];
    NSString *Str = [NSString stringWithFormat:@"合计：%@", priceStr];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:Str];
    [attStr addAttribute:NSFontAttributeName value:Font(13) range:[Str rangeOfString:@"合计："]];
    [attStr addAttribute:NSForegroundColorAttributeName value:PriceColor range:[Str rangeOfString:priceStr]];
    self.priceLabel.attributedText = attStr;
}

#pragma mark - Events
- (void)confirmButtonClicked:(id)sender {
    if (self.createBlock) {
        self.createBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
        make.centerY.equalTo(self);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.equalTo(@100);
    }];
}

#pragma mark - Properties
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = DividerGrayColor;
    }
    return _topLineView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = BFont(13);
        _priceLabel.textColor = AppStyleColor;
    }
    return _priceLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIHelper generalButtonWithTitle:@"立即下单"];
    }
    return _confirmButton;
}

@end
