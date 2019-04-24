//
//  PrivateTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateMsgModel.h"
@interface PrivateTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconView;

@property(nonatomic,strong)UILabel *nickNameLabel;

@property(nonatomic,strong)UILabel *InfoLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *redPoint;

@property(nonatomic,strong)UIImageView *line;


@property(nonatomic,strong) PrivateMsgModel *model;
@end
