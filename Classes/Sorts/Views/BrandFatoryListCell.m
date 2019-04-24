//
//  BrandFatoryListCell.m
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BrandFatoryListCell.h"
#import "BrandFactory.h"

@interface BrandFatoryListCell ()

@property (nonatomic, strong) UIImageView *brandImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *praiseButton;

@end

@implementation BrandFatoryListCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = DividerDarkGrayColor.CGColor;
        
        [self configLayout];
    }
    return self;
}

- (void)refreshWithBrandFactoryModel:(BrandFactory *)model {
    [self.brandImgView sd_setImageWithURL:[NSURL URLWithString:model.brand_picture] placeholderImage:[UIHelper smallPlaceholder]];
    self.nameLabel.text = model.brand_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元起", model.min_price];
    
    //注：隐藏点赞
    self.praiseButton.hidden = YES;
}


#pragma mark - Event
- (void)praiseButtonClicked:(id)sender {
    
}

- (void)configLayout {
    [self.contentView addSubview:self.brandImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.praiseButton];
    
    CGFloat hMargin = 8.0;
    
    [self.brandImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@([[self class] brandImageHeight]));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.right.equalTo(@(-1*hMargin));
        make.top.equalTo(self.brandImgView.mas_bottom).offset(12);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
    }];
    
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-1*hMargin));
        make.centerY.equalTo(self.priceLabel);
    }];
}


#pragma mark - size
+ (CGFloat)brandImageHeight {
    CGFloat hMargin = 10.0;
    CGFloat hPadding = 11.0;
    CGFloat imageWidth = (kScreenWidth - 2*hMargin - hPadding) / 2.0;
    
    return imageWidth * 0.75;
}

+ (CGSize)cellItemSize {
    CGFloat hMargin = 10.0;
    CGFloat hPadding = 11.0;
    CGFloat itemWidth = (kScreenWidth - 2*hMargin - hPadding) / 2.0;
    CGFloat itemHeight = [self brandImageHeight] + 62.0;
    
    return CGSizeMake(itemWidth, itemHeight);
}


#pragma mark - Properties
- (UIImageView *)brandImgView {
    if (!_brandImgView) {
        _brandImgView = [[UIImageView alloc] init];
        _brandImgView.clipsToBounds = YES;
        _brandImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _brandImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = GeneralLabel(Font(15), TextColor1);
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = GeneralLabel(Font(14), PriceColor);
    }
    return _priceLabel;
}

- (UIButton *)praiseButton {
    if (!_praiseButton) {
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _praiseButton.backgroundColor = [UIColor clearColor];
        _praiseButton.titleLabel.font = Font(11);
        [_praiseButton setTitleColor:TextColor3 forState:UIControlStateNormal];
        
        [_praiseButton setImage:[UIImage imageNamed:@"brand_praise_normal"] forState:UIControlStateNormal];
        [_praiseButton setImage:[UIImage imageNamed:@"brand_praise_selected"] forState:UIControlStateSelected];
        
        _praiseButton.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        _praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
        
        [_praiseButton addTarget:self action:@selector(praiseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseButton;
}


@end
