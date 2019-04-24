//
//  TableViewCell.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/17.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WHC_AutoLayout.h"

typedef void(^toComment)();
@interface TableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImg;
@property (nonatomic, strong)UILabel *nikeName;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *commentContent;
@property (nonatomic, strong)UIImageView *arctile_img;
@property (nonatomic, strong)UILabel *arctile_content;
@property (nonatomic, strong)UIButton *comment;
@property (nonatomic,strong)toComment commentBlock;



@end
