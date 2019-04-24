//
//  OrderDetailFoldCell.h
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailFoldCell : UITableViewCell

@property (nonatomic, copy) void(^foldBlock)(void);
- (void)refreshWithFold:(BOOL)isFold foldCount:(NSInteger)foldCount;

@end
