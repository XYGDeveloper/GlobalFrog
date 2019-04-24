//
//  GoodsListCell.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GoodsListCell.h"
#import "GoodsModel.h"

@interface GoodsListCell ()

@property (nonatomic, strong) UIImageView *goodsImgView;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *favButton;

@end

@implementation GoodsListCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5.0;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = DividerDarkGrayColor.CGColor;
        self.contentView.layer.borderWidth = 0.5;
        
        [self.contentView addSubview:self.goodsImgView];
        [self.contentView addSubview:self.goodsNameLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.favButton];
        
        [self configLayout];
        
    }
    return self;
}

- (void)refreshWithGoods:(GoodsModel *)goods {
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    self.goodsNameLabel.text = goods.goods_name;
    self.priceLabel.text = [Utils priceDisplayStringFromPrice:goods.shop_price];
    
    self.favButton.selected = goods.isfav;
    [self.favButton setTitle:goods.favorite_number forState:UIControlStateNormal];
}


#pragma mark - Events
- (void)favButtonClicked:(id)sender {
    if (self.favBlock) {
        self.favBlock();
    }
}


#pragma mark - Layout 
- (void)configLayout {
    CGFloat hMargin = 9.0;

    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@([[self class] goodsImageHeight]));
        
#warning 修改内容
       // make.height.width.equalTo(@([[self class] goodsImageHeight]));
        //修改后
        make.width.mas_equalTo(self.contentView.mas_width);
        
    }];
    
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(10.0);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.0);
        make.bottom.equalTo(self.contentView).offset(-8.0);;
    }];
    
    [self.favButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.centerY.equalTo(self.priceLabel);
    }];
}

#pragma mark - size
+ (CGFloat)goodsImageHeight {
    return 135.0;
}

+ (CGSize)cellItemSize {
    CGFloat hMargin = 10.0;
    CGFloat hPadding = 10.0;
    CGFloat itemWidth = (kScreenWidth - 2*hMargin - hPadding) / 2.0;
    CGFloat itemHeight = [self goodsImageHeight] + 60.0;
    
    return CGSizeMake(itemWidth, itemHeight);
}


#pragma mark - Properties
- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.clipsToBounds = YES;
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodsImgView;
}

- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = GeneralLabel(Font(14), TextColor1);
    }
    return _goodsNameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = GeneralLabel(Font(14), PriceColor);
    }
    return _priceLabel;
}

- (UIButton *)favButton {
    if (!_favButton) {
        _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _favButton.backgroundColor = [UIColor clearColor];
        
        _favButton.titleLabel.font = Font(12);
        [_favButton setTitleColor:TextColor2 forState:UIControlStateNormal];
        
        [_favButton setImage:[UIImage imageNamed:@"goodsList_fav_normal"] forState:UIControlStateNormal];
        [_favButton setImage:[UIImage imageNamed:@"goodsList_fav_selected"] forState:UIControlStateSelected];
        [_favButton addTarget:self action:@selector(favButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_favButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_favButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    }
    return _favButton;
    
}


@end
