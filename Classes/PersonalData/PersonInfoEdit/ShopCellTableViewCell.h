//
//  ShopCellTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopModel.h"
@interface ShopCellTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *shopImhg;
@property (nonatomic,strong)UILabel *shopName;
@property (nonatomic,strong)UILabel *shopPrice;
@property (nonatomic,strong)UIImageView *line;
@property (nonatomic,strong)ShopModel *model;

@end
