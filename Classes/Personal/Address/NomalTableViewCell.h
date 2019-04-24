//
//  NomalTableViewCell.h
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@interface NomalTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *nikeName;
@property (nonatomic,strong)UILabel *telephone;
@property (nonatomic,strong)UILabel *address;
@property (nonatomic,strong)UIButton *faultAddress;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)AddressModel *model;
@end
