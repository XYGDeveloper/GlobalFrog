//
//  ShoppingCartCell.m
//  Qqw
//
//  Created by zagger on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "CountEditView.h"
#import <UIButton+WebCache.h>

@interface ShoppingCartCell ()

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *goodsImgButton;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *goodsSubInfoLabel;//商品附加说明

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) CountEditView *countView;





@end

@implementation ShoppingCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) wSelf = self;
        self.countView.reduceBlock = ^{
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf reduceCount];
        };
        
        self.countView.addBlock = ^{
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf addCount];
        };
        
        [self.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.selectButton];
        [self.contentView addSubview:self.goodsImgButton];
        [self.contentView addSubview:self.goodsNameLabel];
        [self.contentView addSubview:self.goodsSubInfoLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.countView];

        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    CGFloat selectDisplayWidth = 15.0;
    CGFloat selectExpandWidth = 20;
    CGFloat hMargin = 14.0;
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin - 0.5*selectExpandWidth));
        make.width.height.equalTo(@(selectDisplayWidth + selectExpandWidth));
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
    }];
    
    [self.goodsImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(17.0 - 0.5*selectExpandWidth);
        make.width.height.equalTo(@67);
        make.centerY.equalTo(self.selectButton);
    }];
    
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImgButton.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-1*hMargin);
        make.top.equalTo(self.goodsImgButton).offset(2);
    }];
    
    [self.goodsSubInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.goodsNameLabel);
        make.right.equalTo(self.goodsNameLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsNameLabel);
        make.bottom.equalTo(self.goodsImgButton).offset(-2);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsNameLabel);
        make.bottom.equalTo(self.goodsImgButton);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
}

#pragma mark - Public Methods
- (void)refreshSelectStatus:(BOOL)selected {
    self.selectButton.selected = selected;
}

- (void)refreshWithGoods:(CartGoodsModel *)goods {
    if (!goods || ![goods isKindOfClass:[CartGoodsModel class]]) {
        return;
    }
    
    self.goods = goods;
    
    [self.goodsImgButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goods.goods_thumb] forState:UIControlStateNormal placeholderImage:[UIHelper smallPlaceholder]];
    self.goodsNameLabel.text = self.goods.goods_name;
    self.goodsSubInfoLabel.text = self.goods.attr_value_format;
    self.priceLabel.text = [Utils priceDisplayStringFromPrice:self.goods.sale_price];
    self.countView.count = [self.goods.goods_number integerValue];
    
}

-(void)setDataWithGoods:(CartGoodsModel *)model{
    _goods = model;
    
    [self.goodsImgButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.goods_thumb] forState:UIControlStateNormal placeholderImage:[UIHelper smallPlaceholder]];
    self.goodsNameLabel.text = model.goods_name;
    self.goodsSubInfoLabel.text = model.attr_value_format;
    self.priceLabel.text = [Utils priceDisplayStringFromPrice:model.sale_price];
    self.countView.count = [model.goods_number integerValue];
}

- (void)imageButtonClicked:(id)sender {
    if (self.imageClickBlock) {
        self.imageClickBlock();
    }
}

#pragma mark - events
- (void)selectButtonClicked:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
    if (self.selectBlock) {
        self.selectBlock(self.selectButton.isSelected);
    }
}

- (void)reduceCount {
    if (self.countEditBlock) {
        self.countEditBlock(self.countView.count);
    }
}

- (void)addCount {
    if (self.countEditBlock) {
        self.countEditBlock(self.countView.count);
    }
}


#pragma mark - Properties
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"cart_unselect"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    }
    
    return _selectButton;
}

- (UIButton *)goodsImgButton {
    if (!_goodsImgButton) {
        _goodsImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodsImgButton.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgButton.clipsToBounds = YES;
        
        _goodsImgButton.layer.borderColor = DividerGrayColor.CGColor;
        _goodsImgButton.layer.borderWidth = 0.5;
        _goodsImgButton.layer.cornerRadius = 2.0;
        _goodsImgButton.layer.masksToBounds = YES;
        
        [_goodsImgButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _goodsImgButton;
}

- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = GeneralLabel(Font(14), TextColor1);
    }
    return _goodsNameLabel;
}

- (UILabel *)goodsSubInfoLabel {
    if (!_goodsSubInfoLabel) {
        _goodsSubInfoLabel = GeneralLabel(Font(12), TextColor3);
    }
    return _goodsSubInfoLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = GeneralLabel(Font(14), PriceColor);
    }
    return _priceLabel;
}

- (CountEditView *)countView {
    if (!_countView) {
        _countView = [[CountEditView alloc] initWithFrame:CGRectZero];
    }
    return _countView;
}

@end
