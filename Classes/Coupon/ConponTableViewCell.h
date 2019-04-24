//
//  ConponTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/15.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponTableViewController.h"
#import "ConponModel.h"
@interface ConponTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton *useAction;   //立即使用
@property (nonatomic,strong)UIImageView *bgView;   //优惠券背景

@property (nonatomic,strong)UILabel *componName;   //优惠券名
@property (nonatomic,strong)UILabel *componDetailName; //优惠券副标题
@property (nonatomic,strong)UILabel *deadLine;    //有效期限
@property (nonatomic,strong)UILabel *typeLabel;   //优惠券类型

@property (nonatomic,strong,readonly)ConponModel *model;

-(void)setDataWithType:(CouponType)type conponModel:(ConponModel*)model;

@end
