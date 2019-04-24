//
//  AttentionTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionModel.h"
typedef void (^addToAttention)(AttentionModel *model);
@interface AttentionTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subTitleLabel;
@property (nonatomic,strong)UIButton *attentionButton;
@property (nonatomic,strong)addToAttention addAttention;
@property (nonatomic,strong)AttentionModel *model;
@property (nonatomic,strong)UIImageView *line;

@end
