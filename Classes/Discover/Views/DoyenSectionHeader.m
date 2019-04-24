//
//  DoyenSectionHeader.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenSectionHeader.h"

@interface DoyenSectionHeader ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *checkAllLabel;

@property (nonatomic, strong) UIImageView *moreImgView;

@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation DoyenSectionHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        [self addSubview:self.checkAllLabel];
        [self addSubview:self.moreImgView];
//        [self addSubview:self.actionButton];
        
        [self.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self configLayout];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithName:(NSString *)name {
    self.nameLabel.text = name;
}

#pragma mark - Events
- (void)actionButtonClicked:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark - Layout
- (void)configLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self).offset(2);
    }];
    
//    [self.moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.nameLabel);
//        make.right.equalTo(@-10);
//    }];
    
//    [self.checkAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.nameLabel);
//        make.right.equalTo(self.moreImgView.mas_left).offset(-4);
//    }];
    
//    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(@0);
//        make.width.equalTo(@80);
//    }];
}

#pragma mark - Properties
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = GeneralLabel(Font(15), TextColor1);
    }
    return _nameLabel;
}

- (UILabel *)checkAllLabel {
    if (!_checkAllLabel) {
        _checkAllLabel = GeneralLabel(Font(14), TextColor2);
        _checkAllLabel.text = @"";
    }
    return _checkAllLabel;
}

//- (UIImageView *)moreImgView {
//    if (!_moreImgView) {
//        _moreImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_rightArrow"]];
//    }
//    return _moreImgView;
//}

//- (UIButton *)actionButton {
//    if (!_actionButton) {
//        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _actionButton.backgroundColor = [UIColor clearColor];
//    }
//    return _actionButton;
//}

@end
