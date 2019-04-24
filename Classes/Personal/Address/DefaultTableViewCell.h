//
//  DefaultTableViewCell.h
//  Qqw
//
//  Created by XYG on 16/8/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
typedef void(^PersonCellBlock)(AddressModel *model);
typedef void(^EditBlock)();
@interface DefaultTableViewCell : UITableViewCell

@property(nonatomic,copy)PersonCellBlock btnAction;
@property (nonatomic,copy)EditBlock editBlock;
@property (nonatomic,strong)UILabel *nikeName;
@property (nonatomic,strong)UILabel *telephone;
@property (nonatomic,strong)UILabel *address;
@property (nonatomic,strong)UIButton *faultAddress;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)AddressModel *model;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIButton *defaButton;



@end
