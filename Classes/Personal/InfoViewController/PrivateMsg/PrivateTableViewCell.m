//
//  PrivateTableViewCell.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "PrivateTableViewCell.h"

@implementation PrivateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.InfoLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.redPoint];
        [self.contentView addSubview:self.line];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

-(void)setModel:(PrivateMsgModel *)model{
    _model = model;
    if ([model.newnum isEqualToString:@"0"]) {
        self.redPoint.hidden = YES;
    }
    self.nickNameLabel.text = model.nickname;
    self.InfoLabel.text = model.lastmsg;
    self.timeLabel.text = model.dateline;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:[UIHelper smallPlaceholder]];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@39);
        make.top.left.equalTo(self.contentView).with.offset(10);
        
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(14);
        make.left.equalTo(self.iconView.mas_right).with.offset(17.5);
    }];
    [self.InfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.iconView.mas_right).with.offset(17.5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.nickNameLabel.mas_centerY);
    }];
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6.5);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@309);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView).with.offset(0);
    }];
    
    
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.backgroundColor = [UIColor redColor];
        _nickNameLabel = GeneralLabelA(Font(15), [UIColor blackColor], NSTextAlignmentCenter);
    }
    return _nickNameLabel;
}

- (UILabel *)InfoLabel{
    if (!_InfoLabel) {
        _InfoLabel = [[UILabel alloc] init];
        _InfoLabel = GeneralLabelA(Font(13), TextColor3, NSTextAlignmentCenter);
    }
    return _InfoLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel = GeneralLabelA(Font(11), TextColor3, NSTextAlignmentCenter);
    }
    return _timeLabel;
}

- (UIImageView *)redPoint{
    if (!_redPoint) {
        _redPoint = [[UIImageView alloc] init];
        _redPoint.backgroundColor = HexColor(0xd63d3e);
        _redPoint.layer.cornerRadius = 3.8;
        _redPoint.layer.masksToBounds = YES;
    }
    return _redPoint;
}

- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc] init];
        _line.backgroundColor = HexColor(0xe6e6e6);
    }
    return _line;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
