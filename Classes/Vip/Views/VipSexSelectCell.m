//
//  VipSexSelectCell.m
//  Qqw
//
//  Created by zagger on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "VipSexSelectCell.h"

@interface VipSexSelectCell ()

@property (nonatomic, strong) UIButton *maleButton;

@property (nonatomic, strong) UIButton *femaleButton;

@end

@implementation VipSexSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.maleButton];
        [self.contentView addSubview:self.femaleButton];
        
        [self setEditAble:NO];
        [self.maleButton addTarget:self action:@selector(maleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.femaleButton addTarget:self action:@selector(femaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setIcon:[UIImage imageNamed:@"vip_sex_normal"] editedIcon:[UIImage imageNamed:@"vip_sex_selected"] placeholder:@"选择性别"];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maleButton.mas_right).offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - Public Methods
- (NSString *)sex {
    if (self.maleButton.selected) {
        return kSexMale;
    } else if (self.femaleButton.selected) {
        return kSexFemale;
    }
    return @"";
}

- (void)setSex:(NSString *)sex {
    self.maleButton.selected = [sex isEqualToString:kSexMale];
    self.femaleButton.selected = [sex isEqualToString:kSexFemale];
    
    if (self.maleButton.selected || self.femaleButton.selected) {
        self.iconView.image = self.editedImage;
    } else {
        self.iconView.image = self.normalImage;
    }
    
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

#pragma mark - Events
- (void)maleButtonClicked:(id)sender {
    self.sex = kSexMale;
}

- (void)femaleButtonClicked:(id)sender {
    self.sex = kSexFemale;
}


#pragma mark - Properties
- (UIButton *)maleButton {
    if (!_maleButton) {
        _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleButton.backgroundColor = [UIColor clearColor];
        
        [_maleButton setImage:[UIImage imageNamed:@"vip_sexUnselected"] forState:UIControlStateNormal];
        [_maleButton setImage:[UIImage imageNamed:@"vip_sexSelected"] forState:UIControlStateSelected];
        
        _maleButton.titleLabel.font = Font(13);
        [_maleButton setTitle:@"男" forState:UIControlStateNormal];
        [_maleButton setTitleColor:HexColor(0x909090) forState:UIControlStateNormal];
        [_maleButton setTitleColor:HexColor(0x323232) forState:UIControlStateSelected];
    }
    return _maleButton;
}

- (UIButton *)femaleButton {
    if (!_femaleButton) {
        _femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleButton.backgroundColor = [UIColor clearColor];
        
        [_femaleButton setImage:[UIImage imageNamed:@"vip_sexUnselected"] forState:UIControlStateNormal];
        [_femaleButton setImage:[UIImage imageNamed:@"vip_sexSelected"] forState:UIControlStateSelected];
        
        _femaleButton.titleLabel.font = Font(13);
        [_femaleButton setTitle:@"女" forState:UIControlStateNormal];
        [_femaleButton setTitleColor:HexColor(0x909090) forState:UIControlStateNormal];
        [_femaleButton setTitleColor:HexColor(0x323232) forState:UIControlStateSelected];
    }
    return _femaleButton;
}


@end
