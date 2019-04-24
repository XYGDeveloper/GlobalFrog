//
//  OrderSelectTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "OrderSelectTableViewCell.h"

@implementation OrderSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(RealListModel *)model{
    _model = model;
    _nameLabel.text = @"实名认证";
    if (model) {
        _msgLabel.text = model.realname;
        _statusLabel.text = @"";
    }else{
        _msgLabel.text = @"默认";
        _statusLabel.text = @"未使用";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
