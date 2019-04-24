//
//  OrderDetailAddressCell.m
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "OrderDetailAddressCell.h"
#import "AddressModel.h"

@interface OrderDetailAddressCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation OrderDetailAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.phoneLabel];
        
        [self configLayout];
    }
    return self;
}


#pragma mark - Public Methods
- (void)refreshWithAddress:(AddressModel *)address {
    self.nameLabel.text = address.consignee;
    self.addressLabel.text = address.fullAddress;
    self.phoneLabel.text = address.mobile;
}


#pragma mark - Layout
- (void)configLayout {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@13);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(9);
        make.bottom.equalTo(self.mas_centerY).offset(-4);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(@-10);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.top.equalTo(self.nameLabel);
    }];
}

#pragma mark - Properties
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderDetail_address"]];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = GeneralLabel(Font(14), TextColor1);
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = GeneralLabel(Font(14), TextColor1);
    }
    return _addressLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = GeneralLabelA(Font(14), TextColor1, NSTextAlignmentRight);
    }
    return _phoneLabel;
}

@end
