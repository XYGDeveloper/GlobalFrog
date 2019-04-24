//
//  SearchGoodsCell.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SearchGoodsCell.h"
#import "GoodsModel.h"

@interface SearchGoodsCell ()

@property (nonatomic, strong) UIImageView *goodsImgView;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation SearchGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.goodsImgView];
        [self.contentView addSubview:self.goodsNameLabel];
        [self.contentView addSubview:self.priceLabel];
        
        self.separatorInset = UIEdgeInsetsZero;
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            self.preservesSuperviewLayoutMargins = NO;
        }
        
        [self configLaout];
    }
    return self;
}

- (void)refreshWithSearchGoodsModel:(GoodsModel *)goodsModel {
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    self.goodsNameLabel.text = goodsModel.goods_name;
    self.priceLabel.text = [Utils priceDisplayStringFromPrice:goodsModel.shop_price];
}

#pragma mark - Layout
- (void)configLaout {
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.height.equalTo(@65);
        make.centerY.equalTo(self.contentView);
    }];
    self.goodsNameLabel.numberOfLines = 2;
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImgView.mas_right).offset(7.5);
        make.right.equalTo(self).offset(-7.5);
        make.top.equalTo(@16);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImgView.mas_right).offset(7.5);
        make.right.equalTo(self).offset(-7.5);
        make.bottom.equalTo(@-15);
    }];
}


#pragma mark - Properties
- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.clipsToBounds = YES;
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        
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

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = GeneralLabel(Font(13), PriceColor);
    }
    return _priceLabel;
}

@end
