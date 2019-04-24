//
//  SearchAddressTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/17.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "SearchAddressTableViewCell.h"

@implementation SearchAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMapPoi:(AMapPOI *)mapPoi{
    _mapPoi = mapPoi;
    _cruLabel .text = nil;
    _nameLabel.text = mapPoi.name;
    _addressLabel.text = mapPoi.address;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
