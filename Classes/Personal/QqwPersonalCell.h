//
//  QqwPersonalCell.h
//  Qqw
//
//  Created by 全球蛙 on 16/7/16.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderCountModel;
typedef void(^PersonCellBlock)(NSInteger index);
@interface QqwPersonalCell : UITableViewCell
@property(nonatomic,copy)PersonCellBlock btnAction;

@property (nonatomic,strong)UILabel *wailtToPayLabel;
@property (nonatomic,strong)UILabel *wailtToSendLabel;
@property (nonatomic,strong)UILabel *wailtToReceLabel;
@property (nonatomic,strong)UILabel *wailtToCommentLabel;
@property (nonatomic,copy)OrderCountModel *model;


@end
