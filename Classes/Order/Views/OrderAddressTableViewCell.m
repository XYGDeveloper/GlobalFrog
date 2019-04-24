//
//  OrderAddressTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "OrderAddressTableViewCell.h"

@implementation OrderAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAddressInfo:(AddressModel *)addressInfo{
    _addressInfo  = addressInfo;
    _nameLabel.text = addressInfo.name;
    _phoneLabel.text = addressInfo.mobile;
    _addressLabel.text = addressInfo.fullAddress;
    
    if (addressInfo.is_default) {
        _defImgView.image = [UIImage imageNamed:@"df"];
    }else{
        _defImgView.image = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
