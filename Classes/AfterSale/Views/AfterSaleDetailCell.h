//
//  AfterSaleDetailCell.h
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleModel.h"

@interface AfterSaleDetailCell : UITableViewCell

- (void)refreshWithModel:(AfterSaleDetailList *)model isTop:(BOOL)isTop;

@end
