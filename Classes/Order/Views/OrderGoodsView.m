//
//  OrderGoodsView.m
//  Qqw
//
//  Created by zagger on 16/8/18.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderGoodsView.h"
#import "OrderConfirmViewConfig.h"
#import <UIImageView+WebCache.h>
#import "CartGoodsModel.h"
#import "CrowdfundingModel.h"

@interface OrderGoodsView ()

@property (nonatomic, strong) UIScrollView *imageContainerView;

@property (nonatomic, strong) UILabel *totalCountLabel;

@property (nonatomic, strong) UIImageView *rightArrowView;

@property (nonatomic, strong) UIButton *bgButton;

@end

@implementation OrderGoodsView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ORDER_CONFIRM_BACKGROUND_COLOR;
        
        [self addSubview:self.bgButton];
        [self.bgButton addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.imageContainerView];
        [self addSubview:self.totalCountLabel];
        [self addSubview:self.rightArrowView];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithCartGoods:(NSArray *)cartGoods {
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%lu件",(unsigned long)cartGoods.count];
    [self.imageContainerView removeAllSubViews];
    
    UIImageView *tempView = nil;
    for (int i = 0; i < cartGoods.count && i < 4; i ++) {
        NSString *imageUrl = nil;
        id model = [cartGoods safeObjectAtIndex:i];
        BOOL  is_limit = NO;
        if ([model isKindOfClass:[CartGoodsModel class]]) {//普通商品
            CartGoodsModel *goods = (CartGoodsModel *)model;
            imageUrl = goods.goods_thumb;
            if (goods.is_limit) {
                is_limit = goods.is_limit;
            }
        }else if ([model isKindOfClass:[CrowdfundingModel class]]) {//众筹商品
            CrowdfundingModel *goods = (CrowdfundingModel *)model;
            imageUrl = goods.pic_one;
            if (goods.is_limit) {
                is_limit = goods.is_limit;
            }
        }

        UIImageView *imgView = [self goodsImageViewWithImage:imageUrl];
        imgView.clipsToBounds = YES;
        [self.imageContainerView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@66);
            make.top.equalTo(@9);
            make.bottom.equalTo(@-9);
            
            if (tempView && tempView.superview) {
                make.left.equalTo(tempView.mas_right).offset(1);
            } else {
                make.left.equalTo(@(ORDER_CONFIRM_LEFT_MARGIN));
            }
            
            if (i == cartGoods.count - 1 || i == 4 -1) {
                make.right.equalTo(@-1);
            }
        }];
        
        if (is_limit) {
            UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 66, 66)];
            v.backgroundColor = [UIColor blackColor];
            v.alpha = 0.7;
            [imgView addSubview:v];
        }
        
        tempView = imgView;
    }
}


#pragma mark - Events
- (void)bgButtonClicked:(id)sender {
    if (self.checkGoodsListBlock) {
        self.checkGoodsListBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-1*ORDER_CONFIRM_RRIGHT_MARGIN);
        make.centerY.equalTo(self);
    }];
    
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightArrowView.mas_left).offset(-18);
        make.width.equalTo(@40);
        make.centerY.equalTo(self);
    }];
    
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(@0);
        make.right.equalTo(self.totalCountLabel.mas_left).offset(-18);
    }];
}

#pragma mark - Helper
- (UIImageView *)goodsImageViewWithImage:(NSString *)imageUrl {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.cornerRadius = 2.0;
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderColor = DividerGrayColor.CGColor;
    imgView.layer.borderWidth = 0.5;
    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIHelper smallPlaceholder]];
    
    return imgView;
}

#pragma mark - Properties
- (UIScrollView *)imageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = [[UIScrollView alloc] init];
        _imageContainerView.showsVerticalScrollIndicator = NO;
        _imageContainerView.showsHorizontalScrollIndicator = NO;
        _imageContainerView.backgroundColor = [UIColor clearColor];
        _imageContainerView.alwaysBounceHorizontal = NO;
        _imageContainerView.bounces = NO;
    }
    return _imageContainerView;
}

- (UILabel *)totalCountLabel {
    if (!_totalCountLabel) {
        _totalCountLabel = [[UILabel alloc] init];
        _totalCountLabel.backgroundColor = [UIColor clearColor];
        _totalCountLabel.font =Font(13);
        _totalCountLabel.textColor = TextColor2;
        _totalCountLabel.textAlignment = NSTextAlignmentRight;
        _totalCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _totalCountLabel;
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
