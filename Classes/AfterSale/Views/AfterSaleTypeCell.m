//
//  AfterSaleTypeCell.m
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AfterSaleTypeCell.h"

@interface AfterSaleTypeCell ()

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *introLabel;

@end

@implementation AfterSaleTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configLayout];
    }
    return self;
}

- (void)refreshWithType:(AfterSaleType *)asType selected:(BOOL)selected {
    self.titleLabel.text = asType.name;
    self.introLabel.text = asType.desc;
    self.selectedButton.selected = selected;
}


#pragma mark - Layout
- (void)configLayout {
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.introLabel];
    
    CGFloat hMargin = 12.0;
    CGFloat hPadding = 14.0;
    CGFloat selectDisplayWidth = 11.0;
    CGFloat selectExpandWidth = 20.0;
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(hMargin - 0.5*selectExpandWidth));
        make.width.height.equalTo(@(selectDisplayWidth + selectExpandWidth));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedButton.mas_right).offset(hPadding - 0.5*selectExpandWidth);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-3);
    }];
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.contentView.mas_centerY).offset(3);
    }];
}


#pragma mark - Properties
- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[UIImage imageNamed:@"afterSale_type_normal"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"afterSale_type_selected"] forState:UIControlStateSelected];
        _selectedButton.userInteractionEnabled = YES;
        
    }
    return _selectedButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = GeneralLabel(Font(14), TextColor1);
    }
    return _titleLabel;
}

- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = GeneralLabel(Font(13), TextColor3);
    }
    return _introLabel;
}

@end
