//
//  MessgeLeftTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/14.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "MessgeLeftTableViewCell.h"

@implementation MessgeLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImgView.layer.cornerRadius = 25;
    self.backgroundColor = [UIColor clearColor];
}


-(void)setChatModel:(ChatModel *)chatModel{
    _chatModel = chatModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:chatModel.sface] placeholderImage:[UIHelper smallPlaceholder]];
    _timeLabel.text  = chatModel.dateline;
    _msgLabel.text = chatModel.content;;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
