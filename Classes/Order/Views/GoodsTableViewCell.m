//
//  GoodsTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setGoods:(CartGoodsModel *)goods{
    _goods = goods;
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIHelper smallPlaceholder]];
    _goodsNameLabel.text = goods.goods_name;
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %@",goods.sale_price];
    _countLabel.text = [NSString stringWithFormat:@"X%@",goods.goods_number];
    if (goods.is_limit) {
        _goodsImgView.alpha = 0.3;
    }else{
        _goodsImgView.alpha = 1;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
