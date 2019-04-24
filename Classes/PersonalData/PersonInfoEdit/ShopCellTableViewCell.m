//
//  ShopCellTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShopCellTableViewCell.h"

@implementation ShopCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shopImhg = [[UIImageView alloc]init];
        [self.contentView addSubview:_shopImhg];
        self.shopName = [[UILabel alloc]init];
        self.shopName.font = [UIFont systemFontOfSize:14.0f];
        self.shopName.textColor = [UIColor colorWithWhite:0.572 alpha:1.000];
        self.shopName.numberOfLines = 3;
        [self.contentView addSubview:_shopName];
        
        self.shopPrice = [[UILabel alloc]init];
        self.shopPrice.textAlignment = NSTextAlignmentRight;
        self.shopPrice.font = [UIFont systemFontOfSize:13.0f];
        
        self.shopPrice.textColor = PriceColor;
        [self.contentView addSubview:_shopPrice];
        
        self.line = [[UIImageView alloc]init];
        self.line.backgroundColor = HexColor(0xd6d7dc);
        [self.contentView addSubview:_line];

    }
    
    
    return self;
    
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.shopImhg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(5);
        make.width.height.mas_equalTo(80);
    }];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_shopImhg.mas_right).mas_equalTo(5);
        make.width.mas_equalTo((kScreenWidth-5-80-5)/3*2);
//        make.height.mas_equalTo(30);
        
    }];
    
    [self.shopPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo((kScreenWidth-5-80-5)/3);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-16);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
    }];
    self.shopName.textColor = HexColorA(0x323232,0.8);
}



- (void)setModel:(ShopModel *)model{
    _model = model;
    [_shopImhg sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    _shopName.text = model.goods_name;
    _shopPrice.text =[NSString stringWithFormat:@"￥%@",model.shop_price];
    
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
