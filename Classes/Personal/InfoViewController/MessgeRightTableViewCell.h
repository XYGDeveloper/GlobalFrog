//
//  MessgeRightTableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/14.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface MessgeRightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic,strong) ChatModel * chatModel;


@end
