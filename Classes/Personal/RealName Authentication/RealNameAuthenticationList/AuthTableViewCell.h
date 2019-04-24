//
//  AuthTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/16.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealListModel.h"

typedef void (^SetAsDefaultRealNameIdentity)();
typedef void (^ToDeleteRealNameIdentity)();
@interface AuthTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBut;
@property (weak, nonatomic) IBOutlet UIButton *deletBut;

@property(nonatomic,strong) RealListModel * realListModel;

@property (nonatomic,strong)SetAsDefaultRealNameIdentity setDefaultRealName;
@property (nonatomic,strong)ToDeleteRealNameIdentity toDelete;

@end
