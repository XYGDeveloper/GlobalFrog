//
//  GoodsTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/7.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartGoodsModel.h"

@interface GoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(nonatomic,strong) CartGoodsModel * goods;

@end
