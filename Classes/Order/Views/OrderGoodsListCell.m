//
//  OrderGoodsListCell.m
//  Qqw
//
//  Created by zagger on 16/9/5.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "OrderGoodsListCell.h"
#import "CartGoodsModel.h"

@interface OrderGoodsListCell ()

@property (nonatomic, strong) UIImageView *goodsImgView;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *goodsAttrLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation OrderGoodsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.goodsImgView];
        [self.contentView addSubview:self.goodsNameLabel];
        [self.contentView addSubview:self.goodsAttrLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.countLabel];
        
        [self configLayout];
    }
    return self;
}

- (void)refreshWithGoods:(CartGoodsModel *)goodsModel {
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    
    self.goodsNameLabel.text = goodsModel.goods_name;
    self.goodsAttrLabel.text = goodsModel.attr_value_format;
    self.priceLabel.text = [Utils priceDisplayStringFromPrice:goodsModel.sale_price];
    self.countLabel.text = [NSString stringWithFormat:@"X%@",goodsModel.goods_number];
}

#pragma mark - Layout
- (void)configLayout {
    CGFloat imgWidth = 65.0;
    CGFloat hMargin = 14.0;
    
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(imgWidth));
        make.left.equalTo(@(hMargin));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImgView.mas_right).offset(7);
        make.top.equalTo(self.goodsImgView);
    }];
    
    [self.goodsAttrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsNameLabel);
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsNameLabel);
        make.bottom.equalTo(self.goodsImgView);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImgView);
        make.right.equalTo(@(-1*hMargin));
    }];
}

#pragma mark - Properties
- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.clipsToBounds = YES;
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgView.layer.cornerRadius = 5.0;
        _goodsImgView.layer.masksToBounds = YES;
        _goodsImgView.layer.borderColor = DividerGrayColor.CGColor;
        _goodsImgView.layer.borderWidth = 0.5;
        
        _goodsImgView.layer.cornerRadius = 2.0;
        _goodsImgView.layer.masksToBounds = YES;
        _goodsImgView.layer.borderColor = DividerGrayColor.CGColor;
        _goodsImgView.layer.borderWidth = 0.5;
    }
    return _goodsImgView;
}

- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = GeneralLabel(Font(13), TextColor1);
    }
    return _goodsNameLabel;
}

- (UILabel *)goodsAttrLabel {
    if (!_goodsAttrLabel) {
        _goodsAttrLabel = GeneralLabel(Font(11), DividerDarkGrayColor);
    }
    return _goodsAttrLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = GeneralLabel(Font(13), PriceColor);
    }
    return _priceLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = GeneralLabelA(Font(11), DividerDarkGrayColor, NSTextAlignmentRight);
    }
    return _countLabel;
}

@end
