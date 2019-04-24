//
//  ShoppingCartOperationBar.m
//  Qqw
//
//  Created by zagger on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShoppingCartOperationBar.h"
#import "UIImage+Common.h"

@interface ShoppingCartOperationBar ()

/**
 *  当前选中商品的总价
 */
@property (nonatomic, assign, readwrite) CGFloat totalPrice;

/**
 *  当前选中的商品数
 */
@property (nonatomic, assign, readwrite) NSInteger selectCount;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UILabel *selectCountLabel;

@property (nonatomic, strong) UILabel *totalPriceLabel;

@property (nonatomic, strong) UIButton *settleButton;

//@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIButton *favButton;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIView *dividerLineView;

@end

@implementation ShoppingCartOperationBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.edit = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.settleButton addTarget:self action:@selector(settleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.favButton addTarget:self action:@selector(favButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.selectButton];
        [self addSubview:self.selectCountLabel];
        [self addSubview:self.totalPriceLabel];
        [self addSubview:self.settleButton];
        [self addSubview:self.favButton];
        [self addSubview:self.deleteButton];
        [self addSubview:self.dividerLineView];
        [self addSubview:self.topLineView];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithSelectCount:(NSInteger)selectCount totalPrice:(CGFloat)totalPrcie {
    self.selectCount = selectCount;
    if (self.fullSelected) {//已全选
        self.selectButton.selected = YES;
        self.selectCountLabel.text = [NSString stringWithFormat:@"全选(%ld)",(long)selectCount];
    }
    else {//未全选
        self.selectButton.selected = NO;
        self.selectCountLabel.text = [NSString stringWithFormat:@"全选(%ld)",(long)selectCount];
    }
    
    self.totalPrice = totalPrcie;
    NSString *fixStr = @"合计：";
    NSString *priceStr = [Utils priceDisplayStringFromPriceValue:totalPrcie];
    NSString *str = [NSString stringWithFormat:@"%@%@",fixStr,priceStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:Font(14) range:[str rangeOfString:fixStr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:PriceColor range:[str rangeOfString:priceStr]];
    
    self.totalPriceLabel.attributedText = attStr;
    
}

#pragma mark - Events
- (void)selectButtonClicked:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
    
    self.fullSelected = self.selectButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(operationBarDidSelect:)]) {
        [self.delegate operationBarDidSelect:self];
    }
}

- (void)settleButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(operationBarDidSettle:)]) {
        [self.delegate operationBarDidSettle:self];
    }
}

- (void)favButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(operationBarDidFaverate:)]) {
        [self.delegate operationBarDidFaverate:self];
    }
}

- (void)deleteButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(operationBarDidDelete:)]) {
        [self.delegate operationBarDidDelete:self];
    }
}

#pragma mark - Layout
- (void)configLayout {
    CGFloat selectDisplayWidth = 15.0;
    CGFloat selectExpandWidth = 20.0;
    CGFloat leftMargin = 14.0;
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftMargin - 0.5*selectExpandWidth));
        make.width.height.equalTo(@(selectDisplayWidth + selectExpandWidth));
        make.centerY.equalTo(self);
    }];
    
    [self.selectCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(leftMargin - 0.5*selectExpandWidth);
        make.centerY.equalTo(self);
    }];
    
    [self.settleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.width.equalTo(@102);
    }];

    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settleButton.mas_left).offset(-10);
        make.left.equalTo(self.selectCountLabel.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.width.equalTo(@67);
    }];
    
    [self.favButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@88);
    }];
    
    [self.dividerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.bottom.equalTo(@-5);
        make.width.equalTo(@0.5);
        make.right.equalTo(self.favButton.mas_left);
    }];
    
//    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.favButton.mas_left);
//        make.top.bottom.equalTo(@0);
//        make.width.equalTo(@67);
//    }];
}

#pragma mark - Setters
- (void)setEdit:(BOOL)edit {
    _edit = edit;
    
    self.favButton.hidden = !edit;
    self.deleteButton.hidden = !edit;
    self.dividerLineView.hidden = !edit;
    
    self.totalPriceLabel.hidden = edit;
    self.settleButton.hidden = edit;
}


#pragma mark - Properties
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = DividerGrayColor;
    }
    return _topLineView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"cart_unselect"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    }
    
    return _selectButton;
}

- (UILabel *)selectCountLabel {
    if (!_selectCountLabel) {
        _selectCountLabel = GeneralLabel(Font(14), TextColor3);
        _selectCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _selectCountLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = GeneralLabelA(BFont(14), AppStyleColor, NSTextAlignmentRight);
        _totalPriceLabel.adjustsFontSizeToFitWidth = YES;
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalPriceLabel;
}

- (UIButton *)settleButton {
    if (!_settleButton) {
        _settleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settleButton.titleLabel.font = Font(14);
        [_settleButton setTitle:@"结算" forState:UIControlStateNormal];
        [_settleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settleButton setBackgroundImage:[UIImage imageWithColor:AppStyleColor] forState:UIControlStateNormal];
    }
    return _settleButton;
}

//- (UIButton *)shareButton {
//    if (!_shareButton) {
//        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _shareButton.titleLabel.font = Font(13);
//        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
//        [_shareButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
//        [_shareButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//    }
//    return _shareButton;
//}

- (UIButton *)favButton {
    if (!_favButton) {
        _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favButton.titleLabel.font = Font(14);
        [_favButton setTitle:@"移到收藏夹" forState:UIControlStateNormal];
        [_favButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [_favButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
    return _favButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.titleLabel.font = Font(14);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:[UIImage imageWithColor:AppStyleColor] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (UIView *)dividerLineView {
    if (!_dividerLineView) {
        _dividerLineView = [[UIView alloc] init];
        _dividerLineView.backgroundColor = DividerGrayColor;
    }
    return _dividerLineView;
}

@end
