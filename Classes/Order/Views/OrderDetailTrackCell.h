//
//  OrderDetailTrackCell.h
//  Qqw
//
//  Created by zagger on 16/8/23.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderTrack;
@interface OrderDetailTrackCell : UITableViewCell

- (void)refreshWithTrack:(OrderTrack *)track;

@end
