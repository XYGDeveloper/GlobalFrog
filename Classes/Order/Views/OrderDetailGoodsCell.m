//
//  OrderDetailGoodsCell.m
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailGoodsCell.h"
#import "OrderModel.h"
#import <UIImageView+WebCache.h>

@interface OrderDetailGoodsCell ()

@property (nonatomic, strong, readwrite) UIImageView *goodsImgView;

@property (nonatomic, strong) UIView *labelInfoView;

@property (nonatomic, strong, readwrite) UILabel *goodsNameLabel;

@property (nonatomic, strong, readwrite) UILabel *goodsAttrLabel;

@property (nonatomic, strong, readwrite) UILabel *goodsPriceLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIButton *afterSaleButton;

@end

@implementation OrderDetailGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.goodsImgView];
        [self.contentView addSubview:self.labelInfoView];
        [self.labelInfoView addSubview:self.goodsNameLabel];
        [self.labelInfoView addSubview:self.goodsAttrLabel];
        [self.contentView addSubview:self.goodsPriceLabel];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.afterSaleButton];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithOrderGoods:(OrderGoodsModel *)goods {
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    self.goodsNameLabel.text = goods.goods_name;
    self.goodsAttrLabel.text = goods.goods_attr;
    self.goodsPriceLabel.text = [Utils priceDisplayStringFromPrice:goods.shop_price];
    self.countLabel.text = [NSString stringWithFormat:@"X%@",goods.goods_number];
    
    if (self.hideAfterSale) {
        self.afterSaleButton.hidden = YES;
    } else {
        self.afterSaleButton.hidden = NO;
        [self.afterSaleButton setTitle:@"" forState:UIControlStateNormal];
        if ([goods.is_after_sales isEqualToString:kAfterSaleStateNot]) {
            [self.afterSaleButton setTitle:@"申请售后" forState:UIControlStateNormal];
        }
        else if ([goods.is_after_sales isEqualToString:kAfterSaleStateAlready]) {
            [self.afterSaleButton setTitle:@"已申请售后" forState:UIControlStateNormal];
        }
        else {
            self.afterSaleButton.hidden = YES;
        }
    }
}

#pragma mark - Events
- (void)afterSaleButtonClicked:(id)sender {
    if (self.afterSaleBlock) {
        self.afterSaleBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    CGFloat hMargin = 10;
    
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.top.equalTo(@10);
        make.width.height.equalTo(@70);
    }];
    
    [self.labelInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsImgView);
        make.left.equalTo(self.goodsImgView.mas_right);
        make.right.lessThanOrEqualTo(self.afterSaleButton.mas_left).offset(-20);
    }];
    
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.top.right.equalTo(@0);
    }];
    
    [self.goodsAttrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsNameLabel);
        make.right.bottom.equalTo(@0);
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(5);
    }];
    
    [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.bottom.equalTo(self.countLabel.mas_top).offset(-3);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsPriceLabel);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.afterSaleButton.mas_top).offset(-10);
    }];
    
    [self.afterSaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.bottom.equalTo(self.goodsImgView);
        make.width.greaterThanOrEqualTo(@60);
    }];
}

#pragma mark - Properties
- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgView.clipsToBounds = YES;
        
        _goodsImgView.layer.cornerRadius = 2.0;
        _goodsImgView.layer.masksToBounds = YES;
        _goodsImgView.layer.borderColor = DividerGrayColor.CGColor;
        _goodsImgView.layer.borderWidth = 0.5;
    }
    return _goodsImgView;
}

- (UIView *)labelInfoView {
    if (!_labelInfoView) {
        _labelInfoView = [[UIView alloc] init];
        _labelInfoView.backgroundColor = [UIColor clearColor];
        [_labelInfoView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _labelInfoView;
}

- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = GeneralLabel(Font(14), TextColor1);
        _goodsNameLabel.numberOfLines = 2;
    }
    return _goodsNameLabel;
}

- (UILabel *)goodsAttrLabel {
    if (!_goodsAttrLabel) {
        _goodsAttrLabel = GeneralLabel(Font(13), TextColor3);
    }
    return _goodsAttrLabel;
}

- (UILabel *)goodsPriceLabel {
    if (!_goodsPriceLabel) {
        _goodsPriceLabel = GeneralLabelA(Font(14), TextColor1, NSTextAlignmentRight);
    }
    return _goodsPriceLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = GeneralLabelA(Font(12), TextColor3, NSTextAlignmentRight);
    }
    return _countLabel;
}

- (UIButton *)afterSaleButton {
    if (!_afterSaleButton) {
        _afterSaleButton = [UIHelper appstyleBorderButtonWithTitle:@""];
        _afterSaleButton.contentEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 8);
        [_afterSaleButton addTarget:self action:@selector(afterSaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _afterSaleButton;
}

@end
