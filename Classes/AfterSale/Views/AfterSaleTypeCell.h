//
//  AfterSaleTypeCell.h
//  Qqw
//
//  Created by zagger on 16/9/7.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleTypeApi.h"

/**
 *  售后类型
 */
@interface AfterSaleTypeCell : UITableViewCell

- (void)refreshWithType:(AfterSaleType *)asType selected:(BOOL)selected;

@end
