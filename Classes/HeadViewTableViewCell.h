//
//  HeadViewTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/4/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCountModel.h"

@interface HeadViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;


@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@property (weak, nonatomic) IBOutlet UIButton *cxBut;
@property (weak, nonatomic) IBOutlet UIButton *gzBut;

@property(nonatomic,strong) OrderCountModel * orderCountModel;

@end
