//
//  PrivateCell.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateMsgModel.h"

@interface PrivateCell : UITableViewCell

@property (nonatomic, strong) UIImageView *faceImg;

@property (nonatomic, strong) UILabel *nickNameLab;

@property (nonatomic, strong) UILabel *privateMsgLab;

@property (nonatomic, strong) UILabel *dateLab;

@property (nonatomic, strong) UIImageView *cutLine;

@end
